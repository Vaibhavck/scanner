import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  //collection reference
  final CollectionReference isDarkModeEnabled =
      Firestore.instance.collection('isDarkModeEnabled');

  final CollectionReference numDocCollection =
      Firestore.instance.collection('numDocCollection');

  final CollectionReference scannedData =
      Firestore.instance.collection('scannedData');

  Future<void> updateUserData(bool mode, int nDocCollection) async {
    return await scannedData.document(uid).setData({
      'darkModeEnabled': mode,
      'numDocCollection': nDocCollection,
    });
  }

  Future<void> updateUserDarkModeChoice(bool mode) async {
    return await isDarkModeEnabled.document(uid).setData({
      'darkModeEnabled': mode,
    });
  }

  Future<void> updateUserNumDocCollection(int nDocCollection) async {
    return await numDocCollection.document(uid).setData({
      'numDocCollection': nDocCollection,
    });
  }
}
