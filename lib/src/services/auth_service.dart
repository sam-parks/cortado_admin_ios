
import 'package:cortado_admin_ios/src/data/cortado_user.dart';
import 'package:cortado_admin_ios/src/locator.dart';
import 'package:cortado_admin_ios/src/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  UserService get _userService => locator.get();

  AuthService(this._firebaseAuth);

  Future<User> signIn(String email, String password) async {
    try {
      UserCredential authResult = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      if (authResult.user != null) {
        return authResult.user;
      }

      return null;
    } catch (e) {
      throw e;
    }
  }

  

  Stream<User> listenForUser() {
    return _firebaseAuth.authStateChanges();
  }

  Future<bool> isEmailInUse(String email) async {
    var list;
    try {
      print(email);
      list = await _firebaseAuth.fetchSignInMethodsForEmail(email);
    } catch (e) {
      print(e);
    }
    return list.isNotEmpty;
  }

  Future<User> signUp(String email, String password) async {
    UserCredential authResult = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    return authResult.user;
  }

  Future<User> handleGoogleSignIn(bool createUser) async {
    // hold the instance of the authenticated user
    User user;

    try {
      bool isSignedIn = await _googleSignIn.isSignedIn();
      if (isSignedIn) {
        // if so, return the current user
        user = _firebaseAuth.currentUser;
      } else {
        final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // get the credentials to (access / id token)
        // to sign in via Firebase Authentication

        final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
        user = (await _firebaseAuth.signInWithCredential(credential)).user;

        // create a user with google info
        if (createUser) {
          List<String> googleName = googleUser.displayName.split(" ");
          bool exists = await _userService.userExists(user);
          if (exists) {
            throw "CORTADO_ACCOUNT_ALREADY_EXISTS_WITH_GOOGLE_CREDENTIAl";
          }
          CortadoUser newCortadoUser = CortadoUser(
              firstName: googleName.first,
              lastName: googleName.last,
              firebaseUser: user);

          await _userService.saveUser(newCortadoUser);
        }
      }
    } catch (e) {
      if (e == "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL") {
        _firebaseAuth.fetchSignInMethodsForEmail(user.email);
      }

      _googleSignIn.signOut();
      print(e);
      return null;
    }

    return user;
  }

  Future<void> handleGoogleSignOut() {
    return _googleSignIn.signOut();
  }

  Future<User> signUpWithVerification(String email, String password) async {
    UserCredential authResult = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    try {
      await authResult.user.sendEmailVerification();
    } catch (e) {
      print("An error occured while trying to send email verification");
      print(e.message);
    }
    return authResult.user;
  }

  Future<User> getCurrentFBUser() async {
    User user = _firebaseAuth.currentUser;
    return user;
  }

  Future<CortadoUser> getCurrentUser() async {
    CortadoUser user = await _userService.getUser(await getCurrentFBUser());
    return user;
  }

  Future<void> signOut() async {
    handleGoogleSignOut();
    return _firebaseAuth.signOut();
  }

  Future<bool> isEmailVerified() async {
    User user = _firebaseAuth.currentUser;
    return user.emailVerified;
  }

  CortadoUser _userFromFirebase(User user) {
    if (user == null) {
      return null;
    }
    return CortadoUser(
      firebaseUser: user,
    );
  }

  User currentFirebaseUser() {
    return _firebaseAuth.currentUser;
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Stream<CortadoUser> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  Future<CortadoUser> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  Future<CortadoUser> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final authResult = await _firebaseAuth.signInWithCredential(credential);
    return _userFromFirebase(authResult.user);
  }

  signInWithEmailAndPassword(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<User> createUser(String email, String password) async {
    UserCredential credential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    return credential.user;
  }

  Future<CortadoUser> currentUser() async {
    final user = _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }
}
