import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthSource {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<GoogleSignInAccount?> signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await _googleSignIn.signIn();

    if (gUser == null) {
      throw {"detail": "cancel"};
    }

    final GoogleSignInAuthentication gAuth = await gUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    await _firebaseAuth.signInWithCredential(credential);

    return gUser;
  }

  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
  }
}
