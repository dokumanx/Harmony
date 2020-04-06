import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:harmony/models/brew.dart';
import 'package:harmony/models/user.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference brewCollection =
      Firestore.instance.collection('brews');

  Future<void> updateUserData(
      {String sugars: "0", String name = "newUser", int strength = 100}) async {
    return await brewCollection.document(uid).setData({
      "sugars": sugars,
      "name": name,
      "strength": strength,
    });
  }

  List<Brew> _brewListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.documents
        .map((doc) => Brew.fromBrewDocument(doc))
        .toList();
  }

  // get brew Stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData.fromDocumentSnapshot(uid, snapshot);
  }

  // get userData Stream
  Stream<UserData> get userData {
    return brewCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }
}
