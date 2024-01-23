import 'package:flutter/material.dart';
import 'package:my_notes_app/constants/routes.dart';
import 'package:my_notes_app/notes/note_view.dart';

import 'package:my_notes_app/services/auth/auth_service.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        //The FutureBuilder widget is a powerful Flutter widget that simplifies the process of working with asynchronous operations and
// updating the UI based on the results of those operations.
// It's particularly useful when dealing with Future objects, such as those returned by asynchronous functions or methods.
        body: FutureBuilder(
            // to initialize the Firebase services in a Flutter application.
            // Initializing Firebase is a necessary step before interacting with Firebase features such as authentication,
            // databases, cloud functions, and more
            //TRY AND CATCH BLOCK METHOD ARE USE TO CATCH A SPECIFIC ERROR ABOUT AN PROCESS, LIKE I AM CATCHTING THE ERROR RELATED TO AUTH;
            future: AuthServices.firebase().initializeFirebase(),
            builder: (context, snapshot) {
              //SNAPSHOT: the process of previouse widget, the process can be succeed or failed, but to get that process info;
              //in this case in future builder, i initialize firebase, now is it succeed or failed, builder in the futurebuilder have a copy of that process info;
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  final user = AuthServices.firebase().currentUser;
                  if (user != null && user.isEmailVerified) {
                    return const HomePage();
                    //  Navigator.of(context).pushNamedAndRemoveUntil(
                    //    homePageRoute, (route) => false);
                  } else {
                    return Center(
                      child: Column(
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  logRoute, (route) => false);
                            },
                            child: const Text("login Page"),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    registerRoute, (route) => false);
                              },
                              child: const Text("signup Page")),
                        ],
                      ),
                    );
                  }

                default:
                  return const CircularProgressIndicator(); // its like a laoding screen until the firebase initialized; And its a widget;
              }
            }));
  }
}
