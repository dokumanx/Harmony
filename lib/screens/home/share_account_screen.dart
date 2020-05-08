//TODO: This file will hold to screen. One for [Patient] and one for [Relative].
//TODO: [Relative] screen will see and add [Patient] button and list of all [Patient]s. Add button trigger camera and take a picture of QR code.
//TODO: [Patient] screen will display a QR code and [Relative] list.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:harmony/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:harmony/blocs/authentication_bloc/authentication_state.dart';
import 'package:harmony/repository/user_data_repository.dart';
import 'package:harmony/screens/home/patient_share_account_screen.dart';
import 'package:harmony/screens/home/releative_share_account_screen.dart';

class ShareAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => UserDataRepository(),
      child: ReturnProperUser(),
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
    UserDataRepository _userDataRepository;

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is Authenticated) {
          _userDataRepository = UserDataRepository(uid: state.displayUid);

          return FutureBuilder(
              future: _userDataRepository.getUser(),
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return (snapshot.data == "Patient")
                      ? PatientShareAccountScreen(
                          userDataRepository: _userDataRepository)
                      : RelativeShareAccountScreen(
                          userDataRepository: _userDataRepository);

                return Center(child: CircularProgressIndicator());
              });

//              ? PatientShareAccountScreen()
//              : RelativeShareAccountScreen();
        }

        return Container();
      },
    );
  }
}
