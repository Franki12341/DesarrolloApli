import 'package:cloud_firestore/cloud_firestore.dart';

class Boleta {
  final String? id;
  final String nombreCliente;
  final String dniCliente;
  final String telefonoCliente;
  final String ternoDescripcion;
  final String talla;
  final DateTime fechaAlquiler;
  final DateTime fechaDevolucion;
  final double precioTotal;
  final double adelanto;
  final String? observaciones;
  final List<String> imagenes; // ✨ NUEVO: Lista de URLs de imágenes
  final DateTime createdAt;

  Boleta({
    this.id,
    required this.nombreCliente,
    required this.dniCliente,
    required this.telefonoCliente,
    required this.ternoDescripcion,
    required this.talla,
    required this.fechaAlquiler,
    required this.fechaDevolucion,
    required this.precioTotal,
    required this.adelanto,
    this.observaciones,
    this.imagenes = const [], // ✨ NUEVO: Por defecto lista vacía
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'nombreCliente': nombreCliente,
      'dniCliente': dniCliente,
      'telefonoCliente': telefonoCliente,
      'ternoDescripcion': ternoDescripcion,
      'talla': talla,
      'fechaAlquiler': Timestamp.fromDate(fechaAlquiler),
      'fechaDevolucion': Timestamp.fromDate(fechaDevolucion),
      'precioTotal': precioTotal,
      'adelanto': adelanto,
      'observaciones': observaciones,
      'imagenes': imagenes, // ✨ NUEVO
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Boleta.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Boleta(
      id: doc.id,
      nombreCliente: data['nombreCliente'] ?? '',
      dniCliente: data['dniCliente'] ?? '',
      telefonoCliente: data['telefonoCliente'] ?? '',
      ternoDescripcion: data['ternoDescripcion'] ?? '',
      talla: data['talla'] ?? '',
      fechaAlquiler: (data['fechaAlquiler'] as Timestamp).toDate(),
      fechaDevolucion: (data['fechaDevolucion'] as Timestamp).toDate(),
      precioTotal: (data['precioTotal'] ?? 0).toDouble(),
      adelanto: (data['adelanto'] ?? 0).toDouble(),
      observaciones: data['observaciones'],
      imagenes: List<String>.from(data['imagenes'] ?? []), // ✨ NUEVO
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  double get saldo => precioTotal - adelanto;
  int get diasAlquiler => fechaDevolucion.difference(fechaAlquiler).inDays + 1;
}
