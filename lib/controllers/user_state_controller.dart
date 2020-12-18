import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_app/models/friend.dart';
import 'package:get_app/models/user.dart';
import 'package:get_app/models/user_state.dart';
import '../helpers/firebase_helper.dart';

class UserStateController extends GetxController {
  var userId;

  Rx<UserState> usersState = Rx<UserState>();

  UserStateController({@required this.userId});
  @override
  void onInit() {
    print('oninit user state');
    print(userId);
    usersState.bindStream(getUserState(userId));
    print(userId);
  }
}
