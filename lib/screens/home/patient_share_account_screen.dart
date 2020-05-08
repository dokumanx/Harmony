import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harmony/repository/user_data_repository.dart';
import 'package:harmony/repository/user_repository.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PatientShareAccountScreen extends StatefulWidget {
  final UserDataRepository userDataRepository;

  const PatientShareAccountScreen({this.userDataRepository});

  @override
  _PatientShareAccountScreenState createState() =>
      _PatientShareAccountScreenState();
}

List<String> _dummyData = ["Nahit", "Mohsen", "Hüseyin"];

class _PatientShareAccountScreenState extends State<PatientShareAccountScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relative List'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: ShowRelativeListTile(
              userDataRepository: widget.userDataRepository,
            ),
          ),
          Expanded(
            flex: 1,
            child: QrCodeGenerator(),
          )
        ],
      ),
    );
  }
}

/// ListTile of Relatives

class ShowRelativeListTile extends StatelessWidget {
  // TODO: Wrap this with StreamBuilder to track changes
  final UserDataRepository _userDataRepository;

  const ShowRelativeListTile({userDataRepository})
      : _userDataRepository = userDataRepository;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _userDataRepository.getPatient,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Container(
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: MyCircleAvatar(index: index),
                        title: Text(
                          _dummyData[index],
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete_forever,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            // TODO: Delete Relative From FireStore
                          },
                        ),
                      ),
                    );
                  },
                ),
              )
            : Container(
                child: Center(child: Text('No Data Founded')),
              );
      },
    );
  }
}

/// Custom CircleAvatar

class MyCircleAvatar extends CircleAvatar {
  final int _index;

  const MyCircleAvatar({index}) : _index = index;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        maxRadius: 22,
        child: Container(
          child: Text(_dummyData[_index].substring(0, 1).toUpperCase()),
        ));
  }
}

class QrCodeGenerator extends StatefulWidget {
  @override
  _QrCodeGeneratorState createState() => _QrCodeGeneratorState();
}

class _QrCodeGeneratorState extends State<QrCodeGenerator> {
  String uid;

  UserRepository _userRepository;

  Future<String> getUid() async {
    uid = await _userRepository.getUserId();
    return uid;
  }

  @override
  void initState() {
    _userRepository = RepositoryProvider.of<UserRepository>(context);
    getUid();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        FutureBuilder(
          future: getUid(),
          builder: (context, snapshot) => QrImage(
            padding: EdgeInsets.all(20),
            data: snapshot.data.toString() ?? "",
            size: 130.0,
          ),
        ),
        Flexible(
          fit: FlexFit.tight,
          child: Container(
            color: Colors.red,
            child: Text('Burası Sonra Doldurulacak'),
          ),
        )
      ],
    );
  }
}
