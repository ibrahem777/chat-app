import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_app/controllers/controller.dart';

class SearchByNameWidget extends StatelessWidget {
   TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Container(
            height: 100,
            child: TextField(
              controller: _controller,
              onChanged: (val) {
                if(val!=null&&val.length!=0){  
                  print('not null');
                                Get.find<MyController>().updateSearchResult(val.trim());
}
else{
                                Get.find<MyController>().usersSearchList.clear();

}

              },
            ),
          ),
          Expanded(
            child: GetX<MyController>(builder: (controller) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.usersSearchList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(controller.usersSearchList[index].name),
                          leading: IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () async {
                                await controller.addNewFriend(
                                    controller.usersSearchList[index]);
                                Get.find<MyController>()
                                    .updateSearchResult(_controller.text);
                              }),
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      );
  }
}