// ignore_for_file: unused_local_variable, non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:my_notes_app/constants/routes.dart';
import 'package:my_notes_app/services/auth/auth_exceptions.dart';
import 'package:my_notes_app/services/auth/auth_service.dart';
import 'package:my_notes_app/utilities/dialogues/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email = TextEditingController();
  late final TextEditingController _password = TextEditingController();
  // ignore: annotate_overrides
  void dispose() {
    //used to remove this objects to minmize the memory leak;
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text("Login"),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 12.0,
            ),
            TextField(
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              controller: _email,
              decoration: const InputDecoration(
                hintText: "Enter Your Email",
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            TextField(
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              controller: _password,
              decoration: const InputDecoration(
                hintText: "Enter your password",
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  // await AuthServices.firebase().logOut();

                  try {
                    //const CircularProgressIndicator();
                    //first, if the user is verified otherwise false which has nothing, then signin;
                    //second, second if the user signed in then navigate to the new screen. which is homepage;

                    await AuthServices.firebase()
                        .logIn(email: email, password: password);
                    final user = AuthServices.firebase().currentUser;

                    if (user?.isEmailVerified ?? false) {
                      Navigator.of(context).pushReplacementNamed(homePageRoute);
                      //Navigator.of(context).pop();
                    } else {
                      //show dialog is kind of widget which comes on other scaffold;
                      showErrorDialog(context, 'Email not verified');
                    }
                  } on InvalidEmailAuthException {
                    await showErrorDialog(
                      context,
                      'invalid email or password',
                    );
                  } on WrongPasswordAuthException {
                    await showErrorDialog(context, 'wrong password');
                  } on GenericAuthException {
                    await showErrorDialog(
                      context,
                      'Authentication Error',
                    );
                  }

                  //The userCredential variable is declared with the final keyword, indicating that its value will not change once it is assigned.
                  //crediential is like asset of user , what values the user is consisted. In my code its just an email and password;
                },
                child: const Text("Login")),
            const SizedBox(
              height: 12.0,
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(registerRoute, (route) => false);
                },
                child: const Text("Not registered yet?"))
          ],
        ));
  }
}
