import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper_box/todo.dart';

class TodoList extends Notifier<List<Todo>> {
  @override
  List<Todo> build() {
    return [
      const Todo(id: 'todo-0', description: 'Buy cookies'),
      const Todo(id: 'todo-1', description: 'Star Riverpod'),
      const Todo(id: 'todo-2', description: 'Have a walk'),
    ];
  }

  void add(String description) {
    final newTodo = Todo(
      id: 'todo-${state.length}', // 간단한 ID 생성 방식
      description: description,
    );
    state = [...state, newTodo];
  }

  void toggle(String id) {
    state = state.map((todo) {
      if (todo.id == id) {
        return todo.copyWith(completed: !todo.completed); // 상태 변경
      }
      return todo;
    }).toList();
  }

  void edit({required String id, required String description}) {
    state = state.map((todo) {
      if (todo.id == id) {
        return todo.copyWith(description: description);
      }
      return todo;
    }).toList();
  }

  void remove(Todo target) {
    state = state.where((todo) => todo.id != target.id).toList();
  }
}
