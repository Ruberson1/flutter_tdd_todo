import 'package:flutter_tdd_todo/src/models/task.dart';
import 'package:flutter_tdd_todo/src/repositories/board_repository.dart';
import 'package:flutter_tdd_todo/src/repositories/isar/isar_board_repository.dart';
import 'package:flutter_tdd_todo/src/repositories/isar/isar_datasource.dart';
import 'package:flutter_tdd_todo/src/repositories/isar/task_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class IsarDataSourceMock extends Mock implements IsarDatasource {}

void main() {
  late IsarDatasource datasource;
  late BoardRepository repository;

  setUp(() {
    datasource = IsarDataSourceMock();
    repository = IsarBoardRepository(datasource);
  });
  test('fetch data', () async {
    when(() => datasource.getTasks()).thenAnswer((_) async => [
          TaskModel()
            ..id = 1
            ..description = 'teste',
        ]);
    final tasks = await repository.fetch();
    expect(tasks.length, 1);
  });

  test('update task', () async {
    when(() => datasource.deleteAllTasks()).thenAnswer((_) async => []);
    when(() => datasource.putAllTasks(any())).thenAnswer((_) async => []);

    final tasks = await repository.update([
      const Task(id: -1, description: ''),
      const Task(id: 2, description: '')
    ]);
    expect(tasks.length, 2);
  });
}
