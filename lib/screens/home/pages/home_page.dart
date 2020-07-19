import 'dart:io';
import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:i_scanner/screens/home/pages/document.dart';
import 'package:i_scanner/screens/home/pages/scanner_page.dart';
import 'package:i_scanner/screens/home/shared/utility.dart';
import 'package:i_scanner/services/auth.dart';
import 'package:i_scanner/services/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:i_scanner/screens/home/extras/switch.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:http/http.dart' as http;

// scanner app
class IScanner extends StatefulWidget {
  final String uid;
  IScanner({this.uid});
  @override
  _IScannerState createState() => _IScannerState();
}

class _IScannerState extends State<IScanner> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: AppTheme.lightTheme,
      // theme: AppTheme.darkTheme,
      // theme: ThemeData.dark(),
      home: Home(uid: widget.uid), // calling home page
    );
  }
}

// home page for the app
class Home extends StatefulWidget {
  final String uid;
  Home({this.uid});
  @override
  _HomeState createState() => _HomeState(uid: this.uid);
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  //params
  List<File> images = List<File>();
  List<Asset> assets = List<Asset>();
  Image imageFromPreferences;
  String _error = 'No Error Dectected';
  Image sampleImg;
  String key;
  Widget widgetToShow;
  final String uid;
  _HomeState({this.uid});

  // this should be initialized by the number of docCollections current present in firebase
  int numDocCollection;

  Future uploadImages(int docCollectionIdx, List<File> images) async {
    String docCollectionName = 'undefined$docCollectionIdx-${DateTime.now()}';
    for (int i = 0; i < images.length; i++) {
      String filePath = '$uid/$docCollectionName/${i + 1}/original.png';
      //Create a reference to the location you want to upload to in firebase
      StorageReference reference = _storage.ref().child(filePath);
      StorageUploadTask uploadTask = reference.putFile(images[i]);
      print(uploadTask);
    }
    for (int i = 0; i < images.length; i++) {
      String filePath = '$uid/$docCollectionName/${i + 1}/original.png';
      StorageReference reference = _storage.ref().child(filePath);
      //Create a reference to the location you want to upload to in firebase
      StorageUploadTask uploadTask = reference.putFile(images[i]);
      print(uploadTask);
      // String downloadUrl = (await (await uploadTask.onComplete).ref.getDownloadURL()).toString();
      String url =
          'https://aksv-scanner.herokuapp.com/download?firebasepath=$filePath';
      http.Response response = await http.get(url);
      print(response);
    }
  }

  // load image
  loadImageFromPreferences() {
    Utility.getImageFromPreferences(this.key).then((img) {
      if (img == null) {
        return;
      }
      setState(() {
        this.imageFromPreferences = Utility.imageFromBase64String(img);
      });
    });
  }

  // image saved
  Widget imageFromGallery(Future<File> imageFile, String key) {
    return FutureBuilder<File>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == null) {
            return const Text('Error', textAlign: TextAlign.center);
          }
          Utility.saveImageToPreferences(
            Utility.base64String(snapshot.data.readAsBytesSync()),
            key,
          );
          return Image.file(snapshot.data);
        }
        if (snapshot.error != null) {
          return const Text(
            'Error picking images',
            textAlign: TextAlign.center,
          );
        }
        return const Text(
          'No image selected',
          textAlign: TextAlign.center,
        );
      },
    );
  }

  // for selecting images from gallery
  Future<void> loadAssets() async {
    this.assets = null;
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        materialOptions: MaterialOptions(
          actionBarColor: "#FF0000",
          actionBarTitle: "Select Images",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    List<File> fileImageArray = [];
    resultList.forEach(
      (imageAsset) async {
        final filePath =
            await FlutterAbsolutePath.getAbsolutePath(imageAsset.identifier);
        File tempFile = File(filePath);
        if (tempFile.existsSync()) {
          fileImageArray.add(tempFile);
          String key = '${uid}_$numDocCollection';
          setState(() {
            this.key = key;
          });
          this.imageFromGallery(Future.value(tempFile), key);
        }
      },
    );
    if (!mounted) return;

    setState(() {
      images = fileImageArray;
      assets = resultList;
      if (this.numDocCollection == null) {
        this.numDocCollection = 1;
      } else {
        this.numDocCollection++;
      }
      _error = error;
      print(_error);
    });
    await DatabaseService(uid: this.uid)
        .updateUserData(this.darkMode, numDocCollection);
    await this.uploadImages(this.numDocCollection, images);
  }

  // for animation stuff
  AnimationController animationController;
  Animation degOneTranslationAnimation,
      degTwoTranslationAnimation,
      degThreeTranslationAnimation;
  Animation rotationAnimation;

  // method for animating floating buttons
  double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  // for changing color according to mode
  bool darkMode = false;

  // list of all documents (images)
  List<Image> docs = List<Image>();

  // image picker for picking images from gallery or camera
  ImagePicker _imagePicker = ImagePicker();

  // method for getting images from camera
  Future _getImageFromCamera() async {
    PickedFile image = await _imagePicker.getImage(source: ImageSource.camera);
    File file = File(image.path);
    setState(() {
      this.docs.add(Image.file(file));
      print("current items : ${this.docs.length}");
    });
  }

  // object of AuthService
  final AuthService _auth = AuthService();

  //upload image to firebase
  FirebaseStorage _storage = FirebaseStorage.instance;

  // list item
  Widget listItem(int index) {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: this.imageFromPreferences,
        //     Container(
        //   padding: EdgeInsets.only(right: 12.0),
        //   decoration: new BoxDecoration(
        //       border: new Border(
        //           right: new BorderSide(
        //               width: 1.0,
        //               color: this.darkMode ? Colors.white24 : Colors.black))),
        //   child: Icon(Icons.cloud_upload,
        //       color: this.darkMode ? Colors.white : Colors.black),
        // ),
        title: Text(
          "Undefined${index + 1}",
          style: TextStyle(
              color: this.darkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold),
        ),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

        subtitle: Row(
          children: <Widget>[
            Icon(Icons.date_range, color: Colors.red),
            Text(" Intermediate", style: TextStyle(color: Colors.white))
          ],
        ),
        trailing: Icon(Icons.edit,
            color: this.darkMode ? Colors.white : Colors.black, size: 30.0));
  }

  // animations
  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    degOneTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.2), weight: 75.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.2, end: 1.0), weight: 25.0),
    ]).animate(animationController);
    degTwoTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.4), weight: 55.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.4, end: 1.0), weight: 45.0),
    ]).animate(animationController);
    degThreeTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.75), weight: 35.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.75, end: 1.0), weight: 65.0),
    ]).animate(animationController);
    rotationAnimation = Tween<double>(begin: 180.0, end: 0.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeOut));
    super.initState();
    animationController.addListener(() {
      setState(() {});
    });
  }

  // build method
  @override
  Widget build(BuildContext context) {
    setState(() {});

    // for current size of the screen
    Size size = MediaQuery.of(context).size;

    // home page widget
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'I scanner',
          style: TextStyle(color: Colors.red),
        ),
        iconTheme: IconThemeData(color: Colors.red),
        backgroundColor: this.darkMode ? Colors.black : Colors.white,
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(
              Icons.person,
              color: Colors.red,
            ),
            label: Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () async {
              await _auth.signOut();
            },
          )
        ],
      ),
      drawer: SafeArea(
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(35),
            bottomRight: Radius.circular(35),
          ),
          child: Drawer(
            child: Container(
              decoration: BoxDecoration(
                color: this.darkMode ? Colors.grey[900] : Colors.white,
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
                      mode: this.darkMode,
                      value: this.darkMode,
                      onChanged: (bool val) {
                        setState(() {
                          this.darkMode = val;
                          DatabaseService(uid: this.uid).updateUserData(
                              val,
                              this.numDocCollection == null
                                  ? 0
                                  : this.numDocCollection);
                        });
                      },
                    ),
                  ),
                  Material(
                    color: this.darkMode ? Colors.grey[900] : Colors.white,
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
                    color: this.darkMode ? Colors.grey[900] : Colors.white,
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
                    color: this.darkMode ? Colors.grey[900] : Colors.white,
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
          ),
        ),
      ),
      body: Container(
        color: this.darkMode ? Colors.black : Colors.white,
        width: size.width,
        height: size.height,
        child: Stack(
          children: <Widget>[
            Container(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return this.listItem(index);
                },
              ),
            ),
            Positioned(
                right: 30,
                bottom: 30,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: <Widget>[
                    IgnorePointer(
                      child: Container(
                        height: 150.0,
                        width: 150.0,
                      ),
                    ),
                    Transform.translate(
                      offset: Offset.fromDirection(getRadiansFromDegree(270),
                          degOneTranslationAnimation.value * 100),
                      child: Transform(
                        transform: Matrix4.rotationZ(
                            getRadiansFromDegree(rotationAnimation.value))
                          ..scale(degOneTranslationAnimation.value),
                        alignment: Alignment.center,
                        child: CircularButton(
                          color: Colors.red,
                          width: 50,
                          height: 50,
                          icon: Icon(
                            Icons.camera_alt,
                            color: this.darkMode ? Colors.black : Colors.white,
                          ),
                          onClick: () {
                            this._getImageFromCamera();
                            animationController.reverse();
                          },
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset.fromDirection(getRadiansFromDegree(225),
                          degTwoTranslationAnimation.value * 100),
                      child: Transform(
                        transform: Matrix4.rotationZ(
                            getRadiansFromDegree(rotationAnimation.value))
                          ..scale(degTwoTranslationAnimation.value),
                        alignment: Alignment.center,
                        child: CircularButton(
                          color: Colors.red,
                          width: 50,
                          height: 50,
                          icon: Icon(
                            Icons.photo,
                            color: this.darkMode ? Colors.black : Colors.white,
                          ),
                          onClick: () {
                            this.loadAssets();
                            animationController.reverse();
                          },
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset.fromDirection(getRadiansFromDegree(180),
                          degThreeTranslationAnimation.value * 100),
                      child: Transform(
                        transform: Matrix4.rotationZ(
                            getRadiansFromDegree(rotationAnimation.value))
                          ..scale(degThreeTranslationAnimation.value),
                        alignment: Alignment.center,
                        child: CircularButton(
                          color: Colors.red,
                          width: 50,
                          height: 50,
                          icon: Icon(
                            Icons.comment,
                            color: this.darkMode ? Colors.black : Colors.white,
                          ),
                          onClick: () {
                            animationController.reverse();
                            print('Third Button');
                          },
                        ),
                      ),
                    ),
                    Transform(
                      transform: Matrix4.rotationZ(
                          getRadiansFromDegree(rotationAnimation.value)),
                      alignment: Alignment.center,
                      child: CircularButton(
                        color: Colors.red,
                        width: 60,
                        height: 60,
                        icon: Icon(
                          Icons.add,
                          color: this.darkMode ? Colors.black : Colors.white,
                        ),
                        onClick: () {
                          if (animationController.isCompleted) {
                            animationController.reverse();
                          } else {
                            animationController.forward();
                          }
                        },
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

// class for floating buttons
class CircularButton extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Icon icon;
  final Function onClick;

  CircularButton(
      {this.color, this.width, this.height, this.icon, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      width: width,
      height: height,
      child: IconButton(icon: icon, enableFeedback: true, onPressed: onClick),
    );
  }
}
