import 'package:cloud_firestore/cloud_firestore.dart';

class UserState{
  bool isOnline;
  Timestamp lastSeen;
  UserState({this.isOnline,this.lastSeen});
  UserState.fromQueryDocumentSnapshot(DocumentSnapshot  snapshot){
    this.isOnline=snapshot.data()['isonline'];
        this.lastSeen=snapshot.data()['lastseen'];

  }
}