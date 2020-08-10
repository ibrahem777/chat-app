import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../widgets/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
      final _auth = FirebaseAuth.instance;
var _isLoading=false;
  @override
  Widget build(BuildContext context) {
    void _submitAuthForm(String email, String password, String userName,
        bool islogin, BuildContext ctx) async {
      AuthResult authResult;
      try {
        setState(() {
          _isLoading=true;
        });
        if (islogin) {
          authResult = await _auth.signInWithEmailAndPassword(
              email: email, password: password);
        } else {
          authResult = await _auth.createUserWithEmailAndPassword(
              email: email, password: password);
          await Firestore.instance
              .collection('users')
              .document(authResult.user.uid)
              .setData({'email': email, 'name': userName});
        }
      } on PlatformException catch (error) {
        var message = 'error occuared';
        if (error != null) {
          message = error.message;
        }
        Scaffold.of(ctx).showSnackBar(SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ));
         setState(() {
          _isLoading=false;
        });
      } catch (error) {
         setState(() {
          _isLoading=false;
        });
        print(error);
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: AuthForm(_submitAuthForm,_isLoading),
    );
  }
}
