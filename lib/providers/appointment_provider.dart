import 'package:auth_app/models/appointment.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class AppointmentProvider extends ChangeNotifier {
  // String email;
  // AppointmentProvider(this.email);
  List<Appointment> allApointment = [];
  Appointment appointment = Appointment();
  setAppointmentDate(DateTime dateTime) {
    this.appointment.date = dateTime;
    notifyListeners();
  }

  setAppointmentDoctorId(String id) {
    this.appointment.doctorId = id;
    print(this.appointment.doctorId);
    notifyListeners();
  }

  setAppointmentUserId(String userId) {
    this.appointment.userId = userId;
    //notifyListeners();
  }

  setAppointmentTime(String time) {
    this.appointment.time = time;

    notifyListeners();
  }

  List<Appointment> pastApointment = [];
  List<Appointment> upcomingApointment = [];
  addNewAppointment(Event event) {
    //allApointment.add(Appointment.fromSnaopShot(event.snapshot));
    notifyListeners();
  }

  getAllApointment() async {
    allApointment=[];
    try {
      DataSnapshot dataSnapshot = await FirebaseDatabase.instance
          .reference()
          .child('appointments')
          .once();
      Map<dynamic, dynamic> f = dataSnapshot.value;
      print(f.length);
      f.forEach((key, value) {
        // print(value);
        allApointment.add(Appointment.fromKeyValue(key, value));
      });
    } catch (error) {
      print(error);
    }
  }

  Future<List<Appointment>> getpastApointment(String uid) async {
    
    await getAllApointment();
    return pastApointment = allApointment
        .where((element) => element.userId == uid)
        .where((element) => !element.date.isAfter(DateTime.now()))
        .toList();
  }

  Future<List<Appointment>> getUpcomingApointment(String uid) async {
    await getAllApointment();
    return upcomingApointment = allApointment
        .where((element) => element.userId == uid)
        .where((element) => element.date.isAfter(DateTime.now()))
        .toList();
  }
}
