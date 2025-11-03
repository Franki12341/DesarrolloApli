import 'package:flutter/foundation.dart';
import '../models/item_carrito.dart';
import '../models/terno.dart';

class CarritoProvider with ChangeNotifier {
  final List<ItemCarrito> _items = [];

  List<ItemCarrito> get items => List.unmodifiable(_items);

  int get cantidadTotal => _items.fold(0, (sum, item) => sum + item.cantidad);

  double get total => _items.fold(0.0, (sum, item) => sum + item.subtotal);

  bool get estaVacio => _items.isEmpty;

  void agregarTerno(Terno terno) {
    final index = _items.indexWhere((item) => item.terno.id == terno.id);

    if (index >= 0) {
      _items[index] = _items[index].copyWith(
        cantidad: _items[index].cantidad + 1,
      );
    } else {
      _items.add(ItemCarrito(terno: terno));
    }

    notifyListeners();
  }

  void eliminarTerno(String ternoId) {
    _items.removeWhere((item) => item.terno.id == ternoId);
    notifyListeners();
  }

  void actualizarCantidad(String ternoId, int nuevaCantidad) {
    if (nuevaCantidad <= 0) {
      eliminarTerno(ternoId);
      return;
    }

    final index = _items.indexWhere((item) => item.terno.id == ternoId);

    if (index >= 0) {
      _items[index] = _items[index].copyWith(cantidad: nuevaCantidad);
      notifyListeners();
    }
  }

  void incrementarCantidad(String ternoId) {
    final index = _items.indexWhere((item) => item.terno.id == ternoId);

    if (index >= 0) {
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
      )),
    );
    return item.terno.id.isEmpty ? 0 : item.cantidad;
  }

  void limpiar() {
    _items.clear();
    notifyListeners();
  }

  Map<String, dynamic> getResumen() {
    return {
      'cantidadItems': _items.length,
      'cantidadTotal': cantidadTotal,
      'total': total,
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
}
