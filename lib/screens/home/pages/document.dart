import 'dart:io';

// class for storing information about added documents
class Doc {
  final String title;
  final String dateAdded;
  final List<File> images;

  Doc({
    this.title,
    this.dateAdded,
    this.images,
  });
}

// class Mode {
//   final bool editMode;
//   Mode({this.editMode});
// }
