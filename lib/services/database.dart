import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  //collection reference
  final CollectionReference ScannedDataCollection =
      Firestore.instance.collection('ScannedData');

  Future<void> updateUserData(String title) async {
    return await ScannedDataCollection.document(uid).setData({'Title': title});
  }
}
