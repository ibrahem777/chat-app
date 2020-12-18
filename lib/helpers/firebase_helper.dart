import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_app/controllers/controller.dart';
import 'package:get_app/models/friend.dart';
import 'package:get_app/models/message.dart';
import 'package:get_app/models/user.dart';
import 'package:get_app/models/user_position.dart';
import 'package:get_app/models/user_state.dart';

class FirebaseHelper {}

registerNewUser(String email, String password, String name, String city) async {
  final userId = await signUpWithEmailAndPassword(email, password);
  if (userId == null) {
    return;
  } else {
    createNewUser(userId, email, name, city);
  }
}

loginWithEmailAndPassword(String email, String password) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    await FirebaseFirestore.instance
        .collection('users_state')
        .doc(userCredential.user.uid)
        .update({
      'isonline': true,
    });
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  }
}

Future<String> signUpWithEmailAndPassword(String email, String password) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user.uid;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
    return null;
  } catch (e) {
    print(e);
    return null;
  }
}

createNewUser(String id, String email, String name, String city) async {
  await FirebaseFirestore.instance.collection('users').doc(id).set({
    'email': email,
    'name': name,
    'city': city,
  });
  await FirebaseFirestore.instance.collection('users_state').doc(id).set({
    'isonline': true,
    'lastseen': Timestamp.now(),
  });
}

logOut(String id) async {
  await FirebaseFirestore.instance.collection('users_state').doc(id).update({
    'isonline': false,
    'lastseen': Timestamp.now(),
  });
  FirebaseAuth.instance.signOut();
}

Future<QuerySnapshot> getAllUsers(String userId) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('chats')
      .get();
}

Stream<List<MessageModel>>getAllMessages(
  String chatRoomId,
) {
  FirebaseFirestore.instance
      .collection('chats')
      .doc(chatRoomId)
      .collection('messages')
      .snapshots()
      .map((QuerySnapshot query) {
    List<MessageModel> messagesList = List<MessageModel>();
    query.docs.map((e) {
      messagesList.add(MessageModel.fromQueryDocumentSnapshot(e));
    }).toList();
    return messagesList;
  });
}

saveMessage(String senderId, String recieverId) {}
Stream<List<FriendModel>> getUserFriendsList(
  String userId,
) {
  
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('chats')
      .snapshots()
      .map((QuerySnapshot query) {
    List<FriendModel> usersList = List<FriendModel>();
    query.docs.map((e) {
      usersList.add(FriendModel.fromQueryDocumentSnapshot(e));
    }).toList();
    return usersList;
  });
}

Stream<UserState> getUserState(
  String userId,
) {
  
  return FirebaseFirestore.instance
      .collection('users_state')
      .doc(userId)
      .snapshots()
      .map((state) => UserState.fromQueryDocumentSnapshot(state));
}
Stream<List<UserPosition>> getUserPositions(
 
) {
  
  
  return FirebaseFirestore.instance
      .collection('users_positions')
      .snapshots()
      .map((query) {
        List<UserPosition> usersPositionsList = List<UserPosition>();
        query.docs.map((e) {
usersPositionsList.add(UserPosition.fromQueryDocumentSnapshot(e));
        }).toList();
         return usersPositionsList;
      } );
     
}

Future<void>addFriend(UserModel userModel, FriendModel friendModel) async {
 var chat = await FirebaseFirestore.instance.collection('chats').add({});

  friendModel.chatId = chat.id;
  await FirebaseFirestore.instance
      .collection('users')
      .doc(userModel.id)
      .collection('chats')
      .add(friendModel.toMap());
  await FirebaseFirestore.instance
      .collection('users')
      .doc(friendModel.friendId)
      .collection('chats')
      .add({
    'chatid': chat.id,
    'friendemail': userModel.email,
    'friendid': userModel.id,
    'friendname': userModel.name,
  });
}
