import 'package:my_notes_app/services/auth/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;
  Future<void> initializeFirebase();

// its a getter, getter is use to retrieve specific value of object.
//AuthUser is a return type and it can be null.
// get is a getter.
//current user is a name of getter.
//  //whether return an instance of AuthUser class or null;
  Future<AuthUser> logIn({
    //return authuser, so if it logged in we will need some info about the user we we return an instance of authuser;
    //this method is for logging in ...
    required String email,
    required String password,
  });
  Future<AuthUser> createUser({
    // this is for create user, i mean registration...
    required String email,
    required String password,
  });
  Future<void> logOut();
  //we dont need more info just loggedout simple....

  // its for logging out, ofcourse we don't have to do with the user after logging out, so void...
  Future<void> sendEmailVerification(); // for sending an email verification...
}
