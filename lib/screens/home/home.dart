import 'package:flutter/material.dart';
import 'package:harmony/models/brew.dart';
import 'package:harmony/screens/home/settings_form.dart';
import 'package:harmony/services/auth_service.dart';
import 'package:harmony/services/database.dart';
import 'package:provider/provider.dart';

import 'brew_list.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();

    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context, builder: (context) => SettingsForm());
    }

    return StreamProvider<List<Brew>>.value(
      value: DatabaseService().brews,
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('Brew Crew'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
                onPressed: () async {
                  await _auth.signOut();
                },
                icon: Icon(Icons.person),
                label: Text('Logout')),
            FlatButton.icon(
                onPressed: () => _showSettingsPanel(),
                icon: Icon(Icons.settings),
                label: Text('Settings'
                    ''))
          ],
        ),
        body: BrewList(),
      ),
    );
  }
}
