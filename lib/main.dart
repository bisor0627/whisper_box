import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper_box/todo.dart';
import 'package:whisper_box/todo_provider.dart';

/// NotifierProvider: TodoList 전체
final todoListProvider = NotifierProvider<TodoList, List<Todo>>(TodoList.new);

/// Todo 필터링을 위한 enum
enum TodoListFilter { all, active, completed }

/// 현재 필터 상태를 보관하는 StateProvider
final todoListFilterProvider =
    StateProvider<TodoListFilter>((ref) => TodoListFilter.all);

/// 완료되지 않은 Todo 개수를 계산
final uncompletedTodosCountProvider = Provider<int>((ref) {
  final list = ref.watch(todoListProvider);
  return list.where((todo) => todo.completed == false).length;
});

/// 필터링된 Todo 리스트
final filteredTodosProvider = Provider<List<Todo>>((ref) {
  final filter = ref.watch(todoListFilterProvider);
  final list = ref.watch(todoListProvider);

  if (filter == TodoListFilter.completed) {
    return list.where((state) => state.completed == true).toList();
  } else if (filter == TodoListFilter.active) {
    return list.where((state) => state.completed == false).toList();
  } else {
    return list;
  }
});

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

/// 전체 Todo 리스트를 보여주는 화면
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late final TextEditingController _newTodoController;

  @override
  void initState() {
    super.initState();
    _newTodoController = TextEditingController();
  }

  @override
  void dispose() {
    _newTodoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todos = ref.watch(filteredTodosProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          children: [
            const AppTitle(),
            TextField(
              controller: _newTodoController,
              decoration:
                  const InputDecoration(labelText: 'What needs to be done?'),
              onSubmitted: (value) {
                ref.read(todoListProvider.notifier).add('description');
                _newTodoController.clear();
              },
            ),
            const SizedBox(height: 42),
            const Toolbar(),
            if (todos.isNotEmpty) const Divider(height: 0),
            for (int i = 0; i < todos.length; i++) ...[
              if (i > 0) const Divider(height: 0),
              Dismissible(
                key: ValueKey(todos[i].id),
                onDismissed: (_) {
                  ref.read(todoListProvider.notifier).remove(todos[i]);
                },
                child: TodoItem(todo: todos[i]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 상단 "todos" 타이틀 위젯
class AppTitle extends StatelessWidget {
  const AppTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'todos',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color.fromARGB(38, 47, 47, 247),
        fontSize: 100,
        fontWeight: FontWeight.w100,
        fontFamily: 'Helvetica Neue',
      ),
    );
  }
}

/// 상단 필터 선택 및 남은 Todo 개수를 보여주는 위젯
class Toolbar extends ConsumerWidget {
  const Toolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(todoListFilterProvider);
    final uncompletedCount = ref.watch(uncompletedTodosCountProvider);

    Color? textColorFor(TodoListFilter value) {
      return filter == value ? Colors.blue : Colors.black;
    }

    return Material(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Text('$uncompletedCount items left',
                  overflow: TextOverflow.ellipsis)),
          TextButton(
            onPressed: () {
              ref
                  .read(todoListFilterProvider.notifier)
                  .update((state) => TodoListFilter.all);
            },
            style: ButtonStyle(
              visualDensity: VisualDensity.compact,
              foregroundColor:
                  MaterialStatePropertyAll(textColorFor(TodoListFilter.all)),
            ),
            child: const Text('All'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(todoListFilterProvider.notifier)
                  .update((state) => TodoListFilter.active);
            },
            style: ButtonStyle(
              visualDensity: VisualDensity.compact,
              foregroundColor:
                  MaterialStatePropertyAll(textColorFor(TodoListFilter.active)),
            ),
            child: const Text('Active'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(todoListFilterProvider.notifier)
                  .update((state) => TodoListFilter.completed);
            },
            style: ButtonStyle(
              visualDensity: VisualDensity.compact,
              foregroundColor: MaterialStatePropertyAll(
                  textColorFor(TodoListFilter.completed)),
            ),
            child: const Text('Completed'),
          ),
        ],
      ),
    );
  }
}

/// 개별 Todo 항목을 표시하는 위젯
class TodoItem extends ConsumerStatefulWidget {
  const TodoItem({required this.todo, super.key});
  final Todo todo;

  @override
  ConsumerState<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends ConsumerState<TodoItem> {
  late final FocusNode _itemFocusNode;
  late final FocusNode _textFieldFocusNode;
  late final TextEditingController _textEditingController;

  bool get _isFocused => _itemFocusNode.hasFocus;

  @override
  void initState() {
    super.initState();
    _itemFocusNode = FocusNode();
    _textFieldFocusNode = FocusNode();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _itemFocusNode.dispose();
    _textFieldFocusNode.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  void _onFocusChange(Todo todo, bool focused) {
    if (!focused) {
      ref
          .read(todoListProvider.notifier)
          .edit(id: todo.id, description: _textEditingController.value.text);
    } else {
      _textEditingController.text = todo.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    final todo = widget.todo;

    return Material(
      color: Colors.white,
      elevation: 6,
      child: Focus(
        focusNode: _itemFocusNode,
        onFocusChange: ((focused) => {_onFocusChange(todo, focused)}),
        child: ListTile(
          onTap: () {
            // 항목 탭 시 편집 모드 돌입
            _itemFocusNode.requestFocus();
            _textFieldFocusNode.requestFocus();
          },
          leading: Checkbox(
            value: todo.completed,
            onChanged: (value) {
              ref.read(todoListProvider.notifier).toggle(todo.id);
            },
          ),
          title: _isFocused
              ? TextField(
                  autofocus: true,
                  focusNode: _textFieldFocusNode,
                  controller: _textEditingController)
              : Text(todo.description),
        ),
      ),
    );
  }
}
