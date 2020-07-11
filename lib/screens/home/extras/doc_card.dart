import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:i_scanner/screens/home/pages/scanner_page.dart';
import 'package:i_scanner/screens/home/pages/document.dart';
import 'dart:io';

// card for displaying current added documents (images)
class DocCard extends StatefulWidget {
  // properties
  final String title;
  final String dateAdded;
  final List<File> images;
  final int index;
  final bool mode; // checking if dark mode is on or not

  DocCard({this.mode, this.index, this.title, this.dateAdded, this.images});

  @override
  _DocCardState createState() => _DocCardState(this.mode);
}

class _DocCardState extends State<DocCard> {
  bool toDelete = false; // documents is to be deleted if value is true
  bool mode; // checking if dark mode is on or not
  _DocCardState(this.mode);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 1.0),
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        margin: EdgeInsets.all(8),
        elevation: 10.0,
        color: Colors.grey[300],
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Slidable(
          key: ValueKey(widget.index),
          actionPane: SlidableDrawerActionPane(),
          actions: <Widget>[
            IconSlideAction(
              caption: 'edit',
              color: Colors.blue,
              icon: Icons.edit,
              closeOnTap: true,
              onTap: () {
                print("card clicked!");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScannerPage(
                      doc: Doc(
                        title: this.widget.title,
                        dateAdded: this.widget.dateAdded,
                        images: this.widget.images,
                      ),
                      mode: true,
                    ),
                  ),
                );
              },
            )
          ],
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              closeOnTap: true,
              onTap: () {
                print("deleting");
                setState(() {
                  this.toDelete = true;
                });
              },
            )
          ],
          // dismissal: SlidableDismissal(child: SlidableDrawerDismissal()),
          child: InkWell(
            onTap: () {
              print("card clicked!");
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ScannerPage(
                          doc: Doc(
                            title: this.widget.title,
                            dateAdded: this.widget.dateAdded,
                            images: this.widget.images,
                          ),
                          mode: false,
                        )),
              );
            },
            splashColor: Colors.grey,
            child: ListTile(
              leading: Container(
                child: Image.file(this.widget.images[0]),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
              ),
              title: Text(
                this.widget.title,
                style: TextStyle(color: Colors.black),
              ),
              subtitle: Text(
                'added : ${this.widget.dateAdded}',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
