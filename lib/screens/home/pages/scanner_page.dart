import 'package:flutter/material.dart';
import 'package:i_scanner/screens/home/pages/document.dart';

// this page is displayed when user clicks on the added documents
class ScannerPage extends StatefulWidget {
  final Doc doc;
  final bool mode; // modes : edit mode / display mode
  ScannerPage({
    this.doc,
    this.mode,
  });
  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: widget.mode ? Text('Edit mode') : Text('Display mode'),
        ),
        body: Center(
            child: Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Container(
                        height: 400,
                        width: 400,
                        padding: EdgeInsets.all(10.0),
                        child: widget.doc.image),
                    Container(
                        padding: EdgeInsets.all(5.9),
                        child: Text(
                          '${widget.doc.title}',
                          style: TextStyle(color: Colors.black),
                        )),
                    Container(
                      padding: EdgeInsets.all(5.9),
                      child: Text(
                        '${widget.doc.dateAdded}',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ))),
      ),
    );
  }
}
