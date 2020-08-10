import 'package:auth_app/models/appointment.dart';
import 'package:auth_app/models/doctor.dart';
import 'package:auth_app/providers/appointment_provider.dart';
import 'package:auth_app/providers/dates_schedule.dart';
import 'package:auth_app/providers/doctors.dart';
import 'package:auth_app/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedbackScreen extends StatelessWidget {
  static String routeName = '/feedback_bage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              child: Column(
                children: <Widget>[
                  CircleAvatar(),
                  Text('Thanks for Booking'),
                  Text('you booked an appointment'),
                  FittedBox(
                                      child: Text(
                        'with ${Provider.of<Doctors>(context, listen: false).adoctor.name} ${Provider.of<DatesSchedule>(context, listen: false).appointmentTimes.date.year}   ${Provider.of<DatesSchedule>(context, listen: false).appointmentTimes.date.month}   ${Provider.of<DatesSchedule>(context, listen: false).appointmentTimes.date.day} at  ${Provider.of<AppointmentProvider>(context, listen: false).appointment.time}'), ),
                  RaisedButton(
                      child: Text('go to appointments'),
                      onPressed: () {
                        Provider.of<Doctors>(context, listen: false).adoctor =
                            null;
                        Provider.of<DatesSchedule>(context, listen: false)
                            .appointmentTimes = null;
                        Provider.of<AppointmentProvider>(context, listen: false)
                            .appointment = Appointment();

                        Navigator.of(context)
                            .pushReplacementNamed(HomePage.routeName);
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
