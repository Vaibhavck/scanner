import 'package:flutter/material.dart';

import '../../../../../services/database.dart';
import '../../../extras/switch.dart';
import '../../document.dart';
import '../../scanner_page.dart';

class DrawerComponent extends StatefulWidget {
  final String uid;
  final bool darkMode;
  final int numDocCollection;
  DrawerComponent({this.uid, this.darkMode, this.numDocCollection});
  @override
  _DrawerComponentState createState() => _DrawerComponentState();
}

class _DrawerComponentState extends State<DrawerComponent> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          color: widget.darkMode ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        child: ListView(
          children: <Widget>[
            Container(
              child: DrawerHeader(
                child: Icon(
                  Icons.account_circle,
                  color: Colors.red,
                  size: 100.0,
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Dark Mode',
                style: TextStyle(color: Colors.red, fontSize: 24),
              ),
              trailing: CustomSwitch(
                mode: widget.darkMode,
                value: widget.darkMode,
                onChanged: (bool val) {
                  setState(() {
                    //widget.darkMode = val;
                    DatabaseService(uid: widget.uid).updateUserData(
                        val,
                        widget.numDocCollection == null
                            ? 0
                            : widget.numDocCollection);
                  });
                },
              ),
            ),
            Material(
              color: widget.darkMode ? Colors.grey[900] : Colors.white,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScannerPage(
                        doc: Doc(),
                        mode: true,
                      ),
                    ),
                  );
                  print("ocr");
                },
                splashColor: Colors.red,
                child: ListTile(
                  leading: Icon(
                    Icons.camera,
                    color: Colors.red,
                    size: 30,
                  ),
                  title: Text(
                    'OCR',
                    style: TextStyle(color: Colors.red, fontSize: 24),
                  ),
                ),
              ),
            ),
            Material(
              color: widget.darkMode ? Colors.grey[900] : Colors.white,
              child: InkWell(
                onTap: () {
                  print("help");
                },
                splashColor: Colors.red,
                child: ListTile(
                  leading: Icon(
                    Icons.help_outline,
                    color: Colors.red,
                    size: 30,
                  ),
                  title: Text(
                    'Help',
                    style: TextStyle(color: Colors.red, fontSize: 24),
                  ),
                ),
              ),
            ),
            Material(
              color: widget.darkMode ? Colors.grey[900] : Colors.white,
              child: InkWell(
                onTap: () {},
                splashColor: Colors.red,
                child: ListTile(
                  leading: Icon(
                    Icons.info_outline,
                    color: Colors.red,
                    size: 30,
                  ),
                  title: Text(
                    'About us',
                    style: TextStyle(color: Colors.red, fontSize: 24),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
