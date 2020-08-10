import 'package:auth_app/models/times_of_day.dart';
import 'package:flutter/cupertino.dart';

class DatesSchedule extends ChangeNotifier{
  AppointmentTime appointmentTimes;
  
  setAppointmentTime(AppointmentTime val){
    
    
this.appointmentTimes=val;
notifyListeners();


  }
}