import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:harmony/shared/constants.dart';
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

class _FaceScreenState extends State<FaceScreen> with SingleTickerProviderStateMixin {
  File _image;
  File _compareImage;
  final picker = ImagePicker();
  FaceList facelist;
  String userName;
  final _formKey = GlobalKey<FormState>();
  final textController = TextEditingController();
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }


  Future uploadImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
    _compareImage = File(pickedFile.path);
    });

    final faceData = await pushCompareData(_compareImage);
    setState(() {
    facelist = faceData;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Faces"),
        bottom: TabBar(
          tabs: [
            Tab(child: Text("Upload")),
            Tab(child: Text("Compare")),
          ],
          indicatorColor: Colors.white,
          controller: _tabController,
        )
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: textController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: RaisedButton(
                          onPressed: () async {
                            final pickedFile = await picker.getImage(source: ImageSource.gallery);

                            setState(() {
                              _image = File(pickedFile.path);
                            });
                          },
                          child: Text('Choose a photo'),
                        ),
                      ),
                    ),
                    Container(width: 10.0,),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: RaisedButton(
                          onPressed: () async {
                            // Validate returns true if the form is valid, or false
                            // otherwise.
                            if (_formKey.currentState.validate()) {
                              // If the form is valid, display a Snackbar.
                              var result = await pushData(_image, textController.text);
                              if (result.success) {
                                Scaffold.of(context)
                                    .showSnackBar(SnackBar(content: Text("${result.data.personId} inserted.")));
                                textController.clear();
                              }
                            }
                          },
                          child: Text('Add'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: <Widget> [
              Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(height: 25,),
                  Container(width: 200, height: 200,
                      child: _compareImage == null ? Center(child: Text("No Image")) : Image.file(_compareImage)),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Container(child:
                    facelist == null ?
                    Text("Having a hard time remembering faces?")
                        :Text(
                        facelist.person == null ? "This person is not registered"
                            : "${facelist.person.name}"
                    )),
                  ),
                ],
              ),
            ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: RaisedButton(
                  onPressed: uploadImage,
                  child: Text('Choose a photo'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<FaceListResult> pushData(File image, String name) async {
  //final String url = "http://localhost:3000/api/v1/";

  Map<String, String> headers = {
    "Content-Type" : "application/json",
    "Accept" : "application/json",
  };

  // body data iguess
  Map<String, String> fields = {
    "name": name,
  };

  var length = await image.length();
  var stream = http.ByteStream(DelegatingStream.typed(image.openRead()));
  var uri = Uri.parse(SERVER_URL + SERVER_PORT + "/face");

  var request = new http.MultipartRequest("POST", uri);

  var multipartFileSign = http.MultipartFile("file", stream, length, filename: basename(image.path));

  request.files.add(multipartFileSign);

  request.headers.addAll(headers);
  request.fields.addAll(fields);

  var streamResponse = await request.send();

  var response = await http.Response.fromStream(streamResponse);

  print(response.body);

  var jsonify = jsonDecode(response.body);

  return FaceListResult.fromJson(jsonify);

}

Future<FaceList> pushCompareData(File image) async {
  //final String url = "http://localhost:3000/api/v1/";

  Map<String, String> headers = {
    "Content-Type" : "application/json",
    "Accept" : "application/json",
  };


  var length = await image.length();
  var stream = http.ByteStream(DelegatingStream.typed(image.openRead()));
  var uri = Uri.parse(SERVER_URL + SERVER_PORT + "/compare");

  var request = new http.MultipartRequest("POST", uri);

  var multipartFileSign = http.MultipartFile("file", stream, length, filename: basename(image.path));

  request.files.add(multipartFileSign);

  request.headers.addAll(headers);

  var streamResponse = await request.send();

  var response = await http.Response.fromStream(streamResponse);

  print(response.body);

  var jsonify = jsonDecode(response.body);

  return FaceList.fromJson(jsonify);

}
