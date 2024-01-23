import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_notes_app/services/cloud/cloud_note.dart';
import 'package:my_notes_app/services/cloud/cloud_storage_constants.dart';
import 'package:my_notes_app/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  //................................................
  // to delete the note, first path which is documentId, and then delete();
  Future<void> deleteNote(String documentId) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteException();
    }
  }

  //...............................
  /// to update note;
  /// documentId, which document in notes collection and then update which field with which text?
  Future<void> updateNote(
    String documentId,
    String text,
  ) async {
    try {
      await notes.doc(documentId).update(
        {
          textFieldName: text,
        },
      );
    } catch (e) {
      throw CouldNotUpdateNotesException();
    }
  }

  //.................................................................
  /////1st: allnotes method which return the stream of iterable, take it as a list, requiring owneruserid;
  ///2nd: notes is the collection, and snapshot means all the doucment in that collection, so each document of notes;
  ///3rd map is use to transform the data to key and value context, event represents each snapshot or document of current state
  ///so map event/each snapshot;
  ///4th: event.docs access the document in each snapshot means document in the document of notes,and then mapping the result to cloudnote.fromsnapshot
  ///and what to map, if the owneruserid of note is equal to the given owneruserid in the parameter;
  Stream<Iterable<CloudNote>> allNotes(String ownerUserId) =>
      notes.snapshots().map((event) => event.docs
          .map((doc) => CloudNote.fromsnapshot(doc))
          .where((note) => note.ownerUserId == ownerUserId));

  //getting user notes...
  Future<Iterable<CloudNote>> getNotes(String ownerUserId) async {
    try {
      return await notes //return the collection(notes)
          .where(
            // its like filtering which one has to return
            ownerUserIdFieldName, //searched for owneruseridfieldname user id,
            isEqualTo: ownerUserId, //equal to the provided owneruser id
          )
          .get() //getting the document
          .then(
            // value represents result; and value.docs represents list of documents in a value
            (value) => value.docs.map(
              //and then mapping these docs into given variables,which are decalared in cloudnote class;
              (doc) {
                return CloudNote.fromsnapshot(doc);
                // CloudNote(
                //     documentId: doc
                //         .id, //each document have an id, so put it in document id
                //     ownerUserId:
                //         doc.data()[ownerUserIdFieldName] as String, //user id
                //     text:
                //         doc.data()[textFieldName] as String); //and a text/note;
              },
            ),
          );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Future<CloudNote> createNewNote(String ownerUserId) async {
    // creating note in firebase requierd are user id,
    // then notes which represents the collection in firebase, we want to add document in which owneruseridfiled is owneruserid,and textfieldname is text
    // which is not decided yet;
    final document = await notes.add(
      //storing it in document variable when it is created in database;
      {
        ownerUserIdFieldName: ownerUserId,
        textFieldName: '',
      },
    );
    final fetchedNote = await document
        .get(); //then getting it back from firebase when note is created;
    // and then returning it back to user, maybe for some operations later, but don't know yet;
    return CloudNote(
        documentId: fetchedNote.id, ownerUserId: ownerUserId, text: '');
  }

  // THIS IS THE WAY OF MAKING THE CLASS SINGLETON, MEANS IT WILL HAVE ONLY ONE INSTANCE IN WHOLE APPLICATION;
  //FIRST, _SHAREDINSTANCE IS AN INSTANCE OF THIS CLASS, ASSIGNED TO _SHARED WHICH IS TO SAVE THAT INSTANCE;
  //2ND, THEN IT ACTUALLY KEEP THAT INSTANCE IN THE 3RD LINE;
  //3RD, FACTORY WHICH IS RESPONSIBLE TO CREATE A NEW INSTANCE, OR THE EXISTING ONE;
  //AT FIRST, THE FACTORY WILL CHECK THAT THE SHAREDINSTANCE IS NULL SO IT WILL CREATE ONE INSTANCE,
  //IF THE CLASS IS CALLED AGAIN, IT WILL CHECK IF IT IS NULL OR NOT, ABVIOUSLY NOT NULL, SO IT WILL RETURN THE SAME INSTANCE;
  //.................................... MAKING SINGLETON THE CLASS;
  static final FirebaseCloudStorage _shared = //1
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance(); //2
  factory FirebaseCloudStorage() => _shared; //3
  //........................................... MAKING SINGLETION THE CLASS;

// collection is the group of documents so when we access the collection, it have all the documents;
  final notes = FirebaseFirestore.instance
      .collection('notes'); // accessing the notes collection
}
