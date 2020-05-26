//TODO : This screen will be our main screen in the app.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  String todoTitle = "";

  createTodos() {
    DocumentReference documentReference =
        Firestore.instance.collection("MyTodos").document(todoTitle);

    //Map
    Map<String, String> todos = {"todoTitle": todoTitle};

    documentReference.setData(todos).whenComplete(() {
      print("$todoTitle created");
    });
  }

  deleteTodos(item) {
    DocumentReference documentReference =
        Firestore.instance.collection("MyTodos").document(item);

    documentReference.delete().whenComplete(() {
      print("$item deleted");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("mytodos"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  title: Text("Add Todolist"),
                  content: TextField(
                    onChanged: (String value) {
                      todoTitle = value;
                    },
                  ),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          createTodos();

                          Navigator.of(context).pop();
                        },
                        child: Text("Add"))
                  ],
                );
              });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection("MyTodos").snapshots(),
          builder: (context, snapshots) {
            if (snapshots.hasData) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshots.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot =
                        snapshots.data.documents[index];
                    return Dismissible(
                        onDismissed: (direction) {
                          deleteTodos(documentSnapshot["todoTitle"]);
                        },
                        key: Key(documentSnapshot["todoTitle"]),
                        child: Card(
                          elevation: 4,
                          margin: EdgeInsets.all(8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: ListTile(
                            title: Text(documentSnapshot["todoTitle"]),
                            trailing: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  deleteTodos(documentSnapshot["todoTitle"]);
                                }),
                          ),
                        ));
                  });
            } else {
              return Align(
                alignment: FractionalOffset.bottomCenter,
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
