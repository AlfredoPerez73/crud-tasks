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

    // Show Filter Bottom Sheet
    void _showFilterBottomSheet(BuildContext context) {
      final TextEditingController nameController = TextEditingController(
        text: controller.nameFilter.value,
      );

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.5,
              maxChildSize: 0.9,
              builder: (_, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primaryDarkBlue.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 20,
                        offset: const Offset(0, -8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Drag Handle
                      Container(
                        width: 50,
                        height: 6,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Filtrar Tareas',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: primaryDarkBlue,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),

                            // Name Filter TextField
                            TextField(
                              controller: nameController,
                              onChanged: (value) {
                                // Real-time name filtering
                                controller.updateNameFilter(value);
                              },
                              decoration: InputDecoration(
                                labelText: 'Nombre de la tarea',
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: primaryDarkBlue,
                                ),
                                suffixIcon:
                                    nameController.text.isNotEmpty
                                        ? IconButton(
                                          icon: Icon(
                                            Icons.clear,
                                            color: primaryDarkBlue,
                                          ),
                                          onPressed: () {
                                            nameController.clear();
                                            controller.updateNameFilter('');
                                          },
                                        )
                                        : null,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: primaryDarkBlue,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: primaryDarkBlue,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Status Filter Chips
                            Text(
                              'Estado',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primaryDarkBlue,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children:
                                  [
                                    'Pendiente',
                                    'En Progreso',
                                    'Completada',
                                  ].map((status) {
                                    return Obx(() {
                                      bool isSelected =
                                          controller.selectedStatus.value ==
                                          status;
                                      return ChoiceChip(
                                        label: Text(
                                          status,
                                          style: TextStyle(
                                            color:
                                                isSelected
                                                    ? Colors.white
                                                    : primaryDarkBlue,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        selected: isSelected,
                                        selectedColor: primaryDarkBlue,
                                        backgroundColor: Colors.white,
                                        side: BorderSide(
                                          color: primaryDarkBlue,
                                        ),
                                        onSelected: (bool selected) {
                                          // Real-time status filtering
                                          controller.updateStatusFilter(
                                            selected ? status : null,
                                          );
                                        },
                                      );
                                    });
                                  }).toList(),
                            ),

                            const SizedBox(height: 24),

                            // Filter Summary
                            Obx(() {
                              final filteredCount =
                                  controller.filteredTodos.length;
                              final totalCount = controller.todos.length;

                              return Text(
                                'Mostrando $filteredCount de $totalCount tareas',
                                style: TextStyle(
                                  color: primaryDarkBlue.withOpacity(0.7),
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              );
                            }),

                            const SizedBox(height: 16),

                            // Reset Button
                            ElevatedButton(
                              onPressed: () {
                                nameController.clear();
                                controller.resetFilters();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryDarkBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              child: const Text('Restablecer Filtros'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: backgroundGrey,
      appBar: AppBar(
        title: Text(
          'Mis Tareas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryDarkBlue,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.white),
            onPressed: () => _showFilterBottomSheet(context),
            tooltip: 'Filtrar tareas',
          ),
        ],
      ),
      body: Obx(() {
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

        // Show todo list
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.filteredTodos.length,
          itemBuilder: (context, index) {
            final todo = controller.filteredTodos[index];
            return TodoTile(
              todo: todo,
              onTap: () => Get.to(() => UpdateTodoPage(todo: todo)),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const CreateTodoPage()),
        backgroundColor: primaryDarkBlue,
        icon: Icon(Icons.add, color: Colors.white),
        label: Text('Nueva Tarea', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

// TodoTile widget remains the same as in the previous implementation
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
