import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String text;
  String userid;
  Timestamp timestamp;

  MessageModel({this.text, this.userid, this.timestamp});
  MessageModel.fromQueryDocumentSnapshot(QueryDocumentSnapshot snapshot){
    this.text=snapshot.data()['text'];
    this.userid=snapshot.data()['userid'];
    this.timestamp=snapshot.data()['timestampe'];
  }
}
