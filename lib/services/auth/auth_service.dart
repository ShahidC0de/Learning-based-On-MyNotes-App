import 'package:my_notes_app/services/auth/auth_provider.dart';
import 'package:my_notes_app/services/auth/auth_user.dart';
import 'package:my_notes_app/services/auth/firebase_auth_provider.dart';
//auth service will be use to expose the functionality of authprovider to the user.
//its like i can initialize the login or logout something, but i will not do such a heavy lifting,
//instead i will give it to authprovider.

class AuthServices implements AuthProvider {
  final AuthProvider provider;

  const AuthServices(this.provider);
  factory AuthServices.firebase() => AuthServices(FirebaseAuthProvider());
  //this is how it access the firebaseAuthProvider which is actual a concrete class,
  // or engine which interacts with firebase;
  //using the factory constructor and provide the provider.

  @override
  Future<AuthUser> createUser(
          {required String email, required String password}) =>
      provider.createUser(email: email, password: password);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({required String email, required String password}) =>
      provider.logIn(email: email, password: password);

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initializeFirebase() => provider.initializeFirebase();
}
