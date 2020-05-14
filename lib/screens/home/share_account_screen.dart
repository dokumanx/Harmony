//TODO: This file will hold to screen. One for [Patient] and one for [Relative].
//TODO: [Relative] screen will see and add [Patient] button and list of all [Patient]s. Add button trigger camera and take a picture of QR code.
//TODO: [Patient] screen will display a QR code and [Relative] list.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harmony/blocs/sharing_account_bloc/bloc.dart';
import 'package:harmony/repository/user_data_repository.dart';
import 'package:harmony/screens/home/patient_share_account_screen.dart';
import 'package:harmony/screens/home/relative_share_account_screen.dart';

class ShareAccountScreen extends StatelessWidget {
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
                ? PatientShareAccountScreen()
                : RelativeShareAccountScreen();

          return Center(child: CircularProgressIndicator());
        });
  }
}
