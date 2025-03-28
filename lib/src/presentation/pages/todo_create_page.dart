import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasks/src/domain/controller/todo_controller.dart';
import '../../data/model/todo_model copy.dart';

class CreateTodoPage extends StatefulWidget {
  const CreateTodoPage({Key? key}) : super(key: key);

  @override
  _CreateTodoPageState createState() => _CreateTodoPageState();
}

class _CreateTodoPageState extends State<CreateTodoPage> {
  final TodoController _todoController = Get.find<TodoController>();
  final _formKey = GlobalKey<FormState>();

  // Enhanced color palette
  static const Color _primaryColor = Color(0xFF1A365D);
  static const Color _accentColor = Color(0xFF2C5282);
  static const Color _backgroundLight = Color(0xFFF7FAFC);
  static const Color _textColor = Color(0xFF0F172A);
  static const Color _shadowColor = Color(0xFF64748B);
  static const Color _successColor = Color(0xFF48BB78);
  static const Color _progressColor = Color(0xFF4299E1);
  static const Color _pendingColor = Color(0xFFED8936);

  // Controllers for text fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // New status dropdown controller
  String _selectedStatus = 'pendiente';
  final List<String> _statusOptions = [
    'pendiente',
    'en progreso',
    'completada',
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: _backgroundLight,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildProfessionalAppBar(),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              sliver: SliverToBoxAdapter(child: _buildEnhancedTodoForm()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalAppBar() {
    return SliverAppBar(
      expandedHeight: 140,
      floating: false,
      pinned: true,
      backgroundColor: _primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Create New Task',
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

  Widget _buildEnhancedTodoForm() {
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
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildFormSectionTitle('Task Title'),
            const SizedBox(height: 16),
            _buildTitleField(),
            const SizedBox(height: 24),
            _buildFormSectionTitle('Task Description'),
            const SizedBox(height: 16),
            _buildDescriptionField(),
            const SizedBox(height: 24),
            _buildFormSectionTitle('Task Status'),
            const SizedBox(height: 16),
            _buildStatusDropdown(),
            const SizedBox(height: 40),
            _buildCreateButton(),
          ],
        ),
      ),
    );
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
    return TextFormField(
      controller: _titleController,
      style: TextStyle(color: _textColor, fontSize: 16),
      decoration: _professionalInputDecoration(
        labelText: 'Enter task title',
        prefixIcon: Icons.text_fields_rounded,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a task title';
        }
        if (value.trim().length < 3) {
          return 'Title must be at least 3 characters long';
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      cursorColor: _primaryColor,
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 4,
      style: TextStyle(color: _textColor, fontSize: 16),
      decoration: _professionalInputDecoration(
        labelText: 'Describe your task in detail',
        prefixIcon: Icons.description_rounded,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a task description';
        }
        if (value.trim().length < 10) {
          return 'Description must be at least 10 characters long';
        }
        return null;
      },
      cursorColor: _primaryColor,
    );
  }

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

  // Add this method to get icons based on status
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
      errorStyle: TextStyle(color: Colors.red.shade700, fontSize: 12),
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

  Widget _buildCreateButton() {
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
          onPressed: _todoController.isLoading.value ? null : _createTodo,
          child:
              _todoController.isLoading.value
                  ? const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  )
                  : Text(
                    'Create Task',
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

  void _createTodo() {
    if (_formKey.currentState?.validate() ?? false) {
      final newTodo = TodoSinId(
        nombre: _titleController.text.trim(),
        detalle: _descriptionController.text.trim(),
        estado: _selectedStatus,
      );

      _todoController
          .createTodo(newTodo)
          .then((_) {
            Get.back();
            _showSuccessSnackbar();
          })
          .catchError(_showErrorSnackbar);
    }
  }

  void _showSuccessSnackbar() {
    Get.snackbar(
      'Success',
      'Task created successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      margin: const EdgeInsets.all(15),
      borderRadius: 12,
      duration: Duration(seconds: 3),
    );
  }

  void _showErrorSnackbar(error) {
    Get.snackbar(
      'Error',
      error.toString(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      icon: const Icon(Icons.error, color: Colors.white),
      margin: const EdgeInsets.all(15),
      borderRadius: 12,
      duration: Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
