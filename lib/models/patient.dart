import 'dart:html';

import 'package:harmony/models/relative.dart';
import 'package:harmony/models/todo_list.dart';
import 'package:harmony/models/user.dart';

class Patient extends User {
  final List<Relative> _relatives;
  final List<TodoList> _todoList;
  final Location _location;

  Patient(this._relatives, this._todoList, this._location) : super();
}
