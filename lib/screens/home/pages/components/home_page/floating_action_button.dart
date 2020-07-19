import 'package:flutter/material.dart';
import 'circular_button.dart';

class MainActionButton extends StatefulWidget {
  final bool darkMode;
  final Function loadAssets;
  final Function getImageFromCamera;
  MainActionButton({this.darkMode, this.loadAssets, this.getImageFromCamera});

  // for animation stuff
  @override
  _MainActionButtonState createState() => _MainActionButtonState();
}

class _MainActionButtonState extends State<MainActionButton>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  Animation degOneTranslationAnimation,
      degTwoTranslationAnimation,
      degThreeTranslationAnimation;

  Animation rotationAnimation;

  double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  Widget listItem(int index) {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(
                      width: 1.0,
                      color: widget.darkMode ? Colors.white24 : Colors.black))),
          child: Icon(Icons.cloud_upload,
              color: widget.darkMode ? Colors.white : Colors.black),
        ),
        title: Text(
          "Undefined${index + 1}",
          style: TextStyle(
              color: widget.darkMode ? Colors.white : Colors.black,
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
            color: widget.darkMode ? Colors.white : Colors.black, size: 30.0));
  }

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

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                        color: widget.darkMode ? Colors.black : Colors.white,
                      ),
                      onClick: () {
                        widget.getImageFromCamera();
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
                        color: widget.darkMode ? Colors.black : Colors.white,
                      ),
                      onClick: () {
                        widget.loadAssets();
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
                        color: widget.darkMode ? Colors.black : Colors.white,
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
                      color: widget.darkMode ? Colors.black : Colors.white,
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
    );
  }
}
