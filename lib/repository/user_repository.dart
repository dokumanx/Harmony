import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:harmony/models/user.dart';
import 'package:harmony/repository/user_data_repository.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final UserDataRepository _userDataRepository;
  String uid;

  UserRepository({FirebaseAuth firebaseAuth,
    GoogleSignIn googleSignIn,
    UserDataRepository userDataRepository})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _userDataRepository = userDataRepository ?? UserDataRepository();

  ///Authentication methods begins,

  Future<FirebaseUser> signInWithGoogle() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    await _firebaseAuth.signInWithCredential(credential);

    return _firebaseAuth.currentUser();

    //TODO: GoogleSingIn Could be disable
  }

  Future<void> signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signUp({String email, String password, bool isRelative}) async {
    AuthResult _authResult = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .catchError((e) => print(e.toString()));

    if (isRelative != true) {
      _userDataRepository
        ..setPatientData(
            email: email,
            userType: UserType.patient,
            uid: _authResult.user.uid);
    } else if (isRelative = true) {
      _userDataRepository
        ..setRelativeData(
            email: email,
            userType: UserType.relative,
            uid: _authResult.user.uid);
    }
  }

  Future<void> singOut() {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    return (await _firebaseAuth.currentUser()) != null;
  }

  /// ends
  /// Firestore Methods Begins

  Future<String> getUserId() async {
    return (await _firebaseAuth.currentUser()).uid;
  }
}
