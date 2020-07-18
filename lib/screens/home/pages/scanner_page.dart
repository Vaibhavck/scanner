import 'dart:io';
import 'package:i_scanner/screens/home/pages/upload.dart';
import 'package:flutter/material.dart';
import 'package:i_scanner/screens/home/pages/document.dart';
import 'dart:async';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
// import 'package:i_scanner/screens/home/pages/pdf_viewer.dart';
// import 'package:firebase_storage/firebase_storage.dart';
//import 'package:image_cropper/image_cropper.dart';
// import 'package:image_cropper/image_cropper.dart';

// this page is displayed when user clicks on the added documents
class ScannerPage extends StatefulWidget {
  final Doc doc;
  final bool mode; // modes : edit mode / display mode
  //final File fil;
  ScannerPage({
    this.doc,
    this.mode,
    // this.fil,
  });

  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  /*
Future<void> _cropImage() async{
  File cropped = await ImageCropper.cropImage(
      sourcePath: this.widget.doc.files.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      )
  );

  setState(() {
    this.widget.doc.files = cropped?? this.widget.doc.files;
  });
}
*/

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
                        child:
                            //widget.doc.image
                            Image.file(this.widget.doc.files)),
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
                    /*Container(
                      padding: EdgeInsets.all(5.9),
                      child: Uploader(file: ,),
                    )*/
                    //Uploader(file: this.widget.fil,),
                    Container(
                      padding: EdgeInsets.all(5.9),
                      child: Uploader(
                        file: this.widget.doc.files,
                      ),
                    ),

                    // ReadText(this.widget.doc.files),

                    SizedBox(height: 10.0),
                    FlatButton(
                      color: Colors.grey[200],
                      child: Text(
                        'Read Text',
                        style: TextStyle(
                          color: Colors.red[500],
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ReadText(this.widget.doc.files),
                          ),
                        );
                      },
                    ),

                    // Container(
                    //   padding: EdgeInsets.all(1.0),
                    //   child: Pdf_Viewer(),
                    // ),

                    /*Container(
                      padding: EdgeInsets.all(5.9),
                      child: Row(
                        children: <Widget>[
                          FlatButton(
                            child: Icon(Icons.crop),
                            onPressed: _cropImage,
                          )
                        ],
                      ),
                    )  */

                    /*RaisedButton(
                      child: Text('Upload'),
                      onPressed: () {
                        uploadPic();
                      },
                    ),*/
                  ],
                ))),
      ),
    );
  }
}

class ReadText extends StatelessWidget {
  String tt;
  File f;
  ReadText(this.f) {
    readText(f);
  }
  Future readText(pickedImage) async {
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);
    tt = readText.text;
    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          print(word.text);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0.0,
        title: Text(
          "Text Recognizer",
        ),
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Text(
            tt,
          )),
    );
  }
}

/*      ***************UPLOAD TO FIREBASE CLASS **********************

class Uploader extends StatefulWidget {

  final File file;

  Uploader({Key key, this.file}) : super(key: key);


  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {

  final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://scanner-4f47e.appspot.com');
  StorageUploadTask _uploadTask;

  void _startUpload (){
    String filepath = 'image/${DateTime.now()}.png';

    setState(() {
      _uploadTask = _storage.ref().child(filepath).putFile(widget.file);
    });
  }


  @override
  Widget build(BuildContext context) {
    if(_uploadTask!=null){
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events,
          builder: (context, snapshot){
            var event = snapshot?.data?.snapshot;
            double progressPercent = event!=null
                ? event.bytesTransferred / event.totalByteCount
                :0;
            return Column(
              children: [
                if(_uploadTask.isComplete)
                  Text("Task Completed"),
                if(_uploadTask.isPaused)
                  FlatButton(
                    child: Icon(Icons.play_arrow),
                    onPressed: _uploadTask.resume,
                  ),
                if(_uploadTask.isInProgress)
                  FlatButton(
                    child: Icon(Icons.pause),
                    onPressed: _uploadTask.pause,
                  ),

                LinearProgressIndicator(value: progressPercent,),
                Text('${(progressPercent*100).toStringAsFixed(2)}%'),

              ],
            );
          }
      );

    }
    else{
      return FlatButton.icon(onPressed: _startUpload, icon: Icon(Icons.cloud_upload), label: Text('Upload to Firebase'));
    }
  }
}*/
