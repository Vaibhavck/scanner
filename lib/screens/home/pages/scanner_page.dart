import 'package:flutter/material.dart';
import 'package:i_scanner/screens/home/pages/document.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
  bool uploaded = false;
  String _uploadedFileURL;

  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://scanner-4f47e.appspot.com');
  StorageUploadTask _uploadTask;

  /*Future uploadImage() async {
    String filePath = 'images/${DateTime.now()}.png';
    setState(() {
      _uploadTask =
          _storage.ref().child(filePath).putFile(widget.doc.sampleImg);
    });
  }*/

  /*Future uploadImage() async {
    String filePath = 'images/${DateTime.now()}.png';
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(filePath);
    StorageUploadTask uploadTask =
        storageReference.putFile(widget.doc.sampleImg);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
  }*/

  /*Future<void> uploadImage() async {
    StorageReference storageReference;
    storageReference = FirebaseStorage.instance.ref().child("images/");

    final StorageUploadTask uploadTask =
        storageReference.putFile(widget.doc.sampleImg);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    print("URL is $url");
  }*/

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
                    RaisedButton(
                      child: Text('Upload'),
                      onPressed: () {
                        //uploadImage();
                      },
                    ),
                  ],
                ))),
      ),
    );
  }
}

/*Widget enableUpload() {
    return Column(
      children: <Widget>[
        Container(
          height: 400,
          width: 400,
          padding: EdgeInsets.all(10.0),
          child: enableUpload(),
        ),
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
        RaisedButton(
          child: Text('Upload'),
          onPressed: () {
            var temp = widget.doc.image;
            final StorageReference firebaseStorageRef =
                FirebaseStorage.instance.ref().child(widget.doc.title);
            final StorageUploadTask task =
                firebaseStorageRef.putFile(widget.doc.sampleImg);
          },
        )
      ],
    );
  }
}*/
