import 'dart:convert';

FaceList faceListFromJson(String str) => FaceList.fromJson(json.decode(str));

String faceListToJson(FaceList data) => json.encode(data.toJson());

class FaceList {
  FaceList({
    this.success,
    this.person,
  });

  bool success;
  Person person;

  factory FaceList.fromJson(Map<String, dynamic> json) => FaceList(
    success: json["success"],
    person: Person.fromJson(json["person"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "person": person.toJson(),
  };
}

class Person {
  Person({
    this.imageName,
    this.imageUrl,
    this.bucket,
    this.name,
  });

  String imageName;
  String imageUrl;
  String bucket;
  String name;

  factory Person.fromJson(Map<String, dynamic> json) => Person(
    imageName: json["image_name"],
    imageUrl: json["image_url"],
    bucket: json["bucket"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "image_name": imageName,
    "image_url": imageUrl,
    "bucket": bucket,
    "name": name,
  };
}


FaceListResult faceListResultFromJson(String str) => FaceListResult.fromJson(json.decode(str));

String faceListResultToJson(FaceListResult data) => json.encode(data.toJson());

class FaceListResult {
  FaceListResult({
    this.success,
    this.data,
  });

  bool success;
  Data data;

  factory FaceListResult.fromJson(Map<String, dynamic> json) => FaceListResult(
    success: json["success"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.personId,
  });

  String personId;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    personId: json["person_id"],
  );

  Map<String, dynamic> toJson() => {
    "person_id": personId,
  };
}