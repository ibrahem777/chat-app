import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';
import 'package:get_app/get.dart';
import 'package:get_app/screens/auth_screen.dart';
import 'package:get_app/screens/location.dart';
import 'package:get_app/screens/users_listview.dart';

import 'controllers/user_state_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
     
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget  {
   
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();

 
  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Center(
            child: Text('error '),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
 
          return
         
          StreamBuilder<User>(stream: FirebaseAuth.instance.authStateChanges(), builder: (context,snapshot){
if(snapshot.hasData){
  return UsersListViewScreen();
}
else{
  return AuthScreen();
}
          });
          //FirebaseAuth.instance.currentUser==null? AuthScreen():UsersListViewScreen();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  
  }
}
