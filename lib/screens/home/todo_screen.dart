import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:harmony/blocs/sharing_account_bloc/bloc.dart';
import 'package:harmony/repository/user_data_repository.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

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

    return BlocConsumer<SharingAccountBloc, SharingAccountState>(
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
                return TodoScreenLogic(data: snapshot.data.todoList);
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
  final DateFormat _formatter = DateFormat('yyyy-MM-dd');

  String todoTitle = "";
  DateTime _selectedDate;
  TimeOfDay _selectedTime;
  String _formattedDate;
  String _formattedTime;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  createTodos(userEmail) async {
    Firestore.instance.collection("users").document(userEmail).updateData({
      'todoList': FieldValue.arrayUnion([todoTitle])
    });
  }

  deleteTodos(item) {
    Firestore.instance
        .collection("users")
        .document("patientaccount@gmail.com")
        .updateData({
      "todoList": FieldValue.arrayRemove([item])
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        _formattedDate = _formatter.format(_selectedDate);
        print(_formattedDate);
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _formattedTime = "${_selectedTime.hour}"
            ":"
            "${_selectedTime.minute.toString().padLeft(2, '0')}";
        print(_formattedTime);
      });
    }
  }

  Future<void> _scheduleNotification(int seconds) async {
    var scheduledNotificationDateTime =
        DateTime.now().add(Duration(seconds: seconds));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
      0,
      "TODO",
      todoTitle,
      scheduledNotificationDateTime,
      platformChannelSpecifics,
    );
  }

  void _dateTime(BuildContext context) async {
    await _selectDate(context);
    await _selectTime(context);

    DateTime currentDate = DateTime.now();
    TimeOfDay currentTime = TimeOfDay.now();
    String formattedCurrentDate = _formatter.format(currentDate);
    String formattedCurrentTime = "${currentTime.hour}"
        ":"
        "${currentTime.minute.toString().padLeft(2, '0')}";

    String pickedDateTime = _formattedDate + " " + _formattedTime;
    String currentDateTime = formattedCurrentDate + " " + formattedCurrentTime;
    Duration timeDifference = DateTime.parse(pickedDateTime)
        .difference(DateTime.parse(currentDateTime));

    print(timeDifference.inSeconds);
    _scheduleNotification(timeDifference.inSeconds);
  }

  @override
  Widget build(BuildContext context) {
    var todo = this.widget.data;

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
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text("Cancel"),
                      ),
                      FlatButton(
                        onPressed: () async {
                          var ur = UserDataRepository();
                          var userEmail = await ur.getUserEmail();
                          await _dateTime(context);
                          await createTodos(userEmail);
                          Navigator.of(context).pop();
                        },
                        child: Text("Add"),
                      ),
                    ],
                  );
                });
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: ListView.builder(
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
                            deleteTodos(todo[index]);
                          }),
                    ),
                  ));
            }),
      ),
    );
  }
}
