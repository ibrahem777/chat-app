import 'package:auth_app/screens/appointment_screen.dart';
import 'package:auth_app/screens/book_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  // String email;
//  HomePage(this.email);

  static String routeName = '/home_bage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  List<Widget> _children;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _children = [
      AppointmentScreen(),
      BookScreen(),
      Text('data'),
    ];
  }

  onTapped(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
         // title: Text('home page'),
         elevation: 0,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                })
          ],
        ),
        bottomNavigationBar:
            BottomNavigationBar(onTap: onTapped, currentIndex: _index, items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text('appointment'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            title: Text('book'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('profile'),
          ),
        ]),
        body: _children[_index],
      ),
    );
  }
}
