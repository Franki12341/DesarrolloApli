class Terno {
  final String id;
  final String nombre;
  final String talla;
  final double precio;
  final List<String> imagenes;
  final String descripcion;
  final String categoria;
  final String color;
  final bool disponible;

  Terno({
    required this.id,
    required this.nombre,
    required this.talla,
    required this.precio,
    required this.imagenes,
    required this.descripcion,
    required this.categoria,
    required this.color,
    this.disponible = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'talla': talla,
      'precio': precio,
      'imagenes': imagenes,
      'descripcion': descripcion,
      'categoria': categoria,
      'color': color,
      'disponible': disponible,
    };
  }

  factory Terno.fromMap(Map<String, dynamic> map) {
    return Terno(
      id: map['id'] ?? '',
      nombre: map['nombre'] ?? '',
      talla: map['talla'] ?? '',
      precio: (map['precio'] ?? 0.0).toDouble(),
      imagenes: List<String>.from(map['imagenes'] ?? []),
      descripcion: map['descripcion'] ?? '',
      categoria: map['categoria'] ?? '',
      color: map['color'] ?? '',
      disponible: map['disponible'] ?? true,
    );
  }

  Terno copyWith({
    String? id,
    String? nombre,
    String? talla,
    double? precio,
    List<String>? imagenes,
    String? descripcion,
    String? categoria,
    String? color,
    bool? disponible,
  }) {
    return Terno(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      talla: talla ?? this.talla,
      precio: precio ?? this.precio,
      imagenes: imagenes ?? this.imagenes,
      descripcion: descripcion ?? this.descripcion,
      categoria: categoria ?? this.categoria,
      color: color ?? this.color,
      disponible: disponible ?? this.disponible,
    );
  }
}
