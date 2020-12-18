import 'dart:io';

import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get_app/widgets/message_text_widget.dart';
import 'package:image_picker/image_picker.dart';

class ChatRoomScreen extends StatefulWidget {
  String chatRoomId;

  ChatRoomScreen(this.chatRoomId);

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  bool isChanged = true;

  TextEditingController _controller = TextEditingController();

  File _image;

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      setState(() {});
      print(_image.path);
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            flex: 10,
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .doc(widget.chatRoomId)
                    .collection('messages')
                    .orderBy('timestampe')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  print('object1');

                  return snapshot.connectionState == ConnectionState.waiting
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            var t = (snapshot.data.docs[index]['timestampe']
                                    as Timestamp)
                                .toDate();

                            print("t: $t");

                            if (index != 0) {
                              var c = (snapshot.data.docs[index - 1]
                                      ['timestampe'] as Timestamp)
                                  .toDate();
                              print("c: $c");
                              print(c.day == t.day);
                              if (c.year == t.year &&
                                  c.month == t.month &&
                                  c.day == t.day) {
                                isChanged = false;
                              } else {
                                isChanged = true;
                              }
                            } else {
                              print('true');
                              //isChanged=true;

                            }
                            print('object');
                            return Column(
                              children: [
                                if (isChanged)
                                  Center(
                                      child: Text(
                                          'in ${t.year}/${t.month}/${t.day}',
                                          textAlign: TextAlign.center)),
                                Bubble(
                                  margin: BubbleEdges.only(top: 10),
                                  alignment: Alignment.topRight,
                                  nip: BubbleNip.rightBottom,
                                  color: Color.fromRGBO(225, 255, 199, 1.0),
                                  child: Column(
                                    children: [
                                      Text(snapshot.data.docs[index]['text'],
                                          textAlign: TextAlign.right),
                                      Text(' at ${t.hour}:${t.minute}',
                                          textAlign: TextAlign.right),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          });
                }),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                    child: _image != null
                        ? Image.file(_image)
                        : TextField(
                            controller: _controller,
                          )),
                IconButton(icon: Icon(Icons.image), onPressed: getImage),
                IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () async {
                      if (_image != null) {
                        print('send image');
                        final ref = FirebaseStorage.instance
                            .ref()
                            .child('images')
                            .child(_image.path.split('/').last);
                        await ref.putFile(_image).whenComplete(() => null);
                        _image = null;
                        setState(() {});
                      } else if (_controller.text != null &&
                          _controller.text.isNotEmpty) {
                        print('send text');

                        FirebaseFirestore.instance
                            .collection('chats')
                            .doc(widget.chatRoomId)
                            .collection('messages')
                            .add({
                          'text': _controller.text,
                          'userid': FirebaseAuth.instance.currentUser.uid,
                          'timestampe': Timestamp.now(),
                        });
                      }
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
