import 'item_carrito.dart';

class Reserva {
  final String id;
  final String clienteNombre;
  final String clienteDNI;
  final String clienteTelefono;
  final List<ItemCarrito> items;
  final DateTime fechaEvento;
  final DateTime fechaReserva;
  final double total;
  final String estado;
  final String? observaciones;

  Reserva({
    required this.id,
    required this.clienteNombre,
    required this.clienteDNI,
    required this.clienteTelefono,
    required this.items,
    required this.fechaEvento,
    DateTime? fechaReserva,
    required this.total,
    this.estado = 'pendiente',
    this.observaciones,
  }) : fechaReserva = fechaReserva ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clienteNombre': clienteNombre,
      'clienteDNI': clienteDNI,
      'clienteTelefono': clienteTelefono,
      'items': items.map((item) => item.toMap()).toList(),
      'fechaEvento': fechaEvento.toIso8601String(),
      'fechaReserva': fechaReserva.toIso8601String(),
      'total': total,
      'estado': estado,
      'observaciones': observaciones,
    };
  }

  factory Reserva.fromMap(Map<String, dynamic> map) {
    return Reserva(
      id: map['id'] ?? '',
      clienteNombre: map['clienteNombre'] ?? '',
      clienteDNI: map['clienteDNI'] ?? '',
      clienteTelefono: map['clienteTelefono'] ?? '',
      items: (map['items'] as List<dynamic>)
          .map((item) => ItemCarrito.fromMap(item as Map<String, dynamic>))
          .toList(),
      fechaEvento: DateTime.parse(map['fechaEvento']),
      fechaReserva: DateTime.parse(map['fechaReserva']),
      total: (map['total'] ?? 0.0).toDouble(),
      estado: map['estado'] ?? 'pendiente',
      observaciones: map['observaciones'],
    );
  }

  Reserva copyWith({
    String? id,
    String? clienteNombre,
    String? clienteDNI,
    String? clienteTelefono,
    List<ItemCarrito>? items,
    DateTime? fechaEvento,
    DateTime? fechaReserva,
    double? total,
    String? estado,
    String? observaciones,
  }) {
    return Reserva(
      id: id ?? this.id,
      clienteNombre: clienteNombre ?? this.clienteNombre,
      clienteDNI: clienteDNI ?? this.clienteDNI,
      clienteTelefono: clienteTelefono ?? this.clienteTelefono,
      items: items ?? this.items,
      fechaEvento: fechaEvento ?? this.fechaEvento,
      fechaReserva: fechaReserva ?? this.fechaReserva,
      total: total ?? this.total,
      estado: estado ?? this.estado,
      observaciones: observaciones ?? this.observaciones,
    );
  }
}
