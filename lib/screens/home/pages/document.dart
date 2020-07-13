import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// class for storing information about added documents
class Doc {
  final String title;
  final String dateAdded;
  final Image image;
  final File sampleImg;

  Doc({this.title, this.dateAdded, this.image, this.sampleImg});
}

// class Mode {
//   final bool editMode;
//   Mode({this.editMode});
// }
