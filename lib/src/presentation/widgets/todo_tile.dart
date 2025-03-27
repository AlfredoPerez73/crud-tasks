import 'package:flutter/material.dart';
import '../../data/model/todo_model.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onTap;

  const TodoTile({
    Key? key,
    required this.todo,
    required this.onToggle,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
        leading: Checkbox(
          value: todo.detalle == 'true', // Assuming body is used as a completed flag
          onChanged: (_) => onToggle(),
        ),
        title: Text(
          todo.nombre,
          style: TextStyle(
            decoration: todo.detalle == 'true'
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}