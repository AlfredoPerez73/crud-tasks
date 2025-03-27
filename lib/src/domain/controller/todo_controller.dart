import 'package:get/get.dart';
import 'package:tasks/src/data/repositories/todo_repository.dart';

import '../../data/model/todo_model copy.dart';
import '../../data/model/todo_model.dart';

class TodoController extends GetxController {
  final TodoRepository repository = TodoRepository();

  final RxList todos = [].obs;
  final RxBool isLoading = false.obs;
  final RxString error = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchTodos();
  }

  // Fetch all todos
  Future<void> fetchTodos() async {
    try {
      isLoading.value = true;
      error.value = "";

      final fetchedTodos = await repository.getTodos();
      todos.assignAll(fetchedTodos);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Create a new todo
  Future<void> createTodo(TodoSinId todo) async {
    try {
      isLoading.value = true;
      error.value = "";

      final createdTodo = await repository.createTodo(todo);
      todos.insert(0, createdTodo); // Add to the beginning of the list
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Update an existing todo
  Future<void> updateTodo(Todo todo) async {
    try {
      // Validaciones
      if (todo.nombre.trim().isEmpty) {
        error.value = "El título no puede estar vacío";
        return;
      }

      isLoading.value = true;
      error.value = "";

      final updatedTodo = await repository.updateTodo(todo);

      // Actualizar en la lista local
      final index = todos.indexWhere((t) => t.id == todo.id);
      if (index != -1) {
        todos[index] = updatedTodo;
      }
    } catch (e) {
      // Mensaje de error más detallado
      error.value = "No se pudo actualizar la tarea. Detalles: $e";
      print('Error de actualización: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Delete a todo
  Future<void> deleteTodo(int id) async {
    try {
      isLoading.value = true;
      error.value = "";

      await repository.deleteTodo(id);

      // Remove the todo from the list
      todos.removeWhere((t) => t.id == id);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle completed status (modify as needed based on your Todo model)
  void toggleCompleted(int index) {
    final todo = todos[index];
    final updatedTodo = Todo(
      nombre: todo.nombre,
      detalle: todo.detalle,
      estado: todo.estado,
      id: todo.id,
    );

    updateTodo(updatedTodo);
  }
}
