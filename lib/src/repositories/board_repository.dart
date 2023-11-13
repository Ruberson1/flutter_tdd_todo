import 'package:flutter_tdd_todo/src/models/task.dart';

abstract interface class BoardRepository {
  Future<List<Task>> fetch();

  Future<List<Task>> update(List<Task> tasks);
}
