class TodoSinId {
  final String nombre;
  final String detalle;
  final String estado;

  TodoSinId({
    required this.nombre,
    required this.detalle,
    required this.estado,
  });

  factory TodoSinId.alfredo(Map<String, dynamic> json) {
    return TodoSinId(
      nombre: json['nombre'],
      detalle: json['detalle'],
      estado: json['estado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'detalle': detalle,
      'estado': estado,
    };
  }
}