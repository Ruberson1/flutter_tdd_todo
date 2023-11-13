import 'package:flutter_tdd_todo/src/cubits/board_cubit.dart';
import 'package:flutter_tdd_todo/src/models/task.dart';
import 'package:flutter_tdd_todo/src/repositories/board_repository.dart';
import 'package:flutter_tdd_todo/src/states/board_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class BoardRepositoryMock extends Mock implements BoardRepository {}

void main() {
  late BoardRepositoryMock repository = BoardRepositoryMock();
  late BoardCubit cubit;
  setUp(() {
    repository = BoardRepositoryMock();
    cubit = BoardCubit(repository);
  });

  group('fetch tasks |', () {
    test('deve pegar todas as tasks', () async {
      when(() => repository.fetch()).thenAnswer(
        (_) async => [
          const Task(id: 1, description: '', check: false),
        ],
      );

      expect(
        cubit.stream,
        emitsInOrder([
          isA<LoadingBoardState>(),
          isA<GettedTaskBoardState>(),
        ]),
      );

      await cubit.fetchTasks();
    });

    test('should return error state on fail', () async {
      when(() => repository.fetch()).thenThrow(Exception('Error'));
      expect(
        cubit.stream,
        emitsInOrder([
          isA<LoadingBoardState>(),
          isA<FailureBoardState>(),
        ]),
      );

      await cubit.fetchTasks();
    });
  });

  group('add task |', () {
    test('should create a new task', () async {
      when(() => repository.update(any())).thenAnswer((_) async => []);
      expect(
        cubit.stream,
        emitsInOrder([
          isA<GettedTaskBoardState>(),
        ]),
      );
      const task = Task(id: 1, description: 'description');
      await cubit.addTask(task);
      final state = cubit.state as GettedTaskBoardState;
      expect(state.tasks.length, 1);
      expect(state.tasks, [task]);
    });

    test('should return error state on fail create a new task', () async {
      when(() => repository.update(any())).thenThrow(Exception('Error'));
      expect(
        cubit.stream,
        emitsInOrder([
          isA<FailureBoardState>(),
        ]),
      );
      const task = Task(id: 1, description: 'description');
      await cubit.addTask(task);
    });
  });

  group('remove task |', () {
    test('should remove a task', () async {
      when(() => repository.update(any())).thenAnswer((_) async => []);
      const task = Task(id: 1, description: '');
      cubit.addTasks([task]);
      expect((cubit.state as GettedTaskBoardState).tasks.length, 1);

      expect(
        cubit.stream,
        emitsInOrder([
          isA<GettedTaskBoardState>(),
        ]),
      );

      await cubit.removeTask(task);
      final state = cubit.state as GettedTaskBoardState;
      expect(state.tasks.length, 0);
    });

    test('should return error state on fail create a new task', () async {
      when(() => repository.update(any())).thenThrow(Exception('Error'));
      const task = Task(id: 1, description: 'description');
      cubit.addTasks([task]);
      expect(
        cubit.stream,
        emitsInOrder([
          isA<FailureBoardState>(),
        ]),
      );

      await cubit.removeTask(task);
    });
  });

  group('check task |', () {
    test('should check a task', () async {
      when(() => repository.update(any())).thenAnswer((_) async => []);
      const task = Task(id: 1, description: '');
      cubit.addTasks([task]);
      expect((cubit.state as GettedTaskBoardState).tasks.length, 1);
      expect((cubit.state as GettedTaskBoardState).tasks.first.check, false);

      expect(
        cubit.stream,
        emitsInOrder([
          isA<GettedTaskBoardState>(),
        ]),
      );

      await cubit.checkTask(task);
      final state = cubit.state as GettedTaskBoardState;
      expect(state.tasks.length, 1);
      expect(state.tasks.first.check, true);
    });

    test('should return error state on fail check a task', () async {
      when(() => repository.update(any())).thenThrow(Exception('Error'));
      const task = Task(id: 1, description: 'description');
      cubit.addTasks([task]);
      expect(
        cubit.stream,
        emitsInOrder([
          isA<FailureBoardState>(),
        ]),
      );

      await cubit.checkTask(task);
    });
  });
}
