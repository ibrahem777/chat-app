import 'dart:async';

import 'package:auth_app/models/appointment.dart';
import 'package:auth_app/models/doctor.dart';
import 'package:auth_app/models/times_of_day.dart';
import 'package:auth_app/providers/appointment_provider.dart';
import 'package:auth_app/providers/dates_schedule.dart';
import 'package:auth_app/providers/doctors.dart';

import 'package:auth_app/screens/feedback_screen.dart';
import 'package:auth_app/widgets/user/seconed_book_tab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookScreen extends StatefulWidget {
  @override
  _BookScreenState createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen>
    with SingleTickerProviderStateMixin {
  TabController controller;
  DatabaseReference databaseReference;
  StreamSubscription newAppointmentStream;
  String buttonText = 'next';
  var _index = 0;
  var isChecked = false;
  String uid;
  var ischange = true;
  

  
    

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(length: 3, vsync: this);
  }

  increaseIndex(BuildContext context) async {
   
    if (_index == 2) {
       final uid = await FirebaseAuth.instance.currentUser();
    Provider.of<AppointmentProvider>(context, listen: false)
        .setAppointmentUserId(uid.uid);
      await Firestore.instance.collection('appointments').add(
          Provider.of<AppointmentProvider>(context, listen: false)
              .appointment
              .toJson());
      Navigator.of(context).pushReplacementNamed(FeedbackScreen.routeName);
    } else if (_index == 1) {
      setState(() {
        buttonText = 'book';
        _index++;
      });
    } else {
      setState(() {
        _index++;
      });
    }
  }

  decreaseIndex() {
    if (_index == 0) {
    } else {
      setState(() {
        buttonText = 'next';
        _index--;
      });
    }
  }

 

  bool radioValue = false;
  Doctor doctor;
  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Book Appointment',
            style: TextStyle(fontSize: 30),
          ),
          Text('Book Appointment in smile'),
          Text((Provider.of<Doctors>(context).adoctor != null
                  ? Provider.of<Doctors>(context).adoctor.name
                  : '') +
              (Provider.of<DatesSchedule>(context, listen: false)
                          .appointmentTimes !=
                      null
                  ? '  ${Provider.of<DatesSchedule>(context, listen: false).appointmentTimes.date.month} ${Provider.of<DatesSchedule>(context, listen: false).appointmentTimes.date.day}'
                  : '')),
          Expanded(
            child: Card(
              child: TabBarView(
                controller: controller,
                children: <Widget>[
                  FutureBuilder<List<Doctor>>(
                      future: Provider.of<Doctors>(context).getAllDoctors(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Row(
                                children: <Widget>[
                                  Radio<Doctor>(
                                    value: snapshot.data[index],
                                    onChanged: (val) {
                                      Provider.of<Doctors>(context,
                                              listen: false)
                                          .setDoctor(
                                        snapshot.data[index],
                                      );
                                      print(snapshot.data[index].id);
                                      setState(() {
                                        doctor = val;
                                      });
                                      print(doctor.id);
                                      Provider.of<AppointmentProvider>(context,
                                              listen: false)
                                          .setAppointmentDoctorId(doctor.id);
                                    },
                                    groupValue: doctor,
                                  ),
                                  Expanded(
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        child: Text('image'),
                                      ),
                                      title: Text(snapshot.data[index].name),
                                      subtitle:
                                          Text(snapshot.data[index].specialty),
                                      trailing: IconButton(
                                          icon: Icon(Icons.arrow_forward_ios),
                                          onPressed: null),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          return Container();
                        }
                      }),
                  ////////////////////
                  SeconedTab(),
                  //////////////////////
                  ListView.builder(
                    itemCount: 4,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text('image'),
                          ),
                          title: Text('doctor name'),
                          subtitle: FittedBox(child: Text('Doctor spishalist')),
                          trailing: IconButton(
                              icon: Icon(Icons.arrow_forward_ios),
                              onPressed: null),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Row(
            //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RaisedButton(
                  color: Colors.white,
                  child: Text(
                    'back',
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
                    decreaseIndex();
                    controller.animateTo(_index);
                  }),
              Expanded(child: SizedBox()),
              RaisedButton(
                onPressed: () {
                  increaseIndex(context);
                  controller.animateTo(_index);
                },
                child: Text(
                  buttonText,
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
