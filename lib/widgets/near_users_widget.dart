import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_app/controllers/controller.dart';

class NearUsersWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<MyController>(builder: (controller) {
                     

      return RefreshIndicator(
                      onRefresh: () { 
 return Get.find<MyController>().updateNearUserSearchResult(); 
  
                       },
                      child: ListView.builder(
          itemCount: controller.nearUsersSearchList.length,
          itemBuilder: (context, index) {
            return  ListTile(
              title: Text(controller.nearUsersSearchList[index].name),
              leading: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () async {
                    await controller.addNewFriend(
                        controller.nearUsersSearchList[index]);
                        Get.find<MyController>().updateNearUserSearchResult();
                  
                  }),
            );
          },
        ),
      );
    });
  }
}