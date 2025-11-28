import 'package:flutter/foundation.dart';
import '../models/item_carrito.dart';
import '../models/terno.dart';
import '../services/inventario_service.dart';

class CarritoProvider with ChangeNotifier {
  final List<ItemCarrito> _items = [];
  final InventarioService _inventarioService = InventarioService();

  // ✅ NUEVO: Fecha del evento para el carrito
  DateTime? _fechaEvento;

  List<ItemCarrito> get items => List.unmodifiable(_items);
  DateTime? get fechaEvento => _fechaEvento;

  int get cantidadTotal => _items.fold(0, (sum, item) => sum + item.cantidad);
  double get total => _items.fold(0.0, (sum, item) => sum + item.subtotal);
  bool get estaVacio => _items.isEmpty;
  int get totalItems => _items.fold(0, (sum, item) => sum + item.cantidad);

  // ✅ NUEVO: Establecer fecha del evento
  void setFechaEvento(DateTime fecha) {
    _fechaEvento = fecha;
    notifyListeners();
  }

  // ✅ ACTUALIZADO: Agregar terno con validación de disponibilidad
  Future<void> agregarTerno(Terno terno, DateTime fechaEvento) async {
    // Validar que haya fecha
    if (_fechaEvento == null) {
      _fechaEvento = fechaEvento;
    }

    // Validar que todas las reservas sean para la misma fecha
    if (_fechaEvento != null && !_esMismaFecha(_fechaEvento!, fechaEvento)) {
      throw Exception(
          'Todos los ternos deben ser para la misma fecha de evento. '
          'Fecha del carrito: ${_formatearFecha(_fechaEvento!)}. '
          'Vacía el carrito para cambiar de fecha.');
    }

    // Validar límite de 5 ternos
    final cantidadActual = totalItems;
    if (cantidadActual >= 5) {
      throw Exception('Solo puedes alquilar máximo 5 ternos por día');
    }

    // ✅ VALIDAR DISPONIBILIDAD
    final disponible = await _inventarioService.verificarDisponibilidadTerno(
      ternoId: terno.id,
      fechaEvento: fechaEvento,
    );

    if (!disponible) {
      throw Exception(
          'Este terno no está disponible para la fecha ${_formatearFecha(fechaEvento)}. '
          'Por favor selecciona otra fecha.');
    }

    // Agregar al carrito
    final index = _items.indexWhere((item) => item.terno.id == terno.id);

    if (index >= 0) {
      final nuevaCantidad = _items[index].cantidad + 1;
      _items[index] = _items[index].copyWith(cantidad: nuevaCantidad);
    } else {
      _items.add(ItemCarrito(terno: terno));
    }

    notifyListeners();
  }

  void eliminarTerno(String ternoId) {
    _items.removeWhere((item) => item.terno.id == ternoId);

    // Si el carrito queda vacío, limpiar la fecha
    if (_items.isEmpty) {
      _fechaEvento = null;
    }

    notifyListeners();
  }

  void actualizarCantidad(String ternoId, int nuevaCantidad) {
    if (nuevaCantidad <= 0) {
      eliminarTerno(ternoId);
      return;
    }

    final index = _items.indexWhere((item) => item.terno.id == ternoId);

    if (index >= 0) {
      final cantidadSinEsteItem = totalItems - _items[index].cantidad;

      if (cantidadSinEsteItem + nuevaCantidad > 5) {
        throw Exception('Solo puedes alquilar máximo 5 ternos por día');
      }

      _items[index] = _items[index].copyWith(cantidad: nuevaCantidad);
      notifyListeners();
    }
  }

  void incrementarCantidad(String ternoId) {
    final index = _items.indexWhere((item) => item.terno.id == ternoId);

    if (index >= 0) {
      if (totalItems >= 5) {
        throw Exception('Solo puedes alquilar máximo 5 ternos por día');
      }

      _items[index] = _items[index].copyWith(
        cantidad: _items[index].cantidad + 1,
      );
      notifyListeners();
    }
  }

  void decrementarCantidad(String ternoId) {
    final index = _items.indexWhere((item) => item.terno.id == ternoId);

    if (index >= 0) {
      final nuevaCantidad = _items[index].cantidad - 1;

      if (nuevaCantidad <= 0) {
        eliminarTerno(ternoId);
      } else {
        _items[index] = _items[index].copyWith(cantidad: nuevaCantidad);
        notifyListeners();
      }
    }
  }

  bool contieneTerno(String ternoId) {
    return _items.any((item) => item.terno.id == ternoId);
  }

  int getCantidadTerno(String ternoId) {
    final item = _items.firstWhere(
      (item) => item.terno.id == ternoId,
      orElse: () => ItemCarrito(
        terno: Terno(
          id: '',
          nombre: '',
          talla: '',
          precio: 0,
          imagenes: [],
          descripcion: '',
          categoria: '',
          color: '',
        ),
      ),
    );
    return item.terno.id.isEmpty ? 0 : item.cantidad;
  }

  void limpiar() {
    _items.clear();
    _fechaEvento = null;
    notifyListeners();
  }

  // ✅ NUEVO: Validar disponibilidad antes de confirmar reserva
  Future<bool> validarDisponibilidadCompleta() async {
    if (_fechaEvento == null) return false;

    for (var item in _items) {
      final disponible = await _inventarioService.verificarDisponibilidadTerno(
        ternoId: item.terno.id,
        fechaEvento: _fechaEvento!,
      );

      if (!disponible) {
        return false;
      }
    }

    return true;
  }

  Map<String, dynamic> getResumen() {
    return {
      'cantidadItems': _items.length,
      'cantidadTotal': cantidadTotal,
      'total': total,
      'fechaEvento': _fechaEvento?.toIso8601String(),
      'items': _items
          .map((item) => {
                'nombre': item.terno.nombre,
                'talla': item.terno.talla,
                'cantidad': item.cantidad,
                'precio': item.terno.precio,
                'subtotal': item.subtotal,
              })
          .toList(),
    };
  }

  // ✅ Helpers
  bool _esMismaFecha(DateTime fecha1, DateTime fecha2) {
    return fecha1.year == fecha2.year &&
        fecha1.month == fecha2.month &&
        fecha1.day == fecha2.day;
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day.toString().padLeft(2, '0')}/'
        '${fecha.month.toString().padLeft(2, '0')}/'
        '${fecha.year}';
  }
}
