import 'package:flutter/material.dart';
import 'package:harmony/screens/home/location_screen.dart';
import 'package:harmony/screens/home/profile_screen.dart';
import 'package:harmony/screens/home/share_account_screen.dart';
import 'package:harmony/screens/home/todo_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedItem = 0;
  static const List<BottomNavigationBarItem> _navigationBarItems = [
    BottomNavigationBarItem(
      title: Text('Todo List'),
      icon: Icon(Icons.bookmark),
    ),
    BottomNavigationBarItem(
      title: Text('Location'),
      icon: Icon(Icons.location_on),
    ),
    BottomNavigationBarItem(
      title: Text('Share'),
      icon: Icon(Icons.folder_shared),
    ),
    BottomNavigationBarItem(
      title: Text('Profile'),
      icon: Icon(Icons.person),
    ),
  ];

  Widget _currentWidget = TodoScreen();

  void _onItemTapped(int index) {
    setState(() {
      _selectedItem = index;
      switch (index) {
        case 0:
          _currentWidget = TodoScreen();
          break;
        case 1:
          _currentWidget = LocationScreen();
          break;
        case 2:
          _currentWidget = ShareAccountScreen();
          break;
        case 3:
          _currentWidget = ProfileScreen();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: _navigationBarItems,
        currentIndex: _selectedItem,
        selectedItemColor: Colors.purple,
        onTap: _onItemTapped,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedFontSize: 12.0,
      ),
      body: _currentWidget,
    );
  }
}
