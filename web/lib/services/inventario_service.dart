import 'package:cloud_firestore/cloud_firestore.dart';

class InventarioService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Verifica si un terno está disponible para una fecha específica
  Future<bool> verificarDisponibilidadTerno({
    required String ternoId,
    required DateTime fechaEvento,
  }) async {
    try {
      print('🔍 Verificando disponibilidad del terno: $ternoId');
      print('   Fecha evento: ${fechaEvento.toIso8601String()}');

      // 1. Verificar que el terno existe y está marcado como disponible
      final ternoDoc = await _firestore.collection('ternos').doc(ternoId).get();

      if (!ternoDoc.exists) {
        print('❌ Terno no existe en Firebase');
        return false;
      }

      final ternoData = ternoDoc.data()!;
      final disponibleEnCatalogo = ternoData['disponible'] as bool? ?? true;

      if (!disponibleEnCatalogo) {
        print('❌ Terno marcado como NO disponible en catálogo');
        return false;
      }

      // 2. Calcular rango de fechas (fecha evento ± 2 días para alquiler de 3 días)
      final fechaInicio = fechaEvento.subtract(const Duration(days: 2));
      final fechaFin = fechaEvento.add(const Duration(days: 2));

      print(
          '   Rango de búsqueda: ${fechaInicio.toIso8601String()} a ${fechaFin.toIso8601String()}');

      // 3. Buscar reservas activas
      final reservasSnapshot = await _firestore.collection('reservas').where(
          'estado',
          whereIn: ['pendiente', 'confirmada', 'entregada']).get();

      print('   Total reservas activas: ${reservasSnapshot.docs.length}');

      // 4. Verificar cada reserva
      for (var doc in reservasSnapshot.docs) {
        final data = doc.data();

        // Obtener fecha del evento
        DateTime reservaFecha;
        try {
          final rawFecha = data['fechaEvento'];
          if (rawFecha is Timestamp) {
            reservaFecha = rawFecha.toDate();
          } else if (rawFecha is String) {
            reservaFecha = DateTime.parse(rawFecha);
          } else if (rawFecha is DateTime) {
            reservaFecha = rawFecha;
          } else {
            continue;
          }
        } catch (e) {
          print('⚠️ No se pudo parsear fechaEvento de reserva ${doc.id}: $e');
          continue;
        }

        // Verificar si las fechas se superponen
        if (_fechasSeSuperponen(reservaFecha, fechaEvento)) {
          // Verificar si esta reserva incluye el terno
          final itemsRaw = data['items'] as List<dynamic>? ?? [];

          for (var item in itemsRaw) {
            try {
              String? itemTernoId;

              if (item is String) {
                itemTernoId = item;
              } else if (item is Map) {
                final itemMap = Map<String, dynamic>.from(item);

                // Buscar el ID del terno en diferentes ubicaciones
                if (itemMap['terno'] is Map) {
                  final tmap = Map<String, dynamic>.from(itemMap['terno']);
                  itemTernoId =
                      (tmap['id'] ?? tmap['documentId'] ?? tmap['ternoId'])
                          ?.toString();
                } else if (itemMap['terno'] is String) {
                  itemTernoId = itemMap['terno'] as String;
                }

                itemTernoId ??=
                    (itemMap['ternoId'] ?? itemMap['id'])?.toString();
              }

              if (itemTernoId != null && itemTernoId == ternoId) {
                print(
                    '❌ Terno $ternoId NO disponible (reserva ${doc.id} en $reservaFecha)');
                return false;
              }
            } catch (e) {
              print('⚠️ Error leyendo item de reserva ${doc.id}: $e');
            }
          }
        }
      }

      print('✅ Terno $ternoId DISPONIBLE');
      return true;
    } catch (e) {
      print('❌ Error al verificar disponibilidad: $e');
      if (e is FirebaseException && e.code == 'permission-denied') {
        throw Exception(
            'No tiene permisos para consultar reservas. Inicie sesión como administrador.');
      }
      return true; // ✅ CAMBIO: Por defecto disponible si no hay reservas
    }
  }

  /// Verifica si dos fechas de eventos se superponen
  /// (considerando el período de entrega + evento + devolución)
  bool _fechasSeSuperponen(DateTime fecha1, DateTime fecha2) {
    // Cada reserva bloquea: 1 día antes, día del evento, 1 día después
    final inicio1 = fecha1.subtract(const Duration(days: 1));
    final fin1 = fecha1.add(const Duration(days: 1));

    final inicio2 = fecha2.subtract(const Duration(days: 1));
    final fin2 = fecha2.add(const Duration(days: 1));

    // Verificar si los rangos se superponen
    return !(fin1.isBefore(inicio2) || inicio1.isAfter(fin2));
  }

  /// Obtener información de disponibilidad para mostrar al usuario
  Future<Map<String, dynamic>> obtenerInfoDisponibilidad({
    required String ternoId,
    required DateTime fechaEvento,
  }) async {
    try {
      final disponible = await verificarDisponibilidadTerno(
        ternoId: ternoId,
        fechaEvento: fechaEvento,
      );

      return {
        'disponible': disponible,
        'mensaje': disponible
            ? 'Disponible para la fecha seleccionada'
            : 'Este terno no está disponible para la fecha seleccionada. Ya está reservado.',
      };
    } catch (e) {
      if (e is FirebaseException && e.code == 'permission-denied') {
        return {
          'disponible': false,
          'mensaje': 'No tiene permisos para consultar disponibilidad',
          'error': 'permission-denied',
        };
      }

      return {
        'disponible': true, // Por defecto disponible si hay error
        'mensaje': 'Disponible (no se pudieron verificar reservas)',
        'error': e.toString(),
      };
    }
  }

  /// Verificar múltiples ternos a la vez
  Future<Map<String, bool>> verificarDisponibilidadMultiple({
    required List<String> ternoIds,
    required DateTime fechaEvento,
  }) async {
    final resultados = <String, bool>{};

    for (var ternoId in ternoIds) {
      try {
        resultados[ternoId] = await verificarDisponibilidadTerno(
          ternoId: ternoId,
          fechaEvento: fechaEvento,
        );
      } catch (e) {
        print('Error verificando $ternoId: $e');
        resultados[ternoId] = true; // Por defecto disponible
      }
    }

    return resultados;
  }
}
