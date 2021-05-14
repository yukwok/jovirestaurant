import 'dart:async';

import 'package:jovirestaurant/src/models/application_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jovirestaurant/src/services/firestore_service.dart';
import 'package:rxdart/rxdart.dart';

final RegExp regExpEmail = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

class AuthBloc {
  final _email = BehaviorSubject<String>();
  final _errorMessage = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _user = BehaviorSubject<ApplicationUser>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  // getter
  Stream<String> get email => _email.stream.transform(validateEmail);
  Stream<String> get errorMessage => _errorMessage.stream;
  Stream<String> get password => _password.stream.transform(validatePassword);
  Stream<ApplicationUser> get user => _user.stream;
  Stream<bool> get isValid =>
      CombineLatestStream.combine2(email, password, (email, password) {
        return true;
      });
  String get userId => _user.value.userId;

  //setter
  Function(String) get setEmail => _email.sink.add;
  Function(String) get setPassword => _password.sink.add;

  dispose() {
    _email.close();
    _password.close();
    _user.close();
    _errorMessage.close();
  }

  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (regExpEmail.hasMatch(email.trim())) {
      sink.add(email.trim());
    } else {
      sink.addError('InValid Email Address');
    }
  });

  final validatePassword =
      StreamTransformer<String, String>.fromHandlers(handleData: (p, sink) {
    if (p.length >= 6) {
      sink.add(p);
    } else {
      sink.addError('Password length weak.');
    }
  });

  signupEmail() async {
    print('Signing up with username and password...');

    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: _email.value.trim(), password: _password.value.trim());

      var user = ApplicationUser(
          userId: authResult.user.uid, email: _email.value.trim());
      await _firestoreService.addUser(user);
      print('signup addusered firestore added.');

      _user.sink.add(user);

      print('signup user stream added.');
    } on FirebaseAuthException catch (error) {
      print('signup error :  $error');
      _errorMessage.sink.add(error.message);
    }
  }

  loginEmail() async {
    print('in loginEmail@authBloc');
    try {
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
          email: _email.value.trim(), password: _password.value.trim());
      var user = await _firestoreService.fetchUser(authResult.user.uid);
      _user.sink.add(user);
    } on FirebaseAuthException catch (error) {
      print(error);
      _errorMessage.sink.add(error.message);
    }
  }

  // loginEmail() async {
  //   try {
  //     UserCredential authResult = await _auth.signInWithEmailAndPassword(
  //         email: _email.value.trim(), password: _password.value.trim());
  //     var user = await _firestoreService.fetchUser(authResult.user.uid);
  //     _user.sink.add(user);
  //   } on FirebaseAuthException catch (error) {
  //     print(error);
  //     _errorMessage.sink.add(error.message);
  //   }
  // }

  Future<bool> isLoggedIn() async {
    var firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return false;

    var user = await _firestoreService.fetchUser(firebaseUser.uid);
    if (user == null) return false;

    _user.sink.add(user);
    return true;
  }

  Future<void> logout() async {
    await _auth.signOut();
    print('Logout');

    print('Before sink.add(null), _user.value : ${_user.value}');

    _user.sink.add(null);

    print('After sink.add(null), _user.value : ${_user.value}');
  }

  clearErrorMessage() {
    _errorMessage.sink.add('');
  }
}
