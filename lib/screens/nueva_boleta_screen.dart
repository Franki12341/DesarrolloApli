import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:examen01/models/boleta.dart';
import 'package:examen01/widgets/image_selector.dart';

class NuevaBoletaScreen extends StatefulWidget {
  const NuevaBoletaScreen({super.key});

  @override
  State<NuevaBoletaScreen> createState() => _NuevaBoletaScreenState();
}

class _NuevaBoletaScreenState extends State<NuevaBoletaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();

  // Controladores
  final _nombreController = TextEditingController();
  final _dniController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _ternoController = TextEditingController();
  final _precioController = TextEditingController();
  final _adelantoController = TextEditingController();
  final _observacionesController = TextEditingController();

  String _tallaSeleccionada = 'M';
  List<String> _imagenesSeleccionadas = [];
  DateTime _fechaAlquiler = DateTime.now();
  DateTime _fechaDevolucion = DateTime.now().add(const Duration(days: 3));

  String? _boletaId;
  bool _isSaving = false;

  final List<String> _tallas = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

  @override
  void initState() {
    super.initState();
    _boletaId = _uuid.v4();

    // Agregar listeners para autoguardado
    _nombreController.addListener(_autoGuardar);
    _dniController.addListener(_autoGuardar);
    _telefonoController.addListener(_autoGuardar);
    _ternoController.addListener(_autoGuardar);
    _precioController.addListener(_autoGuardar);
    _adelantoController.addListener(_autoGuardar);
    _observacionesController.addListener(_autoGuardar);
  }

  Future<void> _autoGuardar() async {
    if (_isSaving) return;
    if (_nombreController.text.isEmpty) return;

    _isSaving = true;

    try {
      final boleta = Boleta(
        id: _boletaId,
        nombreCliente: _nombreController.text,
        dniCliente: _dniController.text,
        telefonoCliente: _telefonoController.text,
        ternoDescripcion: _ternoController.text,
        talla: _tallaSeleccionada,
        fechaAlquiler: _fechaAlquiler,
        fechaDevolucion: _fechaDevolucion,
        precioTotal: double.tryParse(_precioController.text) ?? 0,
        adelanto: double.tryParse(_adelantoController.text) ?? 0,
        observaciones: _observacionesController.text.isEmpty
            ? null
            : _observacionesController.text,
        imagenes: _imagenesSeleccionadas,
        createdAt: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection('boletas')
          .doc(_boletaId)
          .set(boleta.toMap(), SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Guardado automático'),
            duration: Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error en autoguardado: $e');
    } finally {
      _isSaving = false;
    }
  }

  Future<void> _seleccionarFecha(bool esAlquiler) async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: esAlquiler ? _fechaAlquiler : _fechaDevolucion,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (fecha != null) {
      setState(() {
        if (esAlquiler) {
          _fechaAlquiler = fecha;
          if (_fechaDevolucion.isBefore(_fechaAlquiler)) {
            _fechaDevolucion = _fechaAlquiler.add(const Duration(days: 3));
          }
        } else {
          _fechaDevolucion = fecha;
        }
      });
      _autoGuardar();
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _dniController.dispose();
    _telefonoController.dispose();
    _ternoController.dispose();
    _precioController.dispose();
    _adelantoController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Boleta'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _autoGuardar().then((_) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Boleta guardada exitosamente'),
                      backgroundColor: Colors.green,
                    ),
                  );
                });
              }
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Datos del Cliente',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre completo *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese el nombre';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _dniController,
              decoration: const InputDecoration(
                labelText: 'DNI *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.badge),
              ),
              keyboardType: TextInputType.number,
              maxLength: 8,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese el DNI';
                }
                if (value.length != 8) {
                  return 'DNI debe tener 8 dígitos';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _telefonoController,
              decoration: const InputDecoration(
                labelText: 'Teléfono',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            const Text(
              'Detalles del Terno',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _ternoController,
              decoration: const InputDecoration(
                labelText: 'Descripción del terno *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.checkroom),
                hintText: 'Ej: Terno negro slim fit',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor describa el terno';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _tallaSeleccionada,
              decoration: const InputDecoration(
                labelText: 'Talla',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.straighten),
              ),
              items: _tallas.map((talla) {
                return DropdownMenuItem(
                  value: talla,
                  child: Text(talla),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _tallaSeleccionada = value!;
                });
                _autoGuardar();
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Fechas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _seleccionarFecha(true),
                    icon: const Icon(Icons.calendar_today),
                    label: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Fecha de Alquiler',
                            style: TextStyle(fontSize: 12)),
                        Text(dateFormat.format(_fechaAlquiler)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _seleccionarFecha(false),
                    icon: const Icon(Icons.event),
                    label: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Fecha de Devolución',
                            style: TextStyle(fontSize: 12)),
                        Text(dateFormat.format(_fechaDevolucion)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ImageSelector(
              selectedImages: _imagenesSeleccionadas,
              onImagesSelected: (images) {
                setState(() {
                  _imagenesSeleccionadas = images;
                });
                _autoGuardar();
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Detalles de Pago',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _precioController,
              decoration: const InputDecoration(
                labelText: 'Precio total *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
                prefixText: 'S/. ',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingrese el precio';
                }
                if (double.tryParse(value) == null) {
                  return 'Ingrese un precio válido';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _adelantoController,
              decoration: const InputDecoration(
                labelText: 'Adelanto',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.payment),
                prefixText: 'S/. ',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _observacionesController,
              decoration: const InputDecoration(
                labelText: 'Observaciones',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            const Text(
              'Detalles de Pago',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _precioController,
              decoration: const InputDecoration(
                labelText: 'Precio total *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
                prefixText: 'S/. ',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingrese el precio';
                }
                if (double.tryParse(value) == null) {
                  return 'Ingrese un precio válido';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _adelantoController,
              decoration: const InputDecoration(
                labelText: 'Adelanto',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.payment),
                prefixText: 'S/. ',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _observacionesController,
              decoration: const InputDecoration(
                labelText: 'Observaciones',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            const Card(
              color: Colors.blue,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Los datos se guardan automáticamente mientras escribes',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
