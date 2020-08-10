import 'package:auth_app/models/doctor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Doctors extends ChangeNotifier{
  List<Doctor> doctors=[];
  Doctor adoctor;
  setDoctor( Doctor doctor){
this.adoctor=doctor;
print(this.adoctor.name);
notifyListeners();
  }
  Future<List<Doctor>> getAllDoctors() async {
    QuerySnapshot snapshot =
        await Firestore.instance.collection('doctors').getDocuments();

    doctors = snapshot.documents
        .map(
          (e) => Doctor.fromJson(
            {
              'id': e.documentID,
              'name': e.data['name'],
              'specialty': e.data['specialty'],
            },
          ),
        )
        .toList();
    return doctors;
  }
}