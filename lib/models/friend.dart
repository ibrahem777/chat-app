import 'package:cloud_firestore/cloud_firestore.dart';

class FriendModel {
  String id;
  String chatId;
  String email;
  String name;
  bool isOnline;
  String friendId;
  FriendModel({this.id, this.email, this.name, this.chatId,this.friendId});
  FriendModel.fromQueryDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    this.id = snapshot.id;
    this.chatId = snapshot.data()['chatid'];
    this.name = snapshot.data()['friendname'];
    this.email = snapshot.data()['friendemail'];
        this.friendId = snapshot.data()['friendid'];

  }
  Map<String,dynamic> toMap(){
    return{
      'chatid':this.chatId,
      'friendemail':this.email,
      'friendid':this.friendId,
      'friendname':this.name,
    };
  }
}
