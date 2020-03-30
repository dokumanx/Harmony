import 'package:flutter/material.dart';
import 'package:harmony/models/brew.dart';
import 'package:provider/provider.dart';

import 'brew_tile.dart';

class BrewList extends StatefulWidget {
  @override
  _BrewListState createState() => _BrewListState();
}

class _BrewListState extends State<BrewList> {
  @override
  Widget build(BuildContext context) {
    final List<Brew> brews = Provider.of<List<Brew>>(context) ?? [];

    return ListView.builder(
        itemCount: brews.length ?? 0,
        itemBuilder: (context, index) => BrewTile(brew: brews[index]));
  }
}
