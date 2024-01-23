//login exceptions
class UserNotFoundAuthException implements Exception {}
//implements exception means that this class will behave like the exception class which it extends...
//and same for all these below classes...
// so lets use it like for example:
//   on UserNotFoundException {
// devtools.log("hi this is usernotfound blaaaa, blaaa.....")}
//

class WrongPasswordAuthException implements Exception {}

// register exceptions
class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}
//generic exceptions,
// the above are familier and known exception, however if the exceptions are not matching with them then we use generic exeception,
// it will throw according to the type of exception;

class GenericAuthException implements Exception {}

class UserNotLoggedInException
    implements Exception {}//incase if the user is null, after registration;


