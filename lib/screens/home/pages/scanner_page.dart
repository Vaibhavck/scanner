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
            child: GridView.count(
              // Create a grid with 2 columns. If you change the scrollDirection to
              // horizontal, this produces 2 rows.
              crossAxisCount: 3,
              // Generate 100 widgets that display their index in the List.
              children: List.generate(widget.doc.images.length, (index) {
                return Center(
                  child: Container(
                    child: Image.file(widget.doc.images[index]),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
