import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:i_scanner/services/auth.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:i_scanner/screens/home/extras/nothing_here.dart';
import 'package:i_scanner/screens/home/extras/doc_card.dart';
import 'package:i_scanner/screens/home/extras/switch.dart';
import 'package:file_picker/file_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

// scanner app
class IScanner extends StatefulWidget {
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
      home: Home(), // calling home page
    );
  }
}

// home page for the app
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
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
  List<List<File>> _docs = List<List<File>>();

  // image picker for picking images from gallery or camera
  // ImagePicker _imagePicker = ImagePicker();

  // method for getting images from camera
  // Future _getImageFromCamera() async {
  //   PickedFile image = await _imagePicker.getImage(source: ImageSource.camera);
  //   File file = File(image.path);
  //   setState(() {
  //     this.docs.add(Image.file(file));
  //     print("current items : ${this.docs.length}");
  //   });
  // }

  // object of AuthService
  final AuthService _auth = AuthService();

  // method for getting images from gallery
  // Future _getImageFromGallery() async {
  //   PickedFile image = await _imagePicker.getImage(source: ImageSource.gallery);
  //   File file = File(image.path);
  //   setState(() {
  //     this._docs.add(Image.file(file));
  //     print("current items : ${this._docs.length}");
  //   });
  // }

  // test method
  List<File> _files;
  List<Asset> cameraPickedImages = List<Asset>();
  String _error = 'No Error Dectected';
  Future test() async {
    List<File> files = await FilePicker.getMultiFile(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc'],
    );
    if (files == null) {
      print("No image selected");
    } else {
      _files = files;
      this._docs.add(_files);
    }
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: cameraPickedImages,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
      print(error);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      cameraPickedImages = resultList;
      print(_error);
    });
  }

  // animations
  @override
  void initState() {
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
    // for current size of the screen
    Size size = MediaQuery.of(context).size;

    // checking if docs are present or not
    // if (this.docs != null) {
    //   print("current number of docs is ${this.docs.length}");
    // } else {
    //   print("current number of docs is 0");
    // }

    // test method
    if (this._docs != null) {
      print("current number of docs is ${this._docs.length}");
    } else {
      print("current number of docs is 0");
    }

    // home page widget
    return Scaffold(
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
                        onChanged: (bool val) {
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
        body: Container(
          color: this.darkMode ? Colors.black : Colors.white,
          width: size.width,
          height: size.height,
          child: Stack(
            children: <Widget>[
              Center(
                child: this._docs.isEmpty
                    ? NothingHerePage()
                    : ListView.builder(
                        itemCount: this._docs == null ? 0 : this._docs.length,
                        itemBuilder: (context, index) {
                          return DocCard(
                            mode: this.darkMode,
                            index: index,
                            title: 'Undefined${index + 1}',
                            images: this._docs[index][0] != null
                                ? this._docs[index]
                                : Image.asset('assets/images/sample.jpg'),
                            dateAdded: '12/12/12',
                          );
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
                              color:
                                  this.darkMode ? Colors.black : Colors.white,
                            ),
                            onClick: () {
                              // this._getImageFromCamera();
                              this.loadAssets();
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
                              color:
                                  this.darkMode ? Colors.black : Colors.white,
                            ),
                            onClick: () {
                              // this._getImageFromGallery();
                              this.test();
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
        ));
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
