import 'package:auth_app/models/doctor.dart';
import 'package:auth_app/providers/appointment_provider.dart';
import 'package:auth_app/providers/auth.dart';
import 'package:auth_app/providers/dates_schedule.dart';
import 'package:auth_app/providers/doctors.dart';
import 'package:auth_app/providers/user_provider.dart';
import 'package:auth_app/screens/feedback_screen.dart';
import 'package:auth_app/screens/home_page.dart';
import 'package:auth_app/screens/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
     //  ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(
          value: AppointmentProvider(),
        ),
        ChangeNotifierProvider.value(
          value: Doctors(),
        ),
         ChangeNotifierProvider.value(
          value: DatesSchedule(),
        ),
        
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
        
          backgroundColor: Colors.grey[200],
          buttonTheme: ButtonTheme.of(context).copyWith(
            buttonColor: Colors.blue[600],
            textTheme: ButtonTextTheme.primary,
          ),
        ),
       // home: MyHomePage(),
       initialRoute: '/',
        routes: {
          '/':(context)=>MyHomePage(),
          FeedbackScreen.routeName:(context)=>FeedbackScreen(),
          HomePage.routeName:(context)=>HomePage(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 // Future<bool> user;

  @override
  Widget build(BuildContext context) {
    

     
            return StreamBuilder(stream: FirebaseAuth.instance.onAuthStateChanged,builder: (ctx,userSnapshot){

              if(userSnapshot.hasData){
                return HomePage();
              }
              else{
                return SplashScreen();
              }
            });
        
    
  }
}
