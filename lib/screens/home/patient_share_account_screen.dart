import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:harmony/repository/user_data_repository.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PatientShareAccountScreen extends StatefulWidget {
  @override
  _PatientShareAccountScreenState createState() =>
      _PatientShareAccountScreenState();
}

class _PatientShareAccountScreenState extends State<PatientShareAccountScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserDataRepository _userDataRepository =
        RepositoryProvider.of<UserDataRepository>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Relative List'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ShowRelativeListTile(
              userDataRepository: _userDataRepository,
            ),
          ),

          FloatingActionButton(
            onPressed: () async {
              await _userDataRepository.addRelative(
                  relativeEmail: "relativeaccount@gmail.com");
            },
          )
//          Expanded(
//            flex: 1,
//            child: QrCodeGenerator(),
//          )
        ],
      ),
    );
  }
}

/// ListTile of Relatives

class ShowRelativeListTile extends StatelessWidget {
  final UserDataRepository userDataRepository;

  ShowRelativeListTile({this.userDataRepository});

  @override
  Widget build(BuildContext context) {
    UserDataRepository _userDataRepository =
        RepositoryProvider.of<UserDataRepository>(context);
    return StreamBuilder(
      stream: _userDataRepository.getPatient,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            if (snapshot.data.relatives.length != 0) {
              return Container(
                child: ListView.builder(
                  itemCount: snapshot.data.relatives.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading:
                            MyCircleAvatar(index: index, snapshot: snapshot),
                        title: Text(
                          snapshot.data.relatives[index].name,
                        ),
                        trailing: IconButton(
                          icon: FaIcon(
                            FontAwesomeIcons.userAltSlash,
                          ),
                          onPressed: () async {
                            // TODO: Delete Relative From FireStore
                            await _userDataRepository.deleteRelative(
                                relativeEmail:
                                    snapshot.data.relatives[index].email);
                          },
                          tooltip: "Delete Relative",
                        ),
                      ),
                    );
                  },
                ),
              );
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
  }
}

/// Custom CircleAvatar

class MyCircleAvatar extends CircleAvatar {
  final int _index;
  final AsyncSnapshot _snapshot;

  const MyCircleAvatar({index, snapshot})
      : _index = index,
        _snapshot = snapshot;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        maxRadius: 22,
        child: Container(
          child: Text(_snapshot.data.relatives[_index].name
              .substring(0, 1)
              .toUpperCase()),
        ));
  }
}

class QrCodeGenerator extends StatefulWidget {
  @override
  _QrCodeGeneratorState createState() => _QrCodeGeneratorState();
}

class _QrCodeGeneratorState extends State<QrCodeGenerator> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserDataRepository userDataRepository =
        RepositoryProvider.of<UserDataRepository>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        FutureBuilder(
          future: userDataRepository.getUserEmail(),
          builder: (context, snapshot) => QrImage(
            padding: EdgeInsets.all(20),
            data: snapshot.data ?? "",
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
