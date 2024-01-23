import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

//this function belongs to the state where we get the user when its registration is completed;
//e.g:   final user = firebaseauth.instance.currentuser;
// the below class is to manipulate with the properties of that user;
@immutable //means that the class will be immutable mean not changable, subclasses etc...
class AuthUser {
  final String id;
  // the place where we are logging in to the app, we only requires, is the user emailverified?
  //the emailverify is the status of the current user now, so we need it and it belongs to the user...
  final String? email;
  final bool isEmailVerified;
  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
  }); //a constructor

  factory AuthUser.fromFirebase(User user) => AuthUser(
        id: user.uid,
        email: user.email,
        isEmailVerified: user.emailVerified,
      );
  //factory constructor is like a strong approach to handle things, it can decide what to return,
  //normal constructor is a stright forward, means it just initialize things.
  //so factory is a constructor, AuthUser is a class name to which the constructor belongs,
  // fromfirebase is a name of constructor,
  //in paranthesis the "User" is a real person created in firebase.
  //"user " is the object i created to store that "User".
  //now remember the above normal constructor which is responsible only to intialize value to the bool isEmailVerified;
  //so, "user" is now "User", and i passed the value emailverified which have the firebase user.
  //i copied that value and paste it in my local value isEmailVerified.
  // so now if i access the AuthUser class it will provide me whether the current user is emailverified or not?
}
