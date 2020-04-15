import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:harmony/repository/user_data_repository.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final UserDataRepository _userDataRepository;

  UserRepository(
      {FirebaseAuth firebaseAuth,
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

  Future<void> signUp({String email, String password, bool isPatient}) async {
    AuthResult result = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .catchError((e) => print(e.toString()));

    String uid = result.user.uid;

    if (isPatient != true) {
      _userDataRepository
        ..userID(uid)
        ..updatePatientData(email: email);
    } else if (isPatient = true) {
      _userDataRepository
        ..userID(uid)
        ..updateRelativeData(email: email);
    }

    //TODO: Create User Firestore documents here.
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
