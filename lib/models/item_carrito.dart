import 'terno.dart';

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
    return ItemCarrito(
      terno: Terno.fromMap(map['terno']),
      cantidad: map['cantidad'] ?? 1,
      fechaAgregado: DateTime.parse(map['fechaAgregado']),
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
