import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/terno.dart';
import '../providers/carrito_provider.dart';
import '../services/inventario_service.dart';
import '../config/tallas_config.dart';

class DetalleTernoScreen extends StatefulWidget {
  final Terno terno;

  const DetalleTernoScreen({super.key, required this.terno});

  @override
  State<DetalleTernoScreen> createState() => _DetalleTernoScreenState();
}

class _DetalleTernoScreenState extends State<DetalleTernoScreen> {
  DateTime? _fechaSeleccionada;
  bool _verificandoDisponibilidad = false;
  Map<String, dynamic>? _infoDisponibilidad;
  final InventarioService _inventarioService = InventarioService();

  @override
  void initState() {
    super.initState();
    // Verificar si ya hay una fecha en el carrito
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final carritoProvider =
          Provider.of<CarritoProvider>(context, listen: false);
      if (carritoProvider.fechaEvento != null) {
        setState(() {
          _fechaSeleccionada = carritoProvider.fechaEvento;
        });
        _verificarDisponibilidad();
      }
    });
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final fechaActual = DateTime.now();
    final fechaMinima =
        fechaActual.add(const Duration(days: 1)); // Mínimo mañana
    final fechaMaxima =
        fechaActual.add(const Duration(days: 365)); // Máximo 1 año

    final fecha = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada ?? fechaMinima,
      firstDate: fechaMinima,
      lastDate: fechaMaxima,
      locale: const Locale('es', 'ES'),
      helpText: 'Selecciona la fecha del evento',
      cancelText: 'Cancelar',
      confirmText: 'Seleccionar',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (fecha != null) {
      setState(() {
        _fechaSeleccionada = fecha;
      });
      await _verificarDisponibilidad();
    }
  }

  Future<void> _verificarDisponibilidad() async {
    if (_fechaSeleccionada == null) return;

    setState(() {
      _verificandoDisponibilidad = true;
      _infoDisponibilidad = null;
    });

    try {
      // ✅ CAMBIO: Usar ternoId en lugar de nombre/talla/color
      final info = await _inventarioService.obtenerInfoDisponibilidad(
        ternoId: widget.terno.id,
        fechaEvento: _fechaSeleccionada!,
      );

      setState(() {
        _infoDisponibilidad = info;
        _verificandoDisponibilidad = false;
      });
    } catch (e) {
      setState(() {
        _infoDisponibilidad = {
          'disponible': true,
          'mensaje': 'Disponible (error al verificar reservas)',
        };
        _verificandoDisponibilidad = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final carritoProvider = Provider.of<CarritoProvider>(context);
    final estaEnCarrito = carritoProvider.contieneTerno(widget.terno.id);
    final disponible = _infoDisponibilidad?['disponible'] ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Terno'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: widget.terno.id,
              child: CachedNetworkImage(
                imageUrl: widget.terno.imagenes.first,
                width: double.infinity,
                height: 400,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  height: 400,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  height: 400,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.checkroom, size: 100, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('Imagen no disponible'),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.terno.nombre,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Talla ${widget.terno.talla}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple[900],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.terno.color,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue[900],
                          ),
                        ),
                      ),
                      const Spacer(),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'S/. ${widget.terno.precio.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'por 3 días',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 12),

                  // ✅ SELECTOR DE FECHA
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.deepPurple.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.event,
                                color: Colors.deepPurple.shade700),
                            const SizedBox(width: 8),
                            const Text(
                              'Fecha del evento',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: () => _seleccionarFecha(context),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 20),
                                const SizedBox(width: 12),
                                Text(
                                  _fechaSeleccionada != null
                                      ? DateFormat('dd/MM/yyyy')
                                          .format(_fechaSeleccionada!)
                                      : 'Selecciona una fecha',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: _fechaSeleccionada != null
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                ),
                                const Spacer(),
                                const Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                        ),

                        // ✅ INDICADOR DE DISPONIBILIDAD
                        if (_verificandoDisponibilidad) ...[
                          const SizedBox(height: 12),
                          const Row(
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                              SizedBox(width: 8),
                              Text('Verificando disponibilidad...'),
                            ],
                          ),
                        ],

                        if (!_verificandoDisponibilidad &&
                            _infoDisponibilidad != null) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: disponible
                                  ? Colors.green.shade50
                                  : Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: disponible
                                    ? Colors.green.shade300
                                    : Colors.orange.shade300,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  disponible
                                      ? Icons.check_circle
                                      : Icons.info_outline,
                                  color:
                                      disponible ? Colors.green : Colors.orange,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _infoDisponibilidad!['mensaje'] ?? '',
                                    style: TextStyle(
                                      color: disponible
                                          ? Colors.green.shade900
                                          : Colors.orange.shade900,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  Text(
                    TallasConfig.getCategoriaEdad(widget.terno.talla),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Descripción',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.terno.descripcion,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.category, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Categoría: ${widget.terno.categoria}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.orange.shade700),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Máximo 5 ternos por día',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton.icon(
            onPressed: (_fechaSeleccionada != null &&
                    disponible &&
                    !_verificandoDisponibilidad)
                ? () async {
                    try {
                      await carritoProvider.agregarTerno(
                          widget.terno, _fechaSeleccionada!);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                '${widget.terno.nombre} agregado al carrito'),
                            backgroundColor: Colors.green,
                            duration: const Duration(seconds: 2),
                            action: SnackBarAction(
                              label: 'Ver carrito',
                              textColor: Colors.white,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                e.toString().replaceAll('Exception: ', '')),
                            backgroundColor: Colors.red,
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      }
                    }
                  }
                : null,
            icon: Icon(
              estaEnCarrito ? Icons.check : Icons.add_shopping_cart,
              size: 24,
            ),
            label: Text(
              _fechaSeleccionada == null
                  ? 'Selecciona una fecha'
                  : estaEnCarrito
                      ? 'Agregado al carrito'
                      : disponible
                          ? 'Agregar al carrito'
                          : 'No disponible',
              style: const TextStyle(fontSize: 18),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: estaEnCarrito
                  ? Colors.green
                  : (_fechaSeleccionada != null && disponible)
                      ? Colors.deepPurple
                      : Colors.grey,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
