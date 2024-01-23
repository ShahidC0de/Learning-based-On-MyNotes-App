// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:my_notes_app/constants/routes.dart';
import 'package:my_notes_app/services/auth/auth_exceptions.dart';
import 'package:my_notes_app/services/auth/auth_service.dart';
import 'package:my_notes_app/utilities/dialogues/error_dialog.dart';

class RegisterView extends StatefulWidget {
  // ignore: use_super_parameters
  const RegisterView({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // ignore: unused_field

  Future<void> _register() async {
    try {
      await AuthServices.firebase().createUser(
          email: _emailController.text, password: _passwordController.text);
      final user = AuthServices.firebase().currentUser;
      await AuthServices.firebase().sendEmailVerification();

      // Simulate a delay for the user to click on the verification link

      if (user != null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Email Verification sent"),
              content:
                  const Text("Please confirm your email before logging in."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      }
    } on WeakPasswordAuthException {
      await showErrorDialog(
        context,
        'weak password',
      );
    } on EmailAlreadyInUseAuthException {
      await showErrorDialog(
        context,
        'email already in use',
      );
    } on GenericAuthException {
      await showErrorDialog(
        context,
        'Authentication Error',
      );
    } catch (e) {
      await showErrorDialog(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Registration"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: "Enter Your Email",
                ),
              ),
              const SizedBox(height: 12.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Enter Your Password",
                ),
              ),
              const SizedBox(height: 12.0),
              ElevatedButton(
                onPressed: _register,
                child: const Text("Sign Up"),
              ),
              const SizedBox(
                height: 12.0,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(logRoute, (route) => false);
                  },
                  child: const Text("Already have an account? log in"))
            ],
          ),
        ));
  }
}




// class RegisterView extends StatefulWidget {
//   const RegisterView({super.key});

//   @override
//   State<RegisterView> createState() => _RegisterViewState();
// }

// class _RegisterViewState extends State<RegisterView> {
//   late final TextEditingController _email = TextEditingController();
//   late final TextEditingController _password = TextEditingController();
//   late User? _user;
  
//   void dispose() {
//     _email.dispose();
//     _password.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     firebaseInitialize();

//     // TODO: implement initState

//     super.initState();
//   }

//   Future<void> firebaseInitialize() async {
//     await Firebase.initializeApp(
//         options: DefaultFirebaseOptions.currentPlatform);

//     print("firebase initialized");
//     FirebaseAuth.instance.authStateChanges().listen((User? user) {
//       setState(() {
//         user = _user;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Registration"),
//       ),
//       body: Column(
//         children: [
//           TextField(
//             controller: _email,
//             keyboardType: TextInputType.emailAddress,
//             autocorrect: false,
//           ),
//           const SizedBox(
//             height: 12.0,
//           ),
//           TextField(
//             controller: _password,
//             keyboardType: TextInputType.visiblePassword,
//             autocorrect: false,
//           ),
//           TextButton(
//               onPressed: () async {
//                 final email = _email.text;
//                 final password = _password.text;
//                 try {
//                   final UserCredential = await FirebaseAuth.instance
//                       .createUserWithEmailAndPassword(
//                           email: email, password: password);
//                   await UserCredential.user?.sendEmailVerification();

//                   print("email verification has been sent");
//                   Future.delayed(const Duration(seconds: 10));
//                   if (UserCredential.user != null &&
//                       UserCredential.user!.emailVerified) {
//                     print("Email verified");
//                     Navigator.of(context).push(MaterialPageRoute(
//                         builder: (context) => const HomePage()));
//                   } else {
//                     print("Your email is not verified");
//                   }
//                 } catch (e) {
//                   print(UserCredential);
//                   print(e.toString());
//                 }
//               },
//               child: const Text("Register")),
//         ],
//       ),
//     );
//   }
// }
