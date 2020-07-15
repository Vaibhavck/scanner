import 'package:flutter/material.dart';

// this page gets displayed if no documents are added
class NothingHerePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 100,
              width: 100,
              child: Image.asset('assets/images/deadpool.png'),
            ),
            Text(
              "Nothing's here !",
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
