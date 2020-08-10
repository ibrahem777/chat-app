import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth extends ChangeNotifier{
  //Auth._();
 // static Auth auth = Auth._();
  FirebaseAuth _instence = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseUser _user;

  Future<FirebaseUser> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      AuthResult authResult = await _instence.createUserWithEmailAndPassword(
          email: email, password: password);
      _user = authResult.user;
      return _user;
    } catch (error) {
      print(error);
    }
  }

  Future<FirebaseUser> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      AuthResult authResult = await _instence.signInWithEmailAndPassword(
          email: email, password: password);
      _user = authResult.user;
      return _user;
    } catch (error) {
      print(error);
    }
  }

  Future<FirebaseUser> signOut() async {
    try {
      await _instence.signOut();
      _googleSignIn.signOut();
      _user = null;
      //   GoogleSignInAccount acount =await _googleSignIn.signOut();
      //   acount.email;
      //  await  _googleSignIn.disconnect();
      return _user;
    } catch (error) {
      print(error);
    }
  }

  Future<FirebaseUser> checkLoggedin() async {
    _user = await _instence.currentUser();
    return _user;
  }

  Future<FirebaseUser> registerWithGoogle() async {
    try {
      GoogleSignInAccount googleAcount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleAcount.authentication;
      String idToken = googleAuth.idToken;
      String accessToken = googleAuth.accessToken;
      AuthCredential credintial = GoogleAuthProvider.getCredential(
          idToken: idToken, accessToken: accessToken);
      _user = (await _instence.signInWithCredential(credintial)).user;
      return _user;
    } catch (error) {
      print(error);
    }
  }
}
