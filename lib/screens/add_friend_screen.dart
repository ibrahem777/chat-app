import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_app/controllers/controller.dart';
import 'package:get_app/helpers/firebase_helper.dart';
import 'package:get_app/models/friend.dart';
import 'package:get_app/models/user.dart';
import 'package:get_app/widgets/near_users_widget.dart';
import 'package:get_app/widgets/search_by_name_widget.dart';

class AddFriendScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Add Friend'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.person_add)),
              Tab(icon: Icon(Icons.location_on)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SearchByNameWidget(),
            NearUsersWidget(),
          ],
        ),
      ),
    );
  }
}
