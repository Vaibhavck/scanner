import 'package:flutter/material.dart';
import 'package:i_scanner/models/user.dart';
import 'package:i_scanner/screens/authentication/login.dart';
import 'package:provider/provider.dart';
import 'home/pages/home_page.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(user);

    //Return either home or authenticate.
    if (user == null) {
      return Authenticate();
    } else {
      return IScanner(user: user);
    }
  }
}
