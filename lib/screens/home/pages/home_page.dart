import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:i_scanner/services/auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:i_scanner/screens/home/extras/nothing_here.dart';
import 'package:i_scanner/screens/home/extras/doc_card.dart';
import 'package:i_scanner/screens/home/extras/switch.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import '../../../models/user.dart';
import '../../../services/database.dart';
import 'package:provider/provider.dart';
// import 'dart:convert';
// import 'package:i_scanner/main.dart';
// import 'package:i_scanner/screens/home/extras/view.dart';

// scanner app
class IScanner extends StatefulWidget {
  final User user;
  IScanner({this.user});
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
      home: Home(user: widget.user), // calling home page
    );
  }
}

// home page for the app
class Home extends StatefulWidget {
  final User user;
  Home({this.user});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  //multi img picker
  List<File> images = List<File>();
  List<Asset> assets = List<Asset>();
  String _error = 'No Error Dectected';
  File sampleImg;

  // counting available document collections
  int numDocCollection = 0;

  //Multi image picker
  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = assets[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  // for accessing images from camera and gallery
  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        // selectedAssets: images,
        materialOptions: MaterialOptions(
          actionBarColor: "	#FF0000",
          actionBarTitle: "Select Files",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "	#FF0000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
      print(_error);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    // converting assets to files
    List<File> fileImageArray = [];
    resultList.forEach(
      (imageAsset) async {
        final filePath =
            await FlutterAbsolutePath.getAbsolutePath(imageAsset.identifier);

        File tempFile = File(filePath);
        if (tempFile.existsSync()) {
          fileImageArray.add(tempFile);
        }
      },
    );

    // storing files
    setState(() {
      assets = resultList;
      images = fileImageArray;
      this.numDocCollection += 1;
      this.uploadDocCollection(this.numDocCollection, images);
      _error = error;
    });
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

  // object of AuthService
  final AuthService _auth = AuthService();

  //upload image to firebase
  FirebaseStorage _storage = FirebaseStorage.instance;

  //for getting userId
  final FirebaseAuth _auth2 = FirebaseAuth.instance;
  String uid;
  Future inputData() async {
    final FirebaseUser user = await _auth2.currentUser();
    uid = user.uid;
  }

  // uploading single collection
  Future uploadDocCollection(int docCollectionIdx, List<File> images) async {
    await inputData();
    String docColletionName = 'Undefine$docCollectionIdx';
    for (int i = 1; i < images.length; i++) {
      String filePath =
          '$uid/$docColletionName ${DateTime.now()}/$i/original.png';
      StorageReference reference = _storage.ref().child(filePath);
      StorageUploadTask uploadTask = reference.putFile(images[i]);
      // Uri location = (await uploadTask.future).downloadUrl;
    }
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

  // Future<void> setMode() async {
  //   final mode = Provider.of<QuerySnapshot>(context);
  //   print('current mode is ${mode.documents}');
  // }

  // build method
  @override
  Widget build(BuildContext context) {
    // for current size of the screen
    Size size = MediaQuery.of(context).size;

    // checking for dark mode
    // this.setMode();

    // checking if docs are present or not
    if (this.docs != null) {
      print("current number of docs is ${this.docs.length}");
    } else {
      print("current number of docs is 0");
    }

    // home page widget
    return StreamProvider<QuerySnapshot>.value(
      value: DatabaseService().currentMode,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Title goes here...',
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
                        onChanged: (bool val) async {
                          await DatabaseService(uid: widget.user.uid)
                              .updateUserData(val);
                          setState(() {
                            this.darkMode = val;
                          });
                        },
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
        body:
            /*Column(
          children: <Widget>[
            Center(child: Text('Error: $_error')),
            RaisedButton(
              child: Text("Pick images"),
              onPressed: loadAssets,
            ),
            Expanded(
              child: buildGridView(),
            ),
          ],
        ),*/

            Container(
          color: this.darkMode ? Colors.black : Colors.white,
          width: size.width,
          height: size.height,
          child: Stack(
            children: <Widget>[
              Center(
                child: this.docs.isEmpty
                    ? NothingHerePage()
                    : ListView.builder(
                        itemCount: this.docs == null ? 0 : this.docs.length,
                        itemBuilder: (context, index) {
                          return DocCard(
                              mode: this.darkMode,
                              index: index,
                              title: 'Undefined${index + 1}',
                              image: this.docs[index] != null
                                  ? this.docs[index]
                                  : Image.asset('assets/images/sample.jpg'),
                              dateAdded: '12/12/12',
                              sampleImg: sampleImg);
                        },
                      ),
              ),
              // RaisedButton(
              //   child: Text('Upload'),
              //   onPressed: () {
              //     uploadPic();
              //   },
              // ),
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
                              color:
                                  this.darkMode ? Colors.black : Colors.white,
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
                              color:
                                  this.darkMode ? Colors.black : Colors.white,
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
