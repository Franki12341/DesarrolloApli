class Usuario {
  final String uid;
  final String email;
  final String nombre;
  final String dni;
  final String telefono;
  final DateTime fechaRegistro;
  final String rol; // ✅ NUEVO: 'admin' o 'cliente'

  Usuario({
    required this.uid,
    required this.email,
    required this.nombre,
    required this.dni,
    required this.telefono,
    DateTime? fechaRegistro,
    this.rol = 'cliente', // ✅ Por defecto es 'cliente'
  }) : fechaRegistro = fechaRegistro ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'nombre': nombre,
      'dni': dni,
      'telefono': telefono,
      'fechaRegistro': fechaRegistro.toIso8601String(),
      'rol': rol, // ✅ NUEVO
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      nombre: map['nombre'] ?? '',
      dni: map['dni'] ?? '',
      telefono: map['telefono'] ?? '',
      fechaRegistro: map['fechaRegistro'] != null
          ? DateTime.parse(map['fechaRegistro'])
          : DateTime.now(),
      rol: map['rol'] ?? 'cliente', // ✅ NUEVO
    );
  }

  // ✅ NUEVO: Método para verificar si es admin
  bool get esAdmin => rol == 'admin';
}
