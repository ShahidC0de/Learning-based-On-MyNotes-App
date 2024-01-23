import 'package:flutter/material.dart';
import 'package:my_notes_app/constants/routes.dart';
import 'package:my_notes_app/notes/new_notes_view/create_update_noteview.dart.dart';
import 'package:my_notes_app/notes/note_view.dart';
import 'package:my_notes_app/login_view.dart';
import 'package:my_notes_app/registerView.dart';

import 'package:my_notes_app/views/welcome_page.dart';

void main() {
  WidgetsFlutterBinding
      .ensureInitialized(); //ensure that the Flutter framework is properly set up before performing asynchronous tasks
  // or other initialization steps in your Flutter application.
  runApp(MaterialApp(
    title: 'Flutter Demo',
    routes: {
      //the folder i created named constants there is a file named routes, in the file i declared this variables logRoute etc... which is equal to its names
      logRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      homePageRoute: (context) => const HomePage(),
      welcomePage: (context) => const WelcomePage(),
      createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
    },
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const WelcomePage(),
  ));
}
// the one thing i left is that when a user is already logged in, and when he exit the app so again he has to put email and password to login,
// so this is the work which is necessary to do later;
