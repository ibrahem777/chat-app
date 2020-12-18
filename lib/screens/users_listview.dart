import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_app/controllers/controller.dart';
import 'package:get_app/controllers/user_state_controller.dart';
import 'package:get_app/models/friend.dart';
import 'package:get_app/models/user.dart';
import 'package:get_app/screens/chat_room.dart';

import '../helpers/firebase_helper.dart';
import './add_friend_screen.dart';

class UsersListViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('users'),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                print('check');
                print(FirebaseAuth.instance.currentUser.uid);
                logOut(FirebaseAuth.instance.currentUser.uid);
              }),
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return AddFriendScreen();
                }));
              }),
             
        ],
      ),
      body: GetX<MyController>(
          init: Get.put<MyController>(MyController(),
              tag: '${FirebaseAuth.instance.currentUser.uid}'),
          builder: (controller) {
            // controller.initialized;
            controller.update();
            print('inside listview');
            print(FirebaseAuth.instance.currentUser.uid);

            return controller.usersList.value == null ||
                    controller.usersList.value.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.usersList.value.length,
                    itemBuilder: (context, index) {
                      Get.put(
                          UserStateController(
                              userId:
                                  controller.usersList.value[index].friendId),
                          tag: '${controller.usersList.value[index].friendId}');
                      final con = Get.find<UserStateController>(
                          tag: '${controller.usersList.value[index].friendId}');

                      return Obx(() {
                        return con.usersState.isNull ||
                                con.usersState.value == null ||
                                con.usersState.value.isOnline.isNull
                            ? CircularProgressIndicator()
                            : ListTile(
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return ChatRoomScreen(controller
                                        .usersList.value[index].chatId);
                                  }));
                                },
                                title: Text(
                                    controller.usersList.value[index].name),
                                subtitle: Text(
                                    controller.usersList.value[index].email),
                                       trailing: 
                           
                            Text(con.usersState.value.isOnline?'online':'${DateTime.now().difference(con.usersState.value.lastSeen.toDate()).inHours} hours ago'),
                     
                              );
                      }

                        
                          );
                    },
                  );
          }),
    );
  }
}
