import 'package:cloud_firestore/cloud_firestore.dart';

class UserPosition {
  String userId;
  GeoPoint pos;
  //double longitude;
  //double latitude;
  UserPosition({
    this.pos,
    // this.longitude,
    // this.latitude
  });
  UserPosition.fromQueryDocumentSnapshot(DocumentSnapshot snapshot) {
    this.userId=snapshot.id;
    this.pos = snapshot.data()['position'];
    

  }
}
