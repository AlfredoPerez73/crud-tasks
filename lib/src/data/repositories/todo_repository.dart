import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tasks/src/data/model/todo_model.dart';
import 'package:tasks/src/data/model/todo_model copy.dart';

class TodoRepository {
  final String _baseUrl = 'https://nk0blh78-8000.use2.devtunnels.ms';

  // Lista de tareas estáticas para cuando no hay conexión
  final List<Todo> _staticTodos = [
    Todo.alfredo({
      'id': 1,
      'nombre': 'Tarea de prueba 1',
      'detalle': 'Esta es una tarea de ejemplo cuando no hay conexión',
      'estado': 'pendiente',
    }),
    Todo.alfredo({
      'id': 2,
      'nombre': 'Tarea de prueba 2',
      'detalle': 'Otra tarea de ejemplo sin conexión',
      'estado': 'completado',
    }),
    Todo.alfredo({
      'id': 3,
      'nombre': 'Tarea de prueba 3',
      'detalle': 'Verificando funcionalidad sin internet',
      'estado': 'pendiente',
    }),
  ];

  Future<List<Todo>> getTodos() async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl/tareas/'),
            headers: {'Connection': 'keep-alive'},
          )
          .timeout(
            Duration(seconds: 10),
            onTimeout: () {
              // Si hay timeout, retorna tareas estáticas
              print('Tiempo de conexión agotado. Usando tareas estáticas.');
              return http.Response('[]', 408); // Código 408 para timeout
            },
          );

      switch (response.statusCode) {
        case 200:
          final List jsonList = json.decode(response.body);
          return jsonList.map((json) => Todo.alfredo(json)).toList();
        case 404:
          throw Exception('Endpoint no encontrado');
        case 408: // Timeout
        case 500:
        default:
          // En caso de cualquier error, retorna tareas estáticas
          print('Error de conexión. Usando tareas estáticas.');
          return _staticTodos;
      }
    } catch (e) {
      // Captura cualquier otra excepción de red
      print('Error de conexión: $e');
      return _staticTodos; // Retorna tareas estáticas
    }
  }

  // Los demás métodos permanecen igual
  Future<Todo> createTodo(TodoSinId todo) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/tareas/'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode({
          'nombre': todo.nombre,
          'detalle': todo.detalle,
          'estado': todo.estado,
        }),
      );

      if (response.statusCode == 201) {
        return Todo.alfredo(json.decode(response.body));
      } else {
        throw Exception('Failed to create todo: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating todo: $e');
    }
  }

  Future<Todo> updateTodo(Todo todo) async {
    try {
      print('Actualizando tarea: ${todo.toJson()}');

      final response = await http.put(
        Uri.parse('$_baseUrl//tareas/${todo.id}'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode(todo.toJson()),
      );

      print('Código de estado: ${response.statusCode}');
      print('Cuerpo de respuesta: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Todo.alfredo(json.decode(response.body));
      } else {
        throw Exception('Error al actualizar tarea: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción al actualizar: $e');
      rethrow;
    }
  }

  Future<void> deleteTodo(int id) async {
    try {
      final response = await http.delete(Uri.parse('$_baseUrl/tareas/$id'));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete todo: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting todo: $e');
    }
  }
}
