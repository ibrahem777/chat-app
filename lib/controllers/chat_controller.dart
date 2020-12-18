import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_app/models/message.dart';
import '../helpers/firebase_helper.dart';


class ChatRoomController extends GetxController {
  RxList<MessageModel> messages=RxList<MessageModel>();
  String chatRoomId;
  ChatRoomController({@required this.chatRoomId});
  @override
  void onInit() {
    super.onInit();
    messages.bindStream(getAllMessages(chatRoomId));
  }
}