import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:harmony/blocs/sharing_account_bloc/bloc.dart';
import 'package:harmony/models/user.dart';
import 'package:harmony/repository/user_data_repository.dart';

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
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(FontAwesomeIcons.userPlus),
        onPressed: () async {
          String email = await FlutterBarcodeScanner.scanBarcode(
                  "#004297", "Cancel", true, ScanMode.DEFAULT)
              .then(
            (value) => value.substring(18),
          );
          BlocProvider.of<SharingAccountBloc>(context).add(
              SharingAccountAdded(email: email, userType: UserType.relative));
        },
      ),
      appBar: AppBar(
        title: Text('Relative List'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ShowRelativeListTile(),
          ),
        ],
      ),
    );
  }
}

/// ListTile of Relativesa

class ShowRelativeListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserDataRepository _userDataRepository =
        RepositoryProvider.of<UserDataRepository>(context);

    // ignore: close_sinks
    SharingAccountBloc _sharingAccountBloc =
        BlocProvider.of<SharingAccountBloc>(context);

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
                if (snapshot.data.relatives.length != 0) {
                  return Container(
                    child: ListView.builder(
                      itemCount: snapshot.data.relatives.length,
                      itemBuilder: (context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            leading: MyCircleAvatar(
                                index: index, snapshot: snapshot),
                            title: Text(
                              snapshot.data.relatives[index].name,
                            ),
                            trailing: IconButton(
                              icon: FaIcon(
                                FontAwesomeIcons.userAltSlash,
                              ),
                              onPressed: () async {
                                _sharingAccountBloc.add(SharingAccountDeleted(
                                  email: snapshot.data.relatives[index].email,
                                  userType:
                                      snapshot.data.relatives[index].userType,
                                ));
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
