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

    // Powerful Color Palette
    final Color primaryDarkBlue = Color(0xFF0D47A1);
    final Color accentBlue = Color(0xFF1565C0);
    final Color backgroundGrey = Color(0xFFF4F6F9);
    final Color softShadowBlue = Color(0xFFE3F2FD);

    return Scaffold(
      backgroundColor: backgroundGrey,
      appBar: AppBar(
        title: Text(
          'Mis Tareas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryDarkBlue,
      ),
      body: Column(
        children: [
          // Powerful Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: primaryDarkBlue.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Search Input
                TextField(
                  controller: TextEditingController(
                    text: controller.nameFilter.value,
                  ),
                  onChanged: (value) {
                    controller.updateNameFilter(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Buscar tareas...',
                    prefixIcon: Icon(Icons.search, color: primaryDarkBlue),
                    filled: true,
                    fillColor: backgroundGrey,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: primaryDarkBlue, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Status Filter Chips
                Obx(
                  () => Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children:
                        ['Pendiente', 'En Progreso', 'Completada'].map((
                          status,
                        ) {
                          bool isSelected = controller.selectedStatuses
                              .contains(status);
                          return FilterChip(
                            label: Text(
                              status,
                              style: TextStyle(
                                color:
                                    isSelected ? Colors.white : primaryDarkBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: primaryDarkBlue,
                            backgroundColor: backgroundGrey,
                            side: BorderSide(
                              color: primaryDarkBlue.withOpacity(0.5),
                            ),
                            onSelected: (bool selected) {
                              controller.updateStatusFilter(status);
                            },
                            checkmarkColor: Colors.white,
                          );
                        }).toList(),
                  ),
                ),
                const SizedBox(height: 16),

                // Filter Summary and Reset
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() {
                      final filteredCount = controller.filteredTodos.length;
                      final totalCount = controller.todos.length;
                      return Text(
                        'Mostrando $filteredCount de $totalCount tareas',
                        style: TextStyle(
                          color: primaryDarkBlue.withOpacity(0.7),
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }),
                    TextButton(
                      onPressed: () {
                        controller.resetFilters();
                      },
                      child: Text(
                        'Restablecer',
                        style: TextStyle(
                          color: primaryDarkBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Task List
          Expanded(
            child: Obx(() {
              // Show loading state
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(color: primaryDarkBlue),
                );
              }

              // Show error state
              if (controller.error.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, color: Colors.red, size: 60),
                      SizedBox(height: 16),
                      Text(
                        'Error',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: primaryDarkBlue,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(controller.error.value, textAlign: TextAlign.center),
                    ],
                  ),
                );
              }

              // Show empty state
              if (controller.filteredTodos.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.checklist_rounded,
                        color: primaryDarkBlue.withOpacity(0.7),
                        size: 120,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No hay tareas',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: primaryDarkBlue,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'No se encontraron tareas con los filtros aplicados',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                );
              }

              // Task List
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.filteredTodos.length,
                itemBuilder: (context, index) {
                  final todo = controller.filteredTodos[index];
                  return Dismissible(
                    key: Key(todo.id.toString()),
                    background: _buildDismissibleBackground(),
                    secondaryBackground: _buildDismissibleBackground(),
                    direction: DismissDirection.horizontal,
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirmar Eliminación'),
                            content: Text(
                              '¿Estás seguro de que deseas eliminar la tarea "${todo.nombre}"?',
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed:
                                    () => Navigator.of(context).pop(false),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed:
                                    () => Navigator.of(context).pop(true),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                                child: const Text('Eliminar'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onDismissed: (direction) {
                      controller.deleteTodo(todo.id!);
                    },
                    child: TodoTile(
                      todo: todo,
                      onTap: () => Get.to(() => UpdateTodoPage(todo: todo)),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const CreateTodoPage()),
        backgroundColor: primaryDarkBlue,
        icon: Icon(Icons.add, color: Colors.white),
        label: Text('Nueva Tarea', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  // Dismissible background method
  Widget _buildDismissibleBackground() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: const Icon(Icons.delete, color: Colors.white, size: 30),
    );
  }
}

class TodoTile extends StatelessWidget {
  final Todo todo;
  final VoidCallback onTap;

  const TodoTile({Key? key, required this.todo, required this.onTap})
    : super(key: key);

  // Helper method to get status color and label
  MapEntry<Color, String> _getStatusDetails() {
    switch (todo.estado?.toLowerCase()) {
      case 'completada':
        return MapEntry(Colors.green[700]!, 'Completada');
      case 'en progreso':
        return MapEntry(Colors.orange[700]!, 'En Progreso');
      case 'pendiente':
      default:
        return MapEntry(Colors.blue[700]!, 'Pendiente');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Powerful color palette
    final Color primaryBlue = Color(0xFF1A4B84);
    final Color accentBlue = Color(0xFF2C6FBD);

    // Get status details
    final statusDetails = _getStatusDetails();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              todo.nombre,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: primaryBlue,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Status Chip
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusDetails.key.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: statusDetails.key,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              statusDetails.value,
                              style: TextStyle(
                                color: statusDetails.key,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
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
