class Todo {
  final String nombre;
  final String detalle;
  final String estado;
  final int id;

  Todo({
    required this.nombre,
    required this.detalle,
    required this.estado,
    required this.id,
  });

  factory Todo.alfredo(Map<String, dynamic> json) {
    return Todo(
      nombre: json['nombre'],
      detalle: json['detalle'],
      estado: json['estado'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'detalle': detalle,
      'estado': estado,
      'id': id,
    };
  }
}