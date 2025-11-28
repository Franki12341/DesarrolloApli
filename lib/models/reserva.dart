import 'item_carrito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Reserva {
  final String id;
  final String clienteNombre;
  final String clienteDNI;
  final String clienteTelefono;
  final List<ItemCarrito> items;
  final DateTime fechaEvento;
  final DateTime fechaReserva;
  final DateTime fechaCreacion;
  final DateTime fechaDevolucion; // ✅ NUEVO: Fecha límite de devolución
  final double total;
  final String estado;
  final String usuarioId;
  final String? observaciones;
  final double penalidad; // ✅ NUEVO: Monto de penalidad por retraso

  Reserva({
    required this.id,
    required this.clienteNombre,
    required this.clienteDNI,
    required this.clienteTelefono,
    required this.items,
    required this.fechaEvento,
    DateTime? fechaReserva,
    DateTime? fechaCreacion,
    DateTime? fechaDevolucion, // ✅ NUEVO
    required this.total,
    this.estado = 'pendiente',
    required this.usuarioId,
    this.observaciones,
    this.penalidad = 0.0, // ✅ NUEVO: Por defecto 0
  })  : fechaReserva = fechaReserva ?? DateTime.now(),
        fechaCreacion = fechaCreacion ?? DateTime.now(),
        fechaDevolucion = fechaDevolucion ??
            DateTime(
              fechaEvento.year,
              fechaEvento.month,
              fechaEvento.day + 1,
              18, // Hora de cierre: 6:00 PM
              0,
            );

  // ✅ NUEVO: Calcular días de retraso
  int get diasRetraso {
    final ahora = DateTime.now();
    if (ahora.isBefore(fechaDevolucion)) return 0;

    final diferencia = ahora.difference(fechaDevolucion);
    return diferencia.inDays;
  }

  // ✅ NUEVO: Calcular penalidad actual (S/. 50 por día)
  double get penalidadCalculada {
    if (estado == 'completada' || estado == 'devuelta') {
      return penalidad; // Devolver la penalidad guardada
    }
    return diasRetraso * 50.0; // S/. 50 por día de retraso
  }

  // ✅ NUEVO: Verificar si está retrasado
  bool get estaRetrasado {
    return DateTime.now().isAfter(fechaDevolucion) && estado == 'entregada';
  }

  // ✅ NUEVO: Obtener color según urgencia
  String get urgenciaDevolucion {
    if (estado != 'entregada') return 'none';

    final ahora = DateTime.now();
    final diferencia = fechaDevolucion.difference(ahora);

    if (diferencia.isNegative) return 'retrasado'; // Rojo intenso
    if (diferencia.inHours <= 24) return 'hoy'; // Rojo
    if (diferencia.inDays == 1) return 'manana'; // Naranja
    return 'tiempo'; // Verde
  }

  // ✅ NUEVO: Mensaje de urgencia
  String get mensajeUrgencia {
    switch (urgenciaDevolucion) {
      case 'retrasado':
        return '❌ RETRASADO - Penalidad: S/. ${penalidadCalculada.toStringAsFixed(2)}';
      case 'hoy':
        return '🚨 Devolver HOY antes de las 6:00 PM';
      case 'manana':
        return '⚠️ Debes devolver mañana';
      case 'tiempo':
        final dias = fechaDevolucion.difference(DateTime.now()).inDays;
        return 'Quedan $dias días para devolver';
      default:
        return '';
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clienteNombre': clienteNombre,
      'clienteDNI': clienteDNI,
      'clienteTelefono': clienteTelefono,
      'items': items.map((item) => item.toMap()).toList(),
      'fechaEvento': fechaEvento.toIso8601String(),
      'fechaReserva': fechaReserva.toIso8601String(),
      'fechaCreacion': fechaCreacion.toIso8601String(),
      'fechaDevolucion': fechaDevolucion.toIso8601String(), // ✅ NUEVO
      'total': total,
      'estado': estado,
      'observaciones': observaciones,
      'usuarioId': usuarioId,
      'penalidad': penalidad, // ✅ NUEVO
    };
  }

  factory Reserva.fromMap(Map<String, dynamic> map) {
    DateTime parseDate(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is DateTime) return value;
      if (value is String) return DateTime.parse(value);
      if (value is Timestamp) return value.toDate();
      return DateTime.now();
    }

    final itemsList = (map['items'] as List<dynamic>?) ?? [];
    final fechaEvento = parseDate(map['fechaEvento']);

    return Reserva(
      id: map['id'] ?? '',
      clienteNombre: map['clienteNombre'] ?? '',
      clienteDNI: map['clienteDNI'] ?? '',
      clienteTelefono: map['clienteTelefono'] ?? '',
      items: itemsList
          .map((item) => ItemCarrito.fromMap(item as Map<String, dynamic>))
          .toList(),
      fechaEvento: fechaEvento,
      fechaReserva: parseDate(map['fechaReserva']),
      fechaCreacion: parseDate(map['fechaCreacion']),
      fechaDevolucion: map['fechaDevolucion'] != null
          ? parseDate(map['fechaDevolucion'])
          : DateTime(
              fechaEvento.year,
              fechaEvento.month,
              fechaEvento.day + 1,
              18,
              0,
            ), // ✅ Calcular automáticamente si no existe
      total: ((map['total'] ?? 0.0) as num).toDouble(),
      estado: map['estado'] ?? 'pendiente',
      usuarioId: map['usuarioId'] ?? '',
      observaciones: map['observaciones'],
      penalidad: ((map['penalidad'] ?? 0.0) as num).toDouble(), // ✅ NUEVO
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
    DateTime? fechaCreacion,
    DateTime? fechaDevolucion, // ✅ NUEVO
    double? total,
    String? estado,
    String? usuarioId,
    String? observaciones,
    double? penalidad, // ✅ NUEVO
  }) {
    return Reserva(
      id: id ?? this.id,
      clienteNombre: clienteNombre ?? this.clienteNombre,
      clienteDNI: clienteDNI ?? this.clienteDNI,
      clienteTelefono: clienteTelefono ?? this.clienteTelefono,
      items: items ?? this.items,
      fechaEvento: fechaEvento ?? this.fechaEvento,
      fechaReserva: fechaReserva ?? this.fechaReserva,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaDevolucion: fechaDevolucion ?? this.fechaDevolucion, // ✅ NUEVO
      total: total ?? this.total,
      estado: estado ?? this.estado,
      usuarioId: usuarioId ?? this.usuarioId,
      observaciones: observaciones ?? this.observaciones,
      penalidad: penalidad ?? this.penalidad, // ✅ NUEVO
    );
  }
}
