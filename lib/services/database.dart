import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference collection = Firestore.instance.collection('docs');

  Future<void> updateUserData(List<DocCollection> docCollection) async {
    print("current length of doc collection is  :  ${docCollection.length}");
    return await collection.document(uid).setData({
      'docCollection': docCollection,
    });
  }
}

class DocCollection {
  int numRecords;
  List<File> images;
  DocCollection({
    this.numRecords,
    this.images,
  });
}
