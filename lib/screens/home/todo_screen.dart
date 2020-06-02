//TODO : This screen will be our main screen in the app.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harmony/blocs/sharing_account_bloc/bloc.dart';
import 'package:harmony/repository/user_data_repository.dart';



class TodoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => UserDataRepository(),
      child: BlocProvider(
          create: (context) => SharingAccountBloc(
              userDataRepository:
              RepositoryProvider.of<UserDataRepository>(context)),
          child: ReturnProperUser()),
    );
  }
}

class ReturnProperUser extends StatefulWidget {
  @override
  _ReturnProperUserState createState() => _ReturnProperUserState();
}

class _ReturnProperUserState extends State<ReturnProperUser> {
  @override
  Widget build(BuildContext context) {
    UserDataRepository _userDataRepository =
    RepositoryProvider.of<UserDataRepository>(context);

    return FutureBuilder(
        future: _userDataRepository.getUserType(),
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return (snapshot.data == "Patient")
                ? TodoScreenChild()
                : Container();

          return Center(child: CircularProgressIndicator());
        });
  }
}



class TodoScreenChild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserDataRepository _userDataRepository =
    RepositoryProvider.of<UserDataRepository>(context);

    // ignore: close_sinks

    return  BlocConsumer<SharingAccountBloc, SharingAccountState>(
      listener: (context, state) {
        if (state is SharingAccountInProgressState) {
          Scaffold.of(context)
            ..showSnackBar(SnackBar(
              content: Text(
                "Done",
                style: TextStyle(fontSize: 20),
              ),
              duration: Duration(milliseconds: 2000),
              backgroundColor: Colors.green[400],
            ));
        }
      },
      builder: (context, state) {
        return StreamBuilder(
          stream: _userDataRepository.getPatient,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                assert(snapshot.data != null);
                if (snapshot.data.todoList.length != 0) {
                  return TodoScreenLogic(data: snapshot.data.todoList);
                } else {
                  return Container(
                    child: Center(
                        child: Text(
                          'No Relative Founded',
                          style: TextStyle(fontSize: 24),
                        )),
                  );
                }
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            }
            return Container(
              child: Center(
                child: Text('An error occured. Please try again.'),
              ),
            );
          },
        );
      },
    );
  }
}

class TodoScreenLogic extends StatefulWidget {
  TodoScreenLogic({@required this.data});

  final List<String> data;

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreenLogic> {
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
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        appBar: AppBar(
          title: Text("My TODOs"),
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
              if (widget.data.isNotEmpty) {
                var todo = this.widget.data;
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: this.widget.data.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                          onDismissed: (direction) {
                            deleteTodos(todo[index]);
                          },
                          key: Key(todo[index]),
                          child: Card(
                            elevation: 4,
                            margin: EdgeInsets.all(8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: ListTile(
                              title: Text(this.widget.data[index]),
                              trailing: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    // deleteTodos(documentSnapshot["todoTitle"]);
                                    print("Let's say we deleted it.");
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
      ),
    );
  }
}

/*
ListView.builder(
itemCount: snapshot.data.todoList.length,
itemBuilder: (context, index) {
return Container(
child: TodoScreenLogic(data: snapshot.data.todoList[index],),
);
},
),
);

 */