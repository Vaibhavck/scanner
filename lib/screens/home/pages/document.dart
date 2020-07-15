import 'dart:io';
import 'package:flutter/material.dart';

// class for storing information about added documents
class Doc {
  final String title;
  final String dateAdded;
  final Image image;
  final File sampleImg;

  Doc({this.title, this.dateAdded, this.image, this.sampleImg});
}
