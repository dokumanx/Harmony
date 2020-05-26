import 'package:cloud_firestore/cloud_firestore.dart';

class LocationRepository {
  final CollectionReference usersCollection =
      Firestore.instance.collection('users');
}
