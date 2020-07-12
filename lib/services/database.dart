import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  //collection reference
  final CollectionReference scannedDataCollection =
      Firestore.instance.collection('ScannedData');

  Future<void> updateUserData(bool mode) async {
    return await scannedDataCollection.document(uid).setData({'mode': mode});
  }

  // getting the current mode
  Stream<QuerySnapshot> get currentMode {
    return scannedDataCollection.snapshots();
  }
}
