// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:my_notes_app/constants/routes.dart';
import 'dart:developer' as devtools show log;

import 'package:my_notes_app/services/auth/auth_service.dart';
import 'package:my_notes_app/services/cloud/cloud_note.dart';
import 'package:my_notes_app/services/cloud/firebase_cloud_storage.dart';
import 'package:my_notes_app/utilities/dialogues/logout_dialog.dart';
import 'package:my_notes_app/views/notes_listview.dart'; //package developer, and i want to only access the log function as a devtools to lower the chances of,
// confusion as a developer, because if the programmer make a function named log, so the developer function as also log, so what i did is that ,
// whenever i use the developer function i will do that like   DEVTOOLS.LOG(), so its kinda simple to recognise.

enum MenuActions {
  logout,
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final FirebaseCloudStorage
      _notesService; // creating the instance of Notservice class;
  String get userId => AuthServices.firebase()
      .currentUser!
      .id; // getting the email of current user, with the help of getter;
  @override
  void initState() {
    _notesService = FirebaseCloudStorage();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(" Home Page"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
              },
              icon: const Icon(Icons.add)),
          // this is where we place buttons etc, in the end of the appbar.
          PopupMenuButton<MenuActions>(
            //This creates a button that, when pressed, displays a popup menu.
            onSelected: (value) async {
              switch (value) {
                case MenuActions.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  // declared a variable to store the future function, either it will return false or true;
                  if (shouldLogout == true) {
                    devtools.log(shouldLogout.toString());
                    await AuthServices.firebase()
                        .logOut(); // the function of firebase auth use to signout the user;
                    Navigator.of(context).pushReplacementNamed(logRoute);
                  }
                //just print that value;
              }

              //used the developer package for debugging, it is like a print but dart allows us log instead of print.
            },
            // This is a callback function that gets triggered when a menu item is selected.
            // It receives the selected value as a parameter (value). In this case, the parameter type is inferred to be MenuActions.
            itemBuilder: (context) {
              //This is a function that defines the items in the popup menu. It returns a list of PopupMenuEntry widgets.
              return const [
                // This is where you define the menu items. In this example, there's only one item, a PopupMenuItem.
                PopupMenuItem<MenuActions>(
                    value: MenuActions.logout, child: Text("logout"))
              ];
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: _notesService.allNotes(userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;
                return NotesListView(
                  onTap: (note) {
                    Navigator.of(context)
                        .pushNamed(createOrUpdateNoteRoute, arguments: note);
                  },
                  notes: allNotes,
                  onDeleteNote: (notes) async {
                    await _notesService.deleteNote(notes.documentId);
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
