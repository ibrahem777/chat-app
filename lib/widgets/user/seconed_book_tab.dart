import 'package:auth_app/models/appointment.dart';
import 'package:auth_app/models/times_of_day.dart';
import 'package:auth_app/providers/appointment_provider.dart';
import 'package:auth_app/providers/dates_schedule.dart';
import 'package:auth_app/providers/doctors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SeconedTab extends StatefulWidget {
  @override
  _SeconedTabState createState() => _SeconedTabState();
}

class _SeconedTabState extends State<SeconedTab> {
  AppointmentTime _selectedDate;
  List<Appointment> show = [];
  Widget biuldTimesWidget() {
    if (_selectedDate != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('${_selectedDate.date.month} ${_selectedDate.date.day}'),
          GridView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: _selectedDate.times.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (context, index) {
                return RaisedButton(
                  child: Text(_selectedDate.times[index]),
                  onPressed: () {
                    print(_selectedDate.times[index]);
                    Provider.of<AppointmentProvider>(context, listen: false)
                        .setAppointmentTime(_selectedDate.times[index]);
                  },
                );
              }),
        ],
      );
    } else {
      return Expanded(child: Container());
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('appointments')
          .where('doctorId',
              isEqualTo: Provider.of<Doctors>(context).adoctor.id)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
        if (snapshots.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshots.hasData) {
          final docs = snapshots.data.documents;
          show = docs
              .map((e) => Appointment.fromKeyValue(e.documentID, e.data))
              .toList();
          print(show.length);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('nearest slots'),
              biuldTimesWidget(),
              FlatButton(
                  onPressed: () {
                    showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2021))
                        .then((value) {
                      _selectedDate = AppointmentTime(value);
                      print(_selectedDate.times);
                      Provider.of<DatesSchedule>(context, listen: false)
                          .setAppointmentTime(AppointmentTime(value));

                      Provider.of<AppointmentProvider>(context, listen: false)
                          .setAppointmentDate(value);
                      show = show
                          .where((element) =>
                              element.date.day == _selectedDate.date.day)
                          .where((element) =>
                              element.date.month == _selectedDate.date.month)
                          .toList();
                      List<String> times = show.map((e) => e.time).toList();
                      times.forEach((element) {
                        _selectedDate.times.remove(element);
                      });

                      print(times);
                      print(_selectedDate.times);
                      setState(() {});
                    });
                  },
                  child: Text('SHOW CALENDER ')),
            ],
          );
        
        } else {
          // print(snapshot.data.length);
          return Container();
        }
      },
    );
    //StreamBuilder(
    //   stream: Firestore.instance
    //       .collection('appointments')
    //       .snapshots(),
    //   builder: (context, AsyncSnapshot<QuerySnapshot> timeSnapshots) {
    //     print(timeSnapshots.data.documents.last);
    //     if (timeSnapshots.hasData) {
    //       return Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: <Widget>[
    //           Text('nearest slots'),
    //           biuldTimesWidget(),
    //           FlatButton(
    //               onPressed: () {
    //                 showDatePicker(
    //                         context: context,
    //                         initialDate: DateTime.now(),
    //                         firstDate: DateTime(2020),
    //                         lastDate: DateTime(2021))
    //                     .then((value) {
    //                   _selectedDate = AppointmentTime(value);
    //                   print(_selectedDate.times);
    //                   Provider.of<DatesSchedule>(context, listen: false)
    //                       .setAppointmentTime(AppointmentTime(value));
    //                   timeSnapshots.data.documents.map(
    //                       (e) =>print(e.documentID));
    //                      // print(show);
    //                   Provider.of<AppointmentProvider>(context, listen: false)
    //                       .setAppointmentDate(value);
    //                   // show = Provider.of<AppointmentProvider>(
    //                   //   context,
    //                   //   listen: false,
    //                   // )
    //                   //     .allApointment
    //                   //     .where((element) =>
    //                   //         element.date.day == _selectedDate.date.day)
    //                   //     .where((element) =>
    //                   //         element.date.month == _selectedDate.date.month)
    //                   //     .where((element) =>
    //                   //         element.doctorId ==
    //                   //         Provider.of<Doctors>(context, listen: false)
    //                   //             .adoctor
    //                   //             .id)
    //                   //     .toList();
    //                   List<String> times = show.map((e) => e.time).toList();
    //                   times.forEach((element) {
    //                     _selectedDate.times.remove(element);
    //                   });

    //                   print(times);
    //                   print(_selectedDate.times);
    //                   setState(() {});
    //                 });
    //               },
    //               child: Text('SHOW CALENDER ')),
    //         ],
    //       );
    //     } else {
    //       return Container();
    //     }
    //   },
    // );
  }
}
