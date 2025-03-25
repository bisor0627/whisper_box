import 'package:flutter/foundation.dart' show immutable;
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

@immutable
class Todo {
  // TODO: Todo에 필요한 필드를 자유롭게 추가/변경해보세요.
  const Todo({required this.id, required this.description, this.completed = false});

  final String id;
  final String description;
  final bool completed;

  @override
  String toString() => 'Todo(description: $description, completed: $completed)';

  // 복사본을 생성하는 copyWith 메서드 추가 (toggle, edit에서 사용)
  Todo copyWith({String? id, String? description, bool? completed}) {
    return Todo(
      id: id ?? this.id,
      description: description ?? this.description,
      completed: completed ?? this.completed,
    );
  }
}
