import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:harmony/models/face_recognition.dart';


class FaceScreen extends StatefulWidget {
  @override
  _FaceScreenState createState() => _FaceScreenState();
}

class _FaceScreenState extends State<FaceScreen> {
  File _image;
  final picker = ImagePicker();
  FaceList facelist;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });

    final faceData = await pushData(_image);

    setState(() {
      facelist = faceData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Faces")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(child: _image == null ? Text("No Image") : Image.file(_image)),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
            child: Container(child:
            facelist == null ?
                Text("Having a hard time remembering faces?")
            :Text(
              facelist.data == null ? "This person is not registered" : "${facelist.data[0].person.name} ${facelist.data[0].person.family}"
            )),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child:  Icon(
        Icons.add,
        color: Colors.white,
        ),
        onPressed: getImage,
        ),
    );
  }
}

Future<FaceList> pushData(File image) async {
  //final String url = "http://localhost:3000/api/v1/";

  Map<String, String> headers = {
    "Content-Type" : "application/json",
    "Accept" : "application/json",
  };

  var length = await image.length();
  var stream = http.ByteStream(DelegatingStream.typed(image.openRead()));
  var uri = Uri.parse("http://192.168.1.33:3000" + "/api/v1/");

  var request = new http.MultipartRequest("POST", uri);

  var multipartFileSign = http.MultipartFile("image", stream, length, filename: basename(image.path));

  request.files.add(multipartFileSign);

  request.headers.addAll(headers);

  var streamResponse = await request.send();

  var response = await http.Response.fromStream(streamResponse);

  var jsonify = jsonDecode(response.body);

  return FaceList.fromJson(jsonify);

}

