import 'package:cloud_firestore/cloud_firestore.dart';

class Brew {
  final String name;
  final int strength;
  final String sugars;

  Brew({this.name, this.strength, this.sugars});

  factory Brew.fromBrewDocument(DocumentSnapshot brewDoc) {
    return Brew(
            name: brewDoc.data['name'] ?? "",
            strength: brewDoc.data['strength'] ?? 0,
            sugars: brewDoc.data['sugars']) ??
        "";
  }
}
