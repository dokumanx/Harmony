import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harmony/blocs/authentication_bloc/bloc.dart';
import 'package:harmony/repository/user_data_repository.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context)
                ..add(
                  LoggedOut(),
                );
            },
          )
        ],
      ),
      body: Container(child: QrCodeGenerator() ?? Container()),
    );
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
    return FutureBuilder(
      future: userDataRepository.getUserEmail(),
      builder: (context, snapshot) => QrImage(
        padding: EdgeInsets.all(20),
        data: ("User email adress:${snapshot.data}") ?? "",
        size: 300.0,
      ),
    );
  }
}
