import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../models/reserva.dart';

class AdminReservasScreen extends StatefulWidget {
  const AdminReservasScreen({super.key});

  @override
  State<AdminReservasScreen> createState() => _AdminReservasScreenState();
}

class _AdminReservasScreenState extends State<AdminReservasScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Reservas'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.list), text: 'Todas'),
            Tab(icon: Icon(Icons.schedule), text: 'Pendientes'),
            Tab(icon: Icon(Icons.check_circle_outline), text: 'Confirmadas'),
            Tab(icon: Icon(Icons.local_shipping), text: 'Entregadas'),
            Tab(icon: Icon(Icons.assignment_return), text: 'Devueltas'),
            Tab(icon: Icon(Icons.done_all), text: 'Completadas'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTodasReservasList(),
          _buildReservasList('pendiente'),
          _buildReservasList('confirmada'),
          _buildReservasList('entregada'),
          _buildReservasList('devuelta'),
          _buildReservasList('completada'),
        ],
      ),
    );
  }

  Widget _buildTodasReservasList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('reservas').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 60, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() {}),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final reservas = snapshot.data!.docs;

        if (reservas.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No hay reservas registradas',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        final reservasList = reservas.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Reserva.fromMap(data);
        }).toList();

        reservasList.sort((a, b) => a.fechaEvento.compareTo(b.fechaEvento));

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: reservasList.length,
          itemBuilder: (context, index) {
            return _buildReservaCardConEstado(reservasList[index]);
          },
        );
      },
    );
  }

  Widget _buildReservasList(String estado) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('reservas')
          .where('estado', isEqualTo: estado)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 60, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() {}),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final reservas = snapshot.data!.docs;

        if (reservas.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getIconForEstado(estado),
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No hay reservas ${_getEstadoNombre(estado)}',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        final reservasList = reservas.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Reserva.fromMap(data);
        }).toList();

        reservasList.sort((a, b) => b.fechaCreacion.compareTo(a.fechaCreacion));

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: reservasList.length,
          itemBuilder: (context, index) {
            return _buildReservaCard(reservasList[index], estado);
          },
        );
      },
    );
  }

  Widget _buildReservaCardConEstado(Reserva reserva) {
    final fechaEvento = DateFormat('dd/MM/yyyy').format(reserva.fechaEvento);
    final fechaCreacion = DateFormat(
      'dd/MM/yyyy HH:mm',
    ).format(reserva.fechaCreacion);
    final estado = reserva.estado;
    final ahora = DateTime.now();
    final eventoPasado = reserva.fechaEvento.isBefore(ahora);

    // ✅ Obtener imagen del primer terno
    final primerTerno =
        reserva.items.isNotEmpty ? reserva.items.first.terno : null;
    final imagenUrl = (primerTerno != null &&
            primerTerno.imagenes.isNotEmpty &&
            primerTerno.imagenes.first.isNotEmpty)
        ? primerTerno.imagenes.first
        : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: _buildLeadingAvatar(imagenUrl, estado),
        title: Row(
          children: [
            Expanded(
              child: Text(
                reserva.clienteNombre,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getColorForEstado(estado).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _getColorForEstado(estado), width: 1),
              ),
              child: Text(
                _getEstadoNombre(estado).toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: _getColorForEstado(estado),
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.confirmation_number, size: 14),
                const SizedBox(width: 4),
                Text(
                  'ID: ${_getSafeId(reserva.id)}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(
                  Icons.event,
                  size: 14,
                  color: eventoPasado ? Colors.red : null,
                ),
                const SizedBox(width: 4),
                Text(
                  'Evento: $fechaEvento',
                  style: TextStyle(
                    fontSize: 12,
                    color: eventoPasado ? Colors.red : null,
                    fontWeight: eventoPasado ? FontWeight.bold : null,
                  ),
                ),
                if (eventoPasado) ...[
                  const SizedBox(width: 4),
                  const Text(
                    '(Pasado)',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.red,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 2),
            Text(
              'Total: S/. ${reserva.total.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        children: [_buildReservaDetails(reserva, estado, fechaCreacion)],
      ),
    );
  }

  Widget _buildReservaCard(Reserva reserva, String estadoActual) {
    final fechaEvento = DateFormat('dd/MM/yyyy').format(reserva.fechaEvento);
    final fechaCreacion = DateFormat(
      'dd/MM/yyyy HH:mm',
    ).format(reserva.fechaCreacion);

    // ✅ Obtener imagen del primer terno
    final primerTerno =
        reserva.items.isNotEmpty ? reserva.items.first.terno : null;
    final imagenUrl = (primerTerno != null &&
            primerTerno.imagenes.isNotEmpty &&
            primerTerno.imagenes.first.isNotEmpty)
        ? primerTerno.imagenes.first
        : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: _buildLeadingAvatar(imagenUrl, estadoActual),
        title: Text(
          reserva.clienteNombre,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.confirmation_number, size: 14),
                const SizedBox(width: 4),
                Text(
                  'ID: ${_getSafeId(reserva.id)}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.event, size: 14),
                const SizedBox(width: 4),
                Text(
                  'Evento: $fechaEvento',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              'Total: S/. ${reserva.total.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        children: [_buildReservaDetails(reserva, estadoActual, fechaCreacion)],
      ),
    );
  }

  // ✅ NUEVO: Avatar con imagen del terno o icono
  Widget _buildLeadingAvatar(String? imagenUrl, String estado) {
    if (imagenUrl != null) {
      return CircleAvatar(
        radius: 24,
        backgroundColor: Colors.grey[300],
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: imagenUrl,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey[300],
              child: const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: _getColorForEstado(estado),
              child: Icon(
                _getIconForEstado(estado),
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
      );
    }

    return CircleAvatar(
      radius: 24,
      backgroundColor: _getColorForEstado(estado),
      child: Icon(_getIconForEstado(estado), color: Colors.white, size: 24),
    );
  }

  Widget _buildReservaDetails(
    Reserva reserva,
    String estado,
    String fechaCreacion,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Información del Cliente',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.badge, 'DNI', reserva.clienteDNI),
                _buildInfoRow(Icons.phone, 'Teléfono', reserva.clienteTelefono),
                _buildInfoRow(Icons.access_time, 'Reservado', fechaCreacion),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),
          const Text(
            'Ternos Alquilados:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          ...reserva.items.map(
            (item) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.checkroom,
                    color: Colors.deepPurple,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.terno.nombre,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Talla ${item.terno.talla} • Cantidad: ${item.cantidad}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'S/. ${item.subtotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (reserva.observaciones != null) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.notes, size: 18, color: Colors.orange),
                      SizedBox(width: 8),
                      Text(
                        'Observaciones:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reserva.observaciones!,
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          _buildActionButtons(reserva, estado),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Reserva reserva, String estadoActual) {
    // 1. PENDIENTE → CONFIRMADA
    if (estadoActual == 'pendiente') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => _cambiarEstado(reserva.id, 'confirmada'),
          icon: const Icon(Icons.check_circle_outline),
          label: const Text('Confirmar Reserva'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
    }

    // 2. CONFIRMADA → ENTREGADA
    if (estadoActual == 'confirmada') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => _cambiarEstado(reserva.id, 'entregada'),
          icon: const Icon(Icons.local_shipping),
          label: const Text('Marcar como Entregada'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
    }

    // 3. ENTREGADA → DEVUELTA
    if (estadoActual == 'entregada') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => _cambiarEstado(reserva.id, 'devuelta'),
          icon: const Icon(Icons.assignment_return),
          label: const Text('Marcar como Devuelta'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
    }

    // 4. DEVUELTA → COMPLETADA
    if (estadoActual == 'devuelta') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => _cambiarEstado(reserva.id, 'completada'),
          icon: const Icon(Icons.done_all),
          label: const Text('Verificar y Completar'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
    }

    // 5. COMPLETADA
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 8),
          Text(
            'Proceso completado ✓',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
          ),
        ],
      ),
    );
  }

  Future<void> _cambiarEstado(String reservaId, String nuevoEstado) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar cambio de estado'),
        content: Text(
          '¿Deseas marcar esta reserva como ${_getEstadoNombre(nuevoEstado)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    try {
      await FirebaseFirestore.instance
          .collection('reservas')
          .doc(reservaId)
          .update({
        'estado': nuevoEstado,
        'fechaActualizacion': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✅ Estado actualizado a ${_getEstadoNombre(nuevoEstado)}',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error al actualizar: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  String _getSafeId(String id) {
    if (id.isEmpty) return 'SIN-ID';
    return id.length >= 8 ? id.substring(0, 8).toUpperCase() : id.toUpperCase();
  }

  String _getEstadoNombre(String estado) {
    switch (estado) {
      case 'pendiente':
        return 'pendiente';
      case 'confirmada':
        return 'confirmada';
      case 'entregada':
        return 'entregada';
      case 'devuelta':
        return 'devuelta';
      case 'completada':
        return 'completada';
      default:
        return estado;
    }
  }

  IconData _getIconForEstado(String estado) {
    switch (estado) {
      case 'pendiente':
        return Icons.schedule;
      case 'confirmada':
        return Icons.check_circle_outline;
      case 'entregada':
        return Icons.local_shipping;
      case 'devuelta':
        return Icons.assignment_return;
      case 'completada':
        return Icons.done_all;
      default:
        return Icons.help;
    }
  }

  Color _getColorForEstado(String estado) {
    switch (estado) {
      case 'pendiente':
        return Colors.orange;
      case 'confirmada':
        return Colors.blue;
      case 'entregada':
        return Colors.purple;
      case 'devuelta':
        return Colors.teal;
      case 'completada':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
