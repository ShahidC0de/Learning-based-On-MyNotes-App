// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:registration_app_learning/extentions/list/filter.dart';
// import 'package:registration_app_learning/services/crud_service/crud_exceptions.dart';
// import 'package:sqflite/sqflite.dart'; // for storing data.
// import 'package:path/path.dart'
//     show join; // its like establish a way between the app and database;
// // basically it have the functionality called join, and this is what we need;
// import 'package:path_provider/path_provider.dart'; //it is use to grab the stored data file from the application.

// // this file includes all the functionality which related and connected with sqflite;
// // this files is specially for storing notes of the user, and users.
// // and all other operations which are based on the user and user's notes.
// //  CRUD OPERATION WITH SQFLITE
// // C= CREATE, R= READ, U=UPDATE, D= DELETE, shortform is CRUD.

// @immutable //means each time accessing this class must have the unique paramters values each time;
// class DatabaseUser {
//   // to grab the user in database, remember the user table had the id and email,so lets create it.
//   final int id;
//   final String email;

//   const DatabaseUser({
//     required this.id,
//     required this.email,
//   });
//   //map presents keys and its values, e.g id is string and its value is int, same for email,
//   // the reason i took object as a value because it can be any datatype,so its for flexibility;
//   DatabaseUser.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         email = map[emailColumn] as String;
//   //emailColumn and idColumn are representing the id and email in database which is text;
//   @override
//   String toString() => 'PERSON, ID = $id, email = $email';
//   @override
//   bool operator ==(covariant DatabaseUser other) => id == other.id;
//   //This implementation is checking if the id of the current DatabaseUser instance is equal to the id
//   // of another DatabaseUser instance (other).
//   // If the id values are the same, the two instances are considered equal.

//   @override
//   int get hashCode => id.hashCode;
//   //hashcode is use to locate and pick the object.
//   //in the above code i campared two users if there ids are same treat them equal like they are one,
//   //and then generate the hashcode for it to access it...
// }

// class DatabaseNotes {
//   final int id;
//   final int userId;
//   final String text;
//   final bool isSynchedWithCloud;

//   DatabaseNotes({
//     required this.id,
//     required this.userId,
//     required this.text,
//     required this.isSynchedWithCloud,
//   });
//   DatabaseNotes.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         userId = map[userIdColumn] as int,
//         text = map[textColumn] as String,
//         isSynchedWithCloud =
//             (map[isSynchedWithCloudColumn] as int) == 1 ? true : false;
//   //its because we created it as a int in database but here we only want like is it true or false so..
//   @override
//   String toString() =>
//       'Notes id = $id, userId = $userId,  isSynchedWithCloud = $isSynchedWithCloud, userText = $text,';
//   @override
//   bool operator ==(covariant DatabaseNotes other) => id == other.id;
//   @override
//   int get hashCode => id.hashCode;
// }

// const noteTable = 'notetable'; //storing the note table in a variable;
// const userTable = 'users'; //  storing the user table;
// const dbName = 'RegistrationApp Database.db'; // storing the database name;
// const idColumn = 'id'; //to present the id column
// const emailColumn = 'email'; // to present email column
// const userIdColumn = 'user_id'; //to present the user_id column in database;
// const textColumn = 'text'; // to specify text column;
// const isSynchedWithCloudColumn = 'is_synched_with_cloud'; // and same...
// // for creating user table in database from here using dart.
// const createUserTable = '''CREATE TABLE  IF NOT EXISTS "users"  (
// 	"id"	INTEGER NOT NULL,
// 	"email"	TEXT NOT NULL UNIQUE,
// 	PRIMARY KEY("id" AUTOINCREMENT)
// );
//      ''';
// const createNoteTable = '''
//        CREATE TABLE IF NOT EXISTS "notetable" (
// 	"id"	INTEGER NOT NULL,
// 	"user_id"	INTEGER NOT NULL,
// 	"text"	TEXT,
// 	"is_synched_with_cloud"	INTEGER NOT NULL DEFAULT 0,
// 	PRIMARY KEY("id" AUTOINCREMENT),
// 	FOREIGN KEY("user_id") REFERENCES "users"("id")
// );
// ''';

// // now this is the actual class which will talk to the database, to provide service/functionality...
// class NotesService {
//   Database?
//       _database; // Database is a class which extends the DatabaseExecuter to execute our sqflite commands.
//   DatabaseUser? _user;

//   // to introduce a list of notes in the database, it can be empty in start;
//   List<DatabaseNotes> _notes = [];
//   // making a singleton of a class, means that there can be only one copy of this class in the entire application code;
//   static final NotesService _shared = NotesService._sharedInstance();
//   NotesService._sharedInstance() {
//     _notesStreamController = StreamController<List<DatabaseNotes>>.broadcast(
//       onListen: () {
//         _notesStreamController.sink.add(_notes);
//       },
//     );
//   }
//   factory NotesService() => _shared;

//   // to listen to the stream of data.
//   //streamController is like manager which manages the given data/ controlls;
//   //List<DatabaseNotes> means what data streamcontroller should manage.
//   //broadcast means that the streamcontroller can be listen in many parts of the application simulanously...

//   late final StreamController<List<DatabaseNotes>> _notesStreamController;

//   // below we are subscribing a  new list to the _notesStreamController;
//   // to grab all the nodes;
//   Stream<List<DatabaseNotes>> get allNotes =>
//       _notesStreamController.stream.filter((note) {
//         final currentUser = _user;
//         if (currentUser != null) {
//           return note.userId == note.id;
//         } else {
//           throw UserShouldBeSetBeforeReadingAllNotes();
//         }
//       });
// // to get or create user;
//   Future<DatabaseUser> getOrCreateUser({
//     required String email,
//     bool setAsCurrentUser = true,
//   }) async {
//     try {
//       await _ensureDbisOpen();
//       final user = await getUser(email: email);
//       if (setAsCurrentUser) {
//         _user = user;
//       }
//       return user;
//     } on CouldNotFindUser {
//       final createdUser = await createUser(email: email);
//       if (setAsCurrentUser) {
//         _user = createdUser;
//       }
//       return createdUser;
//     } catch (e) {
//       rethrow; //Yes, that's correct. When you use rethrow in a catch block, it rethrows the same exception that was caught
//     }
//   }

//   // to get all notes, add it to stream controller;
//   Future<void> _cacheNotes() async {
//     final allNotes = await getAllNotes();
//     // in getAllNotes function the notes we get is an iterable so we have to convert it list before assigning to our list _notes;
//     _notes = allNotes.toList();
//     // adding it to streamcontroller;
//     // adding a list of notes.
//     _notesStreamController.add(_notes);
//   }

//   // to insure the database is open;
//   Future<void> _ensureDbisOpen() async {
//     try {
//       await open();
//     } on DatabaseAlreadyOpenedException {
//       // empty
//     }
//   }

//   // for opening the database;
//   Future<void> open() async {
//     if (_database != null) {
//       throw DatabaseAlreadyOpenedException();
//     }
//     try {
//       final docsPath =
//           await getApplicationDocumentsDirectory(); //the file where the app store the data;
//       final dbPath = join(docsPath.path,
//           dbName); // join function provide transfering the data to database;
//       final database = await openDatabase(dbPath); // and then open database;
//       _database =
//           database; // assigning the opened local database to the above Database remember;

//       // creating a usertable if not exists already, you can create it from here.

//       await database.execute(
//           createUserTable); //executing the const to create the user table;

//       await database.execute(
//           createNoteTable); //executing the const to create the note table;
//       await _cacheNotes(); // when the database is opened, now all notes are available, and the user can now access it.
//     } on MissingPlatformDirectoryException {
//       throw UnableToFindDocumentDirectory();
//     }
//   }

//   // for closing the database;
//   Future<void> close() async {
//     final database = _database;
//     if (database == null) {
//       throw DatabaseIsNotOpen();
//     } else {
//       await database.close();
//       _database = null;
//     }
//   }

//   // we will use this function in every steps in which we manipulate with database
//   Database _getDatabaseOrThrow() {
//     final database = _database; // _database is an instance of Database.
//     if (database == null) {
//       throw DatabaseIsNotOpen();
//     } else {
//       return database;
//     }
//   }

//   // to delete the user;
//   Future<void> deleteUser({required String email}) async {
//     await _ensureDbisOpen();
//     //we are deleting the user through his email;
//     final db =
//         _getDatabaseOrThrow(); //first we are checking whether the database exists or not?
//     final deleteCount = await db //and here we use the delete function;
//         .delete(userTable, where: 'email =?', whereArgs: [email.toLowerCase()]);
//     if (deleteCount != 1) {
//       // if the delete function not exexuted even once its means that execution is not performed;
//       //so if it is not 1, then its not executing;
//       throw CouldNotDeleteUser();
//     }
//   }

// // to insert the user;
//   Future<DatabaseUser> createUser({required String email}) async {
//     await _ensureDbisOpen();
//     final db = _getDatabaseOrThrow();
//     // first we run query whether the user already exist or not using email;
//     final query = await db.query(userTable,
//         limit: 1,
//         where: 'email = ?',
//         whereArgs: [email.toLowerCase()]); // limit means we want one user;
//     if (query.isNotEmpty) {
//       // it means the query is not empty so the user exists,because its not empty;
//       throw UserAlreadyExists();
//     }
//     // otherwise insert the user;
//     // remember the user id is auto increment in database, so its not needed
//     //however we assigned the userId because this user will be equal to that;
//     final userId = await db.insert(userTable, {
//       emailColumn: email.toLowerCase(),
//     });
//     return DatabaseUser(
//       id: userId,
//       email: email,
//     );
//   }

//   // to get the specific user;
//   Future<DatabaseUser> getUser({required String email}) async {
//     await _ensureDbisOpen();
//     final db = _getDatabaseOrThrow();
//     // to find the user if he matches the email;
//     final query = await db.query(userTable,
//         limit: 1, where: 'email=?', whereArgs: [email.toLowerCase()]);
//     //empty means there is not specified user;
//     if (query.isEmpty) {
//       throw CouldNotFindUser();
//     } else {
//       return DatabaseUser.fromRow(
//           query.first); // otherwise return the first row readed;
//     }
//   }

//   // to save the note associated with its owner;
//   Future<DatabaseNotes> createNote({required DatabaseUser owner}) async {
//     await _ensureDbisOpen();
//     final db = _getDatabaseOrThrow();
//     const text = '';
//     // here we are using our function to check if the user exists or not?
//     final dbUser = await getUser(
//         email: owner
//             .email); // and we are giving the owner id, its the databaseuser;
//     if (dbUser != owner) {
//       throw CouldNotFindUser();
//     }
//     //here we are inserting the note using insert function;
//     final noteId = await db.insert(noteTable, {
//       userIdColumn: owner.id,
//       textColumn: text,
//       isSynchedWithCloudColumn: 1,
//     });
//     //and then we are assigning it to databasenotes class instance
//     final note = DatabaseNotes(
//       id: noteId,
//       userId: owner.id,
//       text: text,
//       isSynchedWithCloud: true,
//     );
//     _notes.add(note); // adding it to list;
//     _notesStreamController.add(_notes); // adding list to stream;

//     return note; // its kind of returning the instance to DatabaseNotes;
//   }

//   // to delete the note;
//   Future<void> deleteNote({required int id}) async {
//     await _ensureDbisOpen();
//     final db = _getDatabaseOrThrow();
//     final deleteCount =
//         await db.delete(noteTable, where: 'id = ?', whereArgs: [id]);
//     if (deleteCount == 0) {
//       throw CouldNotFindNote();
//     } else {
//       _notes.removeWhere(
//           (note) => note.id == id); // we are deleting the note through its id;
//       _notesStreamController.add(_notes); // adding a new list to stream;
//     }
//   }

//   // to delete all notes;
//   Future<int> deleteAllNotes() async {
//     await _ensureDbisOpen();
//     final db = _getDatabaseOrThrow();
//     final deletionCount = await db.delete(
//         noteTable); // it will delete all notes and return the rows affected number;
//     _notes = []; // basically we are reseting the user list, which is empty;
//     _notesStreamController.add(_notes); // adding a new list to stream;
//     return deletionCount;
//   }

//   // to get a specific note;
//   Future<DatabaseNotes> getNote({required int id}) async {
//     await _ensureDbisOpen();
//     final db = _getDatabaseOrThrow();
//     final notes = await db.query(
//       noteTable,
//       limit: 1,
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//     if (notes.isEmpty) {
//       throw CouldNotFindNote();
//     } else {
//       final note = DatabaseNotes.fromRow(notes.first);
//       // so here is the funda
//       //when user wants a specific note from database, it is possible that it relies in the _notes list;
//       // so first we delete that specific note in our list.
//       // then we add the note which the user get from this function.
//       // and add it to stream;

//       _notes.removeWhere((note) => note.id == id);
//       _notes.add(note);
//       _notesStreamController.add(_notes);

//       return note;
//     }
//   }

//   // to fetch all notes.
//   Future<Iterable<DatabaseNotes>> getAllNotes() async {
//     await _ensureDbisOpen();
//     final db = _getDatabaseOrThrow();
//     final notes = await db.query(
//       noteTable,
//     );

//     return notes.map((noteRow) => DatabaseNotes.fromRow(
//         noteRow)); //  we are transfering the raw data to more structured form;
//   }

//   // to update the current note;
//   Future<DatabaseNotes> updateNote(
//       {required DatabaseNotes note, required String text}) async {
//     await _ensureDbisOpen();
//     final db = _getDatabaseOrThrow();
//     // above in the function we created an instance of DatabaseNote note;
//     // so we are using our own function to get the user provided note;
//     await getNote(id: note.id);
//     // then we are upadating it;
//     final updateCount = await db.update(
//         noteTable,
//         {
//           textColumn: text,
//           isSynchedWithCloudColumn: 0,
//         },
//         where: 'id = ?',
//         whereArgs: [note.id]);
//     if (updateCount == 0) {
//       throw CouldNotUpdateNote();
//     } else {
//       final updatedNote = await getNote(
//           id: note
//               .id); // and here we are returing the note, because it is now updated;
//       _notes.removeWhere((note) =>
//           note.id == updatedNote.id); // deleting the existing note in list;
//       _notes.add(updatedNote); // then adding the updated note;
//       _notesStreamController.add(_notes); // adding to stream;
//       return updatedNote;
//     }
//   }
// }
