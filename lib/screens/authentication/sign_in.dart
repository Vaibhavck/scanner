import 'package:flutter/material.dart';
import 'package:i_scanner/screens/home/shared/loading.dart';
import 'package:i_scanner/services/auth.dart';
import 'package:i_scanner/screens/home/shared/constants.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //text field state
  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.grey[200],
            appBar: AppBar(
              backgroundColor: Colors.red,
              elevation: 0.0,
              title: Text('Sign in to IScanner'),
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('Register'),
                  onPressed: () {
                    widget.toggleView();
                  },
                ),
              ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Email'),
                        validator: (val) =>
                            val.isEmpty ? 'Enter an email' : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        }),
                    SizedBox(height: 20.0),
                    TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Password'),
                        obscureText: true,
                        validator: (val) => val.length < 6
                            ? 'Enter a password 6+ chars long'
                            : null,
                        onChanged: (val) {
                          setState(() => password = val);
                        }),
                    SizedBox(height: 20.0),
                    RaisedButton(
                      color: Colors.red[300],
                      child: Text(
                        'Sign in',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() => loading = true);
                          dynamic result = await _auth
                              .signInWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() {
                              error = 'Invalid credentials';
                              loading = false;
                            });
                          }
                        }
                      },
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                    Expanded(
                        child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FlatButton.icon(
                        onPressed: () async {
                          setState(() => loading = true);
                          dynamic result = await _auth.signInAnon();
                          if (result == null) {
                            print('error signing in');
                            setState(() => loading = true);
                          } else {
                            print('sign in successful');
                            print(result.uid);
                          }
                        },
                        icon: Icon(
                          Icons.arrow_forward,
                          color: Colors.red,
                        ),
                        label: Text('Skip sign-in',
                            style: TextStyle(
                                fontSize: 15, color: Colors.redAccent)),
                      ),
                    )),
                  ],
                ),
              ),
            ),
          );
  }
}
