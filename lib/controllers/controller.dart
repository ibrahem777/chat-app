import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_app/models/friend.dart';
import 'package:get_app/models/user.dart';
import 'package:get_app/models/user_position.dart';
import '../helpers/firebase_helper.dart';

class MyController extends GetxController {
  RxList<UserModel> usersSearchList = RxList<UserModel>();
  Rx<List<FriendModel>> usersList = Rx<List<FriendModel>>();
  RxList<UserModel> nearUsersSearchList = RxList<UserModel>();
  RxList<UserPosition> posList = RxList<UserPosition>();
  GeoPoint point;
  @override
  void onReady() {
    Geolocator.getCurrentPosition().then((value) async{
       await FirebaseFirestore.instance
          .collection('users_positions')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .update({
        'position': GeoPoint(value.latitude, value.longitude),
      });
    });
    // Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.best).listen((event) async {
    //   await FirebaseFirestore.instance
    //       .collection('users_positions')
    //       .doc(FirebaseAuth.instance.currentUser.uid)
    //       .update({
    //     'position': GeoPoint(event.latitude, event.longitude),
    //   });
    // });
posList.bindStream(getUserPositions());
    print(FirebaseAuth.instance.currentUser.uid);
    usersList
        .bindStream(getUserFriendsList(FirebaseAuth.instance.currentUser.uid));
    
  }

  
  updateSearchResult(String text) async {
    usersSearchList.clear();
    List<UserModel> list = [];

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('name').startAt([text]).endAt([text+ '\uf8ff'])
        // .where(
        //   'name',
        //   isEqualTo: text,
        // )
        .get();
    if (snapshot.docs != null && snapshot.docs.isNotEmpty) {
      snapshot.docs.map(
        (e) {
          list.add(
            UserModel.fromJson(
              e.id,
              e.data(),
            ),
          );
          print(  e.data(),);
        },
      ).toList();
    }
    if (usersList.value.isNotEmpty && usersList.value != null) {
      list.map((user) {
        if (usersList.value.any((element) => element.friendId == user.id) ||
            user.id == FirebaseAuth.instance.currentUser.uid) {
          usersSearchList.remove(user);
        } else {
          usersSearchList.add(user);
        }
      }).toList();
    } else {
      list.map((user) {
        if (user.id == FirebaseAuth.instance.currentUser.uid) {
          usersSearchList.remove(user);
        } else {
          usersSearchList.add(user);
        }
      }).toList();
    }
  }

  addNewFriend(UserModel friend) async {
    var afriend = FriendModel(
        email: friend.email, name: friend.name, friendId: friend.id);
    var user = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();

    UserModel auser =
        UserModel.fromJson(FirebaseAuth.instance.currentUser.uid, user.data());

    await addFriend(auser, afriend);
  }

  Future<void>updateNearUserSearchResult() async {
    print('updateNearUserSearchResult');
    nearUsersSearchList.clear();
    List<UserModel> list = [];

    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').get();
    if (snapshot.docs != null && snapshot.docs.isNotEmpty) {
      snapshot.docs.map(
        (e) {
          list.add(
            UserModel.fromJson(
              e.id,
              e.data(),
            ),
          );
        },
      ).toList();
    }
    if (usersList.value.isNotEmpty && usersList.value != null) {
          print('updateNearUserSearchResult not empty');

      list.map((user) {
            print('updateNearUserSearchResult 1');

        if (usersList.value.any((element) => element.friendId == user.id) ||
            user.id == FirebaseAuth.instance.currentUser.uid) {
                  print('updateNearUserSearchResult remove 1');

          nearUsersSearchList.remove(user);
        } else {
              print('updateNearUserSearchResult add 1');

         var  userpos=posList.firstWhere((e) => e.userId==FirebaseAuth.instance.currentUser.uid);
          posList.map((p) {
                print('updateNearUserSearchResult add 2');

            if(user.id==p.userId){    print('updateNearUserSearchResult add 3');
             print(p.userId);
                       print(userpos.userId);
            print(userpos.pos.latitude);
                        print(userpos.pos.longitude);
                         print(p.pos.latitude);
                        print(p.pos.longitude);

print(Geolocator.distanceBetween(userpos.pos.latitude,userpos.pos.longitude,p.pos.latitude,p.pos.longitude).toString());
              if(Geolocator.distanceBetween(userpos.pos.latitude,userpos.pos.longitude,p.pos.latitude,p.pos.longitude)<=1000){
                    print('updateNearUserSearchResult add 4');

 nearUsersSearchList.add(user);
              }
            }
          }).toList();
         
        }
      }).toList();
    } else {
          print('updateNearUserSearchResult empty ');

      list.map((user) {
        if (user.id == FirebaseAuth.instance.currentUser.uid) {
                    print('updateNearUserSearchResult empty remove');

          nearUsersSearchList.remove(user);
        } else {
                    print('updateNearUserSearchResult empty add 1');

          var  userpos=posList.firstWhere((e) => e.userId==FirebaseAuth.instance.currentUser.uid);
          posList.map((p) {
                      print('updateNearUserSearchResult empty add 2');

            if(user.id==p.userId){
                        print('updateNearUserSearchResult empty add 3');

              if(Geolocator.distanceBetween(userpos.pos.latitude,userpos.pos.longitude,p.pos.latitude,p.pos.longitude)<=1000){
                          print('updateNearUserSearchResult empty add4');

 nearUsersSearchList.add(user);
              }
            }
          }).toList();
        }
      }).toList();
    }
  }
}
