import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String password, String userName,
      bool islogin, BuildContext ctx) submitFn;
  final bool isLoading;
  AuthForm(this.submitFn, this.isLoading);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  

  final _formKey = GlobalKey<FormState>();

  String _userEmail = '';

  String _userPassword = '';

  String _userName = '';

  bool _isLogin = true;

  void _trySubmit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      widget.submitFn(_userEmail.trim(), _userPassword.trim(), _userName.trim(),
          _isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    key: ValueKey('email'),
                    // controller: email,
                    validator: (val) {
                      if (val.isEmpty || !val.contains('@')) {
                        return 'please enter a valid Email';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      _userEmail = val;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        InputDecoration(labelText: 'Enter Email Address'),
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),

                      //controller: email,
                      validator: (val) {
                        if (val.isEmpty || val.length < 4) {
                          return 'please enter  at least 4 characters';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _userName = val;
                      },
                      decoration: InputDecoration(labelText: 'Enter User Name'),
                    ),
                  TextFormField(
                    //  controller: password,
                    key: ValueKey('password'),

                    validator: (val) {
                      if (val.isEmpty || val.length < 7) {
                        return 'password should be at least 7 characters';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      _userPassword = val;
                    },
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Enter Passwored'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(_isLogin ? 'Login' : 'SignUp'),
                              ),
                              onPressed: _trySubmit),
                        ),
                      ],
                    ),
                  if (!widget.isLoading)
                    FlatButton(
                        child: Text(_isLogin
                            ? 'create new account '
                            : 'already have an account'),
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
