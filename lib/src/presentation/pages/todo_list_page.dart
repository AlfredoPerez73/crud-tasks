import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasks/src/data/model/todo_model.dart';
import 'package:tasks/src/domain/controller/todo_controller.dart';
import 'package:tasks/src/presentation/pages/todo_create_page.dart';
import 'package:tasks/src/presentation/pages/todo_update_page.dart';

class TodoListPage extends StatelessWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TodoController controller = Get.put(TodoController());

    // Refined Professional Color Palette
    final Color primaryDarkBlue = Color(0xFF0D47A1);
    final Color accentBlue = Color(0xFF1565C0);
    final Color backgroundGrey = Color(0xFFF4F6F9);
    final Color softShadowBlue = Color(0xFFE3F2FD);

    // Enhanced Typography
    final TextTheme textTheme = Theme.of(context).textTheme.copyWith(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: primaryDarkBlue,
        letterSpacing: 0.5,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.grey[800]),
    );

    return Scaffold(
      backgroundColor: backgroundGrey,
      appBar: AppBar(
        elevation: 4,
        title: Text(
          'Mis Tareas',
          style: textTheme.headlineLarge?.copyWith(color: Colors.white),
        ),
        backgroundColor: primaryDarkBlue,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white, size: 28),
            onPressed: controller.fetchTodos,
            tooltip: 'Actualizar tareas',
          ),
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.white, size: 28),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Filtros próximamente',
                    style: textTheme.titleMedium,
                  ),
                  backgroundColor: accentBlue,
                ),
              );
            },
            tooltip: 'Filtrar tareas',
          ),
        ],
      ),
      body: RefreshIndicator(
        color: primaryDarkBlue,
        onRefresh: () async => controller.fetchTodos(),
        child: Obx(() {
          // Loading State
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                color: primaryDarkBlue,
                strokeWidth: 5,
              ),
            );
          }

          // Error State
          if (controller.error.isNotEmpty) {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(32),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: softShadowBlue,
                      spreadRadius: 5,
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red[600],
                      size: 120,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Error de Carga',
                      style: textTheme.headlineLarge?.copyWith(
                        color: primaryDarkBlue,
                        fontSize: 26,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      controller.error.value,
                      style: textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: controller.fetchTodos,
                      icon: const Icon(Icons.refresh, size: 24),
                      label: Text('Reintentar', style: textTheme.titleMedium),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryDarkBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 6,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Empty State
          if (controller.todos.isEmpty) {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(40),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: softShadowBlue,
                      spreadRadius: 5,
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.checklist_rounded,
                      color: primaryDarkBlue.withOpacity(0.7),
                      size: 120,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'No hay tareas',
                      style: textTheme.headlineLarge?.copyWith(
                        color: primaryDarkBlue,
                        fontSize: 26,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Comienza agregando una nueva tarea',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[700],
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          // Todo List
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            itemCount: controller.todos.length,
            itemBuilder: (context, index) {
              final todo = controller.todos[index];
              return TodoTile(
                todo: todo,
                onTap: () => Get.to(() => UpdateTodoPage(todo: todo)),
              );
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const CreateTodoPage()),
        backgroundColor: primaryDarkBlue,
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        icon: const Icon(Icons.add, size: 32, color: Colors.white),
        label: Text(
          'Nueva Tarea',
          style: textTheme.titleMedium?.copyWith(fontSize: 18),
        ),
      ),
    );
  }
}

// TodoTile widget
class TodoTile extends StatelessWidget {
  final Todo todo;
  final VoidCallback onTap;

  const TodoTile({Key? key, required this.todo, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Powerful color palette
    final Color primaryBlue = Color(0xFF1A4B84);
    final Color accentBlue = Color(0xFF2C6FBD);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
        border: Border.all(color: primaryBlue.withOpacity(0.3), width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Status Indicator
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryBlue,
                  ),
                ),
                const SizedBox(width: 16),

                // Todo Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todo.nombre,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: primaryBlue,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        todo.detalle ?? 'Sin descripción',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          fontStyle:
                              todo.detalle == null
                                  ? FontStyle.italic
                                  : FontStyle.normal,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
