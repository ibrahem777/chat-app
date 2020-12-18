import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helpers/firebase_helper.dart';

enum AuthMode { Login, SignUp }

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Color(0xFF444152),
              Color(0xFF6f6c7d),
            ])),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Container(
                      child: Text(
                        'CHAT APP',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Expanded(flex: 4, child: AuthCard()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _valus = {
    'email': '',
    'password': '',
    'name': '',
    'city': '',
  };
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  void _submit() {
    _key.currentState.save();
    if (_authMode == AuthMode.SignUp) {
      print('signup');
Get.snackbar('signiup', 'proccessing');
      registerNewUser(
          _valus['email'], _valus['password'], _valus['name'], _valus['city']);
    } else if (_authMode == AuthMode.Login) {
      print('login');
      loginWithEmailAndPassword(_valus['email'], _valus['password']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            // color: Colors.white,
            child: Form(
              key: _key,
              child: SingleChildScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextFormField(
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    key: ValueKey('email'),
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.white,
                        )),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.white,
                        )),
                        hintText: 'enter email',
                        alignLabelWithHint: true,
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                        prefixIcon: Icon(
                          Icons.alternate_email,
                          color: Colors.white,
                        )),
                    onSaved: (val) {
                      _valus['email'] = val;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (_authMode == AuthMode.SignUp)
                    TextFormField(
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      key: ValueKey('name'),
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.white,
                          )),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.white,
                          )),
                          hintText: 'enter name',
                          hintStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: Colors.white,
                          )),
                      onSaved: (val) {
                        _valus['name'] = val;
                      },
                    ),
                  if (_authMode == AuthMode.SignUp)
                    SizedBox(
                      height: 10,
                    ),
                  if (_authMode == AuthMode.SignUp)
                    TextFormField(
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      key: ValueKey('city'),
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.white,
                          )),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.white,
                          )),
                          hintText: 'enter city',
                          hintStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(
                            Icons.location_on,
                            color: Colors.white,
                          )),
                      onSaved: (val) {
                        _valus['city'] = val;
                      },
                    ),
                  if (_authMode == AuthMode.SignUp)
                    SizedBox(
                      height: 10,
                    ),
                  TextFormField(
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    obscureText: true,
                    key: ValueKey('password'),
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.white,
                        )),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.white,
                        )),
                        hintText: 'enter password',
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(
                          Icons.lock_open,
                          color: Colors.white,
                        )),
                    onSaved: (val) {
                      _valus['password'] = val;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RaisedButton(
                          elevation: 0,
                          disabledElevation: 0,
                          focusElevation: 0,
                          onPressed: _submit,
                          color: Color(0xfff65aa3),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: Text(
                              _authMode == AuthMode.SignUp
                                  ? 'signUp'
                                  : 'log in',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
            ),
          ),
        ),
        FlatButton(
            onPressed: () {
              if (_authMode == AuthMode.Login) {
                setState(() {
                  _authMode = AuthMode.SignUp;
                });
              } else {
                setState(() {});
                _authMode = AuthMode.Login;
              }
            },
            child: Text(
              _authMode == AuthMode.Login
                  ? 'Don\'t have an account? create one'
                  : 'signin',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ))
      ],
    );
  }
}
