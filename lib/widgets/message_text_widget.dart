import 'package:flutter/material.dart';

class MessageTextWidget extends StatelessWidget {
  final String text;
  MessageTextWidget({this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ClipPath(
        clipper: MyClipper(),
        child: Container(
         // height: 200,
         // width: 200,
          color: Colors.red,
          child: Center(child: Text(text)),),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    Path path=Path();
    path.moveTo(0, size.height);
        path.lineTo(size.width*0.9, size.height);
        path.quadraticBezierTo(size.width*0.9, size.height, size.width, size.height*0.9);
         path.lineTo(size.width, size.height*0.1);
        path.quadraticBezierTo(size.width, 0, size.width*0.9, 0);
         path.lineTo(size.width*0.2, 0);
        path.quadraticBezierTo(size.width*0.1, 0, size.width*0.1, size.height*0.1);
        path.lineTo(size.width*0.1, size.height*0.9);
       // path.close();
        return path;

  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}
