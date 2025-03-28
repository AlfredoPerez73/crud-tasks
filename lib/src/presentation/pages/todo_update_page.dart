import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasks/src/data/model/todo_model.dart';
import 'package:tasks/src/domain/controller/todo_controller.dart';

class UpdateTodoPage extends StatefulWidget {
  final Todo todo;
  const UpdateTodoPage({Key? key, required this.todo}) : super(key: key);

  @override
  _UpdateTodoPageState createState() => _UpdateTodoPageState();
}

class _UpdateTodoPageState extends State<UpdateTodoPage> {
  final TodoController _todoController = Get.find<TodoController>();

  late TextEditingController _titleController;
  late TextEditingController _bodyController;
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _bodyFocusNode = FocusNode();

  // Enhanced color palette
  static const Color _primaryColor = Color(0xFF1A365D);
  static const Color _accentColor = Color(0xFF2C5282);
  static const Color _backgroundLight = Color(0xFFF7FAFC);
  static const Color _textColor = Color(0xFF0F172A);
  static const Color _shadowColor = Color(0xFF64748B);
  static const Color _deleteColor = Color(0xFFE11D48);
  static const Color _successColor = Color(0xFF48BB78);
  static const Color _progressColor = Color(0xFF4299E1);
  static const Color _pendingColor = Color(0xFFED8936);

  // Status dropdown controller
  late String _selectedStatus;
  final List<String> _statusOptions = [
    'pendiente',
    'en progreso',
    'completada',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo.nombre);
    _bodyController = TextEditingController(text: widget.todo.detalle);
    _selectedStatus = widget.todo.estado ?? 'pendiente';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: _backgroundLight,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildEnhancedAppBar(),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              sliver: SliverToBoxAdapter(child: _buildProfessionalUpdateForm()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedAppBar() {
    return SliverAppBar(
      expandedHeight: 140,
      floating: false,
      pinned: true,
      backgroundColor: _primaryColor,
      actions: [Padding(padding: const EdgeInsets.only(right: 8.0))],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Update Task',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.black26,
                offset: Offset(1.0, 1.0),
              ),
            ],
          ),
        ),
        centerTitle: false,
        titlePadding: EdgeInsets.only(left: 16, bottom: 16),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      elevation: 15,
      shadowColor: _shadowColor.withOpacity(0.5),
    );
  }

  Widget _buildProfessionalUpdateForm() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _shadowColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildFormSectionTitle('Task Title'),
          const SizedBox(height: 16),
          _buildTitleField(),
          const SizedBox(height: 24),
          _buildFormSectionTitle('Task Description'),
          const SizedBox(height: 16),
          _buildBodyField(),
          const SizedBox(height: 24),
          _buildFormSectionTitle('Task Status'),
          const SizedBox(height: 16),
          _buildStatusDropdown(),
          const SizedBox(height: 40),
          _buildUpdateButton(),
        ],
      ),
    );
  }

  // Add status dropdown method similar to CreateTodoPage
  Widget _buildStatusDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _shadowColor.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedStatus,
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: const EdgeInsets.only(left: 8, right: 12),
            child: Icon(
              _getStatusIcon(_selectedStatus),
              color: _getStatusColor(_selectedStatus),
              size: 24,
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
        ),
        items:
            _statusOptions.map((status) {
              return DropdownMenuItem<String>(
                value: status,
                child: Row(
                  children: [
                    Icon(
                      _getStatusIcon(status),
                      color: _getStatusColor(status),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      status.capitalize ?? status,
                      style: TextStyle(
                        color: _getStatusColor(status),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
        selectedItemBuilder: (BuildContext context) {
          return _statusOptions.map<Widget>((String status) {
            return Row(
              children: [
                Text(
                  status.capitalize ?? status,
                  style: TextStyle(
                    color: _getStatusColor(status),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            );
          }).toList();
        },
        onChanged: (value) {
          setState(() {
            _selectedStatus = value!;
          });
        },
        dropdownColor: Colors.white,
        icon: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Icon(
            Icons.arrow_drop_down_rounded,
            color: _accentColor,
            size: 30,
          ),
        ),
        isExpanded: true,
      ),
    );
  }

  // Add methods to get status icon and color
  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pendiente':
        return Icons.pending_outlined;
      case 'en progreso':
        return Icons.priority_high_outlined;
      case 'completada':
        return Icons.check_circle_outline;
      default:
        return Icons.info_outline;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pendiente':
        return _pendingColor;
      case 'en progreso':
        return _progressColor;
      case 'completada':
        return _successColor;
      default:
        return _textColor;
    }
  }

  // Update the _updateTodo method to include the selected status
  void _updateTodo() {
    final nombre = _titleController.text.trim();
    final detalle = _bodyController.text.trim();

    if (nombre.isEmpty || detalle.isEmpty) {
      _showValidationSnackbar('Please fill in all fields');
      return;
    }

    final updatedTodo = Todo(
      id: widget.todo.id,
      nombre: nombre,
      detalle: detalle,
      estado: _selectedStatus,
    );

    _todoController
        .updateTodo(updatedTodo)
        .then((_) {
          Get.back();
          _showSuccessSnackbar('Task updated successfully');
        })
        .catchError((error) {
          _showErrorSnackbar(error.toString());
        });
  }

  Widget _buildFormSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: _primaryColor,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildTitleField() {
    return TextField(
      controller: _titleController,
      focusNode: _titleFocusNode,
      style: TextStyle(color: _textColor, fontSize: 16),
      decoration: _professionalInputDecoration(
        labelText: 'Enter task title',
        prefixIcon: Icons.text_fields_rounded,
      ),
      textInputAction: TextInputAction.next,
      onSubmitted: (_) {
        FocusScope.of(context).requestFocus(_bodyFocusNode);
      },
      cursorColor: _primaryColor,
    );
  }

  Widget _buildBodyField() {
    return TextField(
      controller: _bodyController,
      focusNode: _bodyFocusNode,
      maxLines: 4,
      style: TextStyle(color: _textColor, fontSize: 16),
      decoration: _professionalInputDecoration(
        labelText: 'Describe your task in detail',
        prefixIcon: Icons.description_rounded,
      ),
      cursorColor: _primaryColor,
    );
  }

  InputDecoration _professionalInputDecoration({
    required String labelText,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: _shadowColor, fontSize: 15),
      prefixIcon: Icon(prefixIcon, color: _accentColor),
      filled: true,
      fillColor: _backgroundLight,
      enabledBorder: _enhancedOutlineBorder(),
      focusedBorder: _enhancedOutlineBorder(isFocused: true),
      errorBorder: _enhancedOutlineBorder(isError: true),
      focusedErrorBorder: _enhancedOutlineBorder(isError: true),
    );
  }

  OutlineInputBorder _enhancedOutlineBorder({
    bool isFocused = false,
    bool isError = false,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color:
            isError
                ? Colors.red.shade700
                : isFocused
                ? _primaryColor
                : _shadowColor.withOpacity(0.3),
        width: isFocused ? 2 : 1,
      ),
    );
  }

  Widget _buildUpdateButton() {
    return Obx(() {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutQuart,
        decoration: BoxDecoration(
          boxShadow:
              _todoController.isLoading.value
                  ? []
                  : [
                    BoxShadow(
                      color: _primaryColor.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 10),
                    ),
                  ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          onPressed: _todoController.isLoading.value ? null : _updateTodo,
          child:
              _todoController.isLoading.value
                  ? const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  )
                  : Text(
                    'Update Task',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
        ),
      );
    });
  }

  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      margin: const EdgeInsets.all(15),
      borderRadius: 12,
      duration: Duration(seconds: 3),
    );
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      icon: const Icon(Icons.error, color: Colors.white),
      margin: const EdgeInsets.all(15),
      borderRadius: 12,
      duration: Duration(seconds: 3),
    );
  }

  void _showValidationSnackbar(String message) {
    Get.snackbar(
      'Validation',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: _accentColor,
      colorText: Colors.white,
      icon: const Icon(Icons.warning_rounded, color: Colors.white),
      margin: const EdgeInsets.all(15),
      borderRadius: 12,
      duration: Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _titleFocusNode.dispose();
    _bodyFocusNode.dispose();
    super.dispose();
  }
}
