import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tasks/src/data/model/todo_model.dart';
import 'package:tasks/src/data/model/todo_model copy.dart';

class TodoRepository {
  final String _baseUrl = 'https://nk0blh78-8000.use2.devtunnels.ms';

  Future<List<Todo>> getTodos() async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl/tareas/'),
            // Añade un timeout para manejar conexiones lentas
            headers: {'Connection': 'keep-alive'},
          )
          .timeout(
            Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Tiempo de conexión agotado');
            },
          );

      // Manejo detallado de diferentes códigos de estado
      switch (response.statusCode) {
        case 200:
          final List jsonList = json.decode(response.body);
          return jsonList.map((json) => Todo.alfredo(json)).toList();
        case 404:
          throw Exception('Endpoint no encontrado');
        case 500:
          throw Exception('Error interno del servidor');
        default:
          throw Exception('Error desconocido: ${response.statusCode}');
      }
    } catch (e) {
      // Imprime el error para depuración
      print('Error de conexión: $e');

      // Lanza un error personalizado
      throw Exception(
        'No se pudieron cargar las tareas. Verifica tu conexión.',
      );
    }
  }

  // Create a new todo
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
      // Imprimir detalles para depuración
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

  // Delete a todo
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
