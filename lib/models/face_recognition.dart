import 'dart:convert';

FaceList welcomeFromJson(String str) => FaceList.fromJson(json.decode(str));

String welcomeToJson(FaceList data) => json.encode(data.toJson());

class FaceList {
  bool success;
  List<Faces> data;

  FaceList({
    this.success,
    this.data,
  });

  factory FaceList.fromJson(Map<String, dynamic> json) => FaceList(
    success: json["success"],
    data: List<Faces>.from(json["data"].map((x) => Faces.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Faces {
  String personId;
  Person person;
  Data data;

  Faces({
    this.personId,
    this.person,
    this.data,
  });

  factory Faces.fromJson(Map<String, dynamic> json) => Faces(
    personId: json["personId"],
    person: Person.fromJson(json["person"]),
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "personId": personId,
    "person": person.toJson(),
    "data": data.toJson(),
  };
}

class Data {
  double similarity;
  Face face;

  Data({
    this.similarity,
    this.face,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    similarity: json["Similarity"].toDouble(),
    face: Face.fromJson(json["Face"]),
  );

  Map<String, dynamic> toJson() => {
    "Similarity": similarity,
    "Face": face.toJson(),
  };
}

class Face {
  BoundingBox boundingBox;
  int confidence;
  List<Landmark> landmarks;
  Pose pose;
  Quality quality;

  Face({
    this.boundingBox,
    this.confidence,
    this.landmarks,
    this.pose,
    this.quality,
  });

  factory Face.fromJson(Map<String, dynamic> json) => Face(
    boundingBox: BoundingBox.fromJson(json["BoundingBox"]),
    confidence: json["Confidence"],
    landmarks: List<Landmark>.from(json["Landmarks"].map((x) => Landmark.fromJson(x))),
    pose: Pose.fromJson(json["Pose"]),
    quality: Quality.fromJson(json["Quality"]),
  );

  Map<String, dynamic> toJson() => {
    "BoundingBox": boundingBox.toJson(),
    "Confidence": confidence,
    "Landmarks": List<dynamic>.from(landmarks.map((x) => x.toJson())),
    "Pose": pose.toJson(),
    "Quality": quality.toJson(),
  };
}

class BoundingBox {
  double width;
  double height;
  double left;
  double top;

  BoundingBox({
    this.width,
    this.height,
    this.left,
    this.top,
  });

  factory BoundingBox.fromJson(Map<String, dynamic> json) => BoundingBox(
    width: json["Width"].toDouble(),
    height: json["Height"].toDouble(),
    left: json["Left"].toDouble(),
    top: json["Top"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "Width": width,
    "Height": height,
    "Left": left,
    "Top": top,
  };
}

class Landmark {
  String type;
  double x;
  double y;

  Landmark({
    this.type,
    this.x,
    this.y,
  });

  factory Landmark.fromJson(Map<String, dynamic> json) => Landmark(
    type: json["Type"],
    x: json["X"].toDouble(),
    y: json["Y"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "Type": type,
    "X": x,
    "Y": y,
  };
}

class Pose {
  double roll;
  double yaw;
  double pitch;

  Pose({
    this.roll,
    this.yaw,
    this.pitch,
  });

  factory Pose.fromJson(Map<String, dynamic> json) => Pose(
    roll: json["Roll"].toDouble(),
    yaw: json["Yaw"].toDouble(),
    pitch: json["Pitch"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "Roll": roll,
    "Yaw": yaw,
    "Pitch": pitch,
  };
}

class Quality {
  double brightness;
  double sharpness;

  Quality({
    this.brightness,
    this.sharpness,
  });

  factory Quality.fromJson(Map<String, dynamic> json) => Quality(
    brightness: json["Brightness"].toDouble(),
    sharpness: json["Sharpness"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "Brightness": brightness,
    "Sharpness": sharpness,
  };
}

class Person {
  String phone;
  String mobile;
  String imagename;
  String name;
  String email;
  String address;
  String family;

  Person({
    this.phone,
    this.mobile,
    this.imagename,
    this.name,
    this.email,
    this.address,
    this.family,
  });

  factory Person.fromJson(Map<String, dynamic> json) => Person(
    phone: json["phone"],
    mobile: json["mobile"],
    imagename: json["imagename"],
    name: json["name"],
    email: json["email"],
    address: json["address"],
    family: json["family"],
  );

  Map<String, dynamic> toJson() => {
    "phone": phone,
    "mobile": mobile,
    "imagename": imagename,
    "name": name,
    "email": email,
    "address": address,
    "family": family,
  };
}
