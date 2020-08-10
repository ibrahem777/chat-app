import 'dart:ui';

import 'package:auth_app/models/appointment.dart';
import 'package:auth_app/providers/appointment_provider.dart';
//import 'package:auth_app/providers/auth.dart';
import 'package:auth_app/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppointmentScreen extends StatefulWidget {
  // String email;
  // AppointmentScreen(this.email);

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen>
    with SingleTickerProviderStateMixin {
  List<Appointment> show = [];
  TabController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
   // String uid = Provider.of<Auth>(context).user.uid;
   

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Your Appointment',
            style: TextStyle(fontSize: 30),
          ),
          TabBar(
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.blue,
            controller: controller,
            tabs: <Widget>[
              Tab(
                child: Container(child: Text('past')),
              ),
              Tab(
                child: Container(child: Text('upcoming')),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(controller: controller, children: [
              //////////
              FutureBuilder(
                future: FirebaseAuth.instance.currentUser(),
                              builder:(context,userSnapShot){
                                 if(userSnapShot.connectionState ==ConnectionState.waiting){
                                    return Center(child: CircularProgressIndicator());
                                  }
                                
                                  else{
                                return StreamBuilder(
                stream: Firestore.instance.collection('appointments').where('userId',isEqualTo: userSnapShot.data.uid).snapshots(),
       
                  
                                builder: ( context, AsyncSnapshot<QuerySnapshot>  snapshots) { 
                                  if(snapshots.connectionState ==ConnectionState.waiting){
                                    return Center(child: CircularProgressIndicator());
                                  }
                                 else if(snapshots.hasData){
                                   if(snapshots.data.documents.isEmpty){
                                     return Center(child:Text('no data'));
                                   }
                                    final docs=snapshots.data.documents;
                                    return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      print(docs.length);
                       print(docs[index].documentID);
                       
                   Appointment  appointment=Appointment.fromKeyValue(docs[index].documentID, docs[index].data);
                   print(appointment.toJson());
                 //  print(appointment.date);
                      return Container(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height * .5,
                          minWidth: MediaQuery.of(context).size.width * .9,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.blue[800],
                              Colors.blue[600],
                              Colors.blue[400],
                              Colors.blue[200],
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'in 3 days',
                                style: TextStyle(
                                    color: Theme.of(context).textSelectionColor),
                              ),
                              Text(
                                'consulating With ',
                                style: TextStyle(
                                    color: Theme.of(context).textSelectionColor),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Icon(
                                    Icons.calendar_today,
                                    color: Colors.white,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Text('',
//'${appointment.date.month} ${appointment.date.day}',
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).textSelectionColor),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                //  mainAxisAlignment: MainAxisAlignment.center,

                                children: <Widget>[
                                  Icon(
                                    Icons.access_time,
                                    color: Colors.white,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Text('',
                                   //   '${appointment.time}',
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).textSelectionColor),
                                    ),
                                  ),
                                ],
                              ),
                             
                              FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                  ),
                                  color: Colors.white70,
                                  padding: EdgeInsets.all(20),
                                  child: Text(
                                    'Reschedule',
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).textSelectionColor),
                                  ),
                                  onPressed: () {})
                            ],
                          ),
                        ),
                      );
                    },
                    
                  );
                                  }else{
                                   // print(snapshot.data.length);
                                    return Container();
                                  }

                                 },
                                 
                );}}
              ),
              ///////////////////////////////////
              ///
             FutureBuilder<List<Appointment>>(
               // future: Provider.of<AppointmentProvider>(context).getUpcomingApointment(uid)
       
                
                              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { 
                                if(snapshot.hasData){
                                  
                                  return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    print(snapshot.data.length);
                     print(snapshot.data[index]);
                 Appointment  appointment=snapshot.data[index];
                 print(appointment.date);
                    return Container(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height * .5,
                        minWidth: MediaQuery.of(context).size.width * .9,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.blue[800],
                            Colors.blue[600],
                            Colors.blue[400],
                            Colors.blue[200],
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'in 3 days',
                              style: TextStyle(
                                  color: Theme.of(context).textSelectionColor),
                            ),
                            Text(
                              'consulating With ',
                              style: TextStyle(
                                  color: Theme.of(context).textSelectionColor),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Text(
                                    '${appointment.date.month} ${appointment.date.day}',
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).textSelectionColor),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              //  mainAxisAlignment: MainAxisAlignment.center,

                              children: <Widget>[
                                Icon(
                                  Icons.access_time,
                                  color: Colors.white,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Text(
                                    '${appointment.time}',
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).textSelectionColor),
                                  ),
                                ),
                              ],
                            ),
                           
                            FlatButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                                color: Colors.white70,
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  'Reschedule',
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).textSelectionColor),
                                ),
                                onPressed: () {})
                          ],
                        ),
                      ),
                    );
                  },
                  
                );
                                }else{
                                 // print(snapshot.data.length);
                                  return Container();
                                }

                               },
                               
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
