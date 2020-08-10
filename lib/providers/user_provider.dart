// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class Auth extends ChangeNotifier{
  
//  // static Auth auth = Auth._();
//   FirebaseAuth _instence = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   FirebaseUser user;
//   Future<bool>isAuth()async{
//     if(user==null){
//       return false;
//     }else{
//     return true;}
//   }

//    registerWithEmailAndPassword(
//       String email, String password) async {
//     try {
//       AuthResult authResult = await _instence.createUserWithEmailAndPassword(
//           email: email, password: password);
//       user = authResult.user;
//      // return _user;
//      notifyListeners();
//     } catch (error) {
//       print(error);
//     }
//   }
//  loginWithEmailAndPassword(
//       String email, String password) async {
//     try {
//       AuthResult authResult = await _instence.signInWithEmailAndPassword(
//           email: email, password: password);
//       user = authResult.user;
//        notifyListeners();
//     //  return _user;
//     } catch (error) {
//       print(error);
//     }
//   }

//   signOut() async {
//     try {
//       await _instence.signOut();
//       _googleSignIn.signOut();
//       user = null;
//        notifyListeners();
//       //   GoogleSignInAccount acount =await _googleSignIn.signOut();
//       //   acount.email;
//       //  await  _googleSignIn.disconnect();
//     //  return _user;
//     } catch (error) {
//       print(error);
//     }
//   }

//    checkLoggedin() async {
//     user = await _instence.currentUser();
//      notifyListeners();
//    // return _user;
//   }

//    registerWithGoogle() async {
//     try {
//       GoogleSignInAccount googleAcount = await _googleSignIn.signIn();
//       GoogleSignInAuthentication googleAuth = await googleAcount.authentication;
//       String idToken = googleAuth.idToken;
//       String accessToken = googleAuth.accessToken;
//       AuthCredential credintial = GoogleAuthProvider.getCredential(
//           idToken: idToken, accessToken: accessToken);
//       user = (await _instence.signInWithCredential(credintial)).user;
//        notifyListeners();
//      // return _user;
//     } catch (error) {
//       print(error);
//     }
//   }
// }
