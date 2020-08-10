import 'package:firebase_database/firebase_database.dart';

class Appointment {
  String key;
  String userId;
  String doctorId;
  String time;
  DateTime date;
  setTime(String time){
    this.time=time;
  }

  Appointment({this.key,this.userId, this.doctorId, this.time, this.date});
  Appointment.fromSnaopShot(DataSnapshot dataSnapshot) {
    this.key = dataSnapshot.key;
    this.userId = dataSnapshot.value['userId'];
    this.doctorId = dataSnapshot.value['doctorId'];
    this.time = dataSnapshot.value['time'];
    this.date = DateTime.parse(dataSnapshot.value['date']) ;
  }
  Appointment.fromKeyValue( key,value) {
    this.key = key;
    this.userId = value['userId'];
    this.doctorId =value['doctorId'];
    this.time = value['time'];
    this.date = DateTime.parse(value['date']) ;
  }
   
  toJson(){
    
    return{'userId':this.userId,
    'doctorId':this.doctorId,
    'time':this.time,
    'date':this.date.toString()};
  }
}
