import 'terno.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemCarrito {
  final Terno terno;
  final int cantidad;
  final DateTime fechaAgregado;

  ItemCarrito({
    required this.terno,
    this.cantidad = 1,
    DateTime? fechaAgregado,
  }) : fechaAgregado = fechaAgregado ?? DateTime.now();

  double get subtotal => terno.precio * cantidad;

  Map<String, dynamic> toMap() {
    return {
      'terno': terno.toMap(),
      'cantidad': cantidad,
      'fechaAgregado': fechaAgregado.toIso8601String(),
    };
  }

  factory ItemCarrito.fromMap(Map<String, dynamic> map) {
    dynamic fechaVal = map['fechaAgregado'];
    DateTime fechaAgregado;
    if (fechaVal == null) {
      fechaAgregado = DateTime.now();
    } else if (fechaVal is DateTime) {
      fechaAgregado = fechaVal;
    } else if (fechaVal is String) {
      fechaAgregado = DateTime.parse(fechaVal);
    } else if (fechaVal is Timestamp) {
      fechaAgregado = fechaVal.toDate();
    } else {
      fechaAgregado = DateTime.now();
    }

    return ItemCarrito(
      terno: Terno.fromMap(Map<String, dynamic>.from(map['terno'] ?? {})),
      cantidad: (map['cantidad'] ?? 1) as int,
      fechaAgregado: fechaAgregado,
    );
  }

  ItemCarrito copyWith({
    Terno? terno,
    int? cantidad,
    DateTime? fechaAgregado,
  }) {
    return ItemCarrito(
      terno: terno ?? this.terno,
      cantidad: cantidad ?? this.cantidad,
      fechaAgregado: fechaAgregado ?? this.fechaAgregado,
    );
  }
}
