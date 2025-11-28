import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart' as auth_provider;
import '../models/reserva.dart';
import 'detalle_reserva_screen.dart';

class MisReservasScreen extends StatefulWidget {
  const MisReservasScreen({super.key});

  @override
  State<MisReservasScreen> createState() => _MisReservasScreenState();
}

class _MisReservasScreenState extends State<MisReservasScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _filtroEstado = 'todos';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color _getColorEstado(String estado) {
    switch (estado.toLowerCase()) {
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
      case 'cancelada':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getIconoEstado(String estado) {
    switch (estado.toLowerCase()) {
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
      case 'cancelada':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<auth_provider.AuthProvider>(context);
    final usuarioId = authProvider.usuario?.uid;

    if (usuarioId == null) {
      return const Scaffold(
        body: Center(
          child: Text('Debes iniciar sesión'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mis Reservas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          onTap: (index) {
            setState(() {
              switch (index) {
                case 0:
                  _filtroEstado = 'todos';
                  break;
                case 1:
                  _filtroEstado = 'pendiente';
                  break;
                case 2:
                  _filtroEstado = 'confirmada';
                  break;
                case 3:
                  _filtroEstado = 'entregada';
                  break;
                case 4:
                  _filtroEstado = 'completada';
                  break;
              }
            });
          },
          tabs: const [
            Tab(icon: Icon(Icons.all_inclusive), text: 'Todas'),
            Tab(icon: Icon(Icons.schedule), text: 'Pendientes'),
            Tab(icon: Icon(Icons.check_circle_outline), text: 'Confirmadas'),
            Tab(icon: Icon(Icons.local_shipping), text: 'Entregadas'),
            Tab(icon: Icon(Icons.done_all), text: 'Completadas'),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple.shade50, Colors.white],
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('reservas')
              .where('usuarioId', isEqualTo: usuarioId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text(
                      'Error al cargar reservas',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox_outlined,
                        size: 100, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'No tienes reservas',
                      style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'Explora nuestro catálogo y haz tu primera reserva',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            }

            var todasReservas = snapshot.data!.docs
                .map((doc) {
                  try {
                    final data = doc.data() as Map<String, dynamic>;
                    return Reserva.fromMap(data);
                  } catch (e) {
                    return null;
                  }
                })
                .whereType<Reserva>()
                .toList();

            todasReservas
                .sort((a, b) => b.fechaCreacion.compareTo(a.fechaCreacion));

            final reservas = _filtroEstado == 'todos'
                ? todasReservas
                : todasReservas
                    .where((r) =>
                        r.estado.toLowerCase() == _filtroEstado.toLowerCase())
                    .toList();

            if (reservas.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox_outlined,
                        size: 100, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'No tienes reservas',
                      style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        _filtroEstado == 'todos'
                            ? 'Explora nuestro catálogo y haz tu primera reserva'
                            : 'No tienes reservas con estado: $_filtroEstado',
                        style: const TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reservas.length,
              itemBuilder: (context, index) {
                final reserva = reservas[index];
                return _ReservaCard(
                  reserva: reserva,
                  colorEstado: _getColorEstado(reserva.estado),
                  iconoEstado: _getIconoEstado(reserva.estado),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _ReservaCard extends StatelessWidget {
  final Reserva reserva;
  final Color colorEstado;
  final IconData iconoEstado;

  const _ReservaCard({
    required this.reserva,
    required this.colorEstado,
    required this.iconoEstado,
  });

  Color _getColorUrgencia(String urgencia) {
    switch (urgencia) {
      case 'retrasado':
        return Colors.red.shade700;
      case 'hoy':
        return Colors.red;
      case 'manana':
        return Colors.orange;
      case 'tiempo':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool tieneItems = reserva.items.isNotEmpty;
    final primerTerno = tieneItems ? reserva.items.first.terno : null;
    final cantidadTernos = reserva.items.length;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalleReservaScreen(reserva: reserva),
          ),
        );
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: (tieneItems &&
                          primerTerno!.imagenes.isNotEmpty &&
                          primerTerno.imagenes.first.isNotEmpty)
                      ? CachedNetworkImage(
                          imageUrl: primerTerno.imagenes.first,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[300],
                            child: const Center(
                                child: CircularProgressIndicator()),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.checkroom, size: 80),
                          ),
                        )
                      : Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: const Center(
                              child: Icon(Icons.checkroom, size: 80)),
                        ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorEstado,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(iconoEstado, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          reserva.estado.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (cantidadTernos > 1)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '+$cantidadTernos',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tieneItems ? primerTerno!.nombre : 'Sin ternos',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Talla ${tieneItems ? primerTerno!.talla : 'N/A'}',
                          style: TextStyle(
                            color: Colors.deepPurple[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'S/. ${reserva.total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),

                  // ✅ RECORDATORIO DE DEVOLUCIÓN (solo si está entregada)
                  if (reserva.estado.toLowerCase() == 'entregada') ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _getColorUrgencia(reserva.urgenciaDevolucion)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getColorUrgencia(reserva.urgenciaDevolucion),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.access_alarm,
                                color: _getColorUrgencia(
                                    reserva.urgenciaDevolucion),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  reserva.mensajeUrgencia,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: _getColorUrgencia(
                                        reserva.urgenciaDevolucion),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.event,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Devolver antes del: ${DateFormat('dd/MM/yyyy').format(reserva.fechaDevolucion)} a las 6:00 PM',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                          if (reserva.estaRetrasado) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.warning,
                                      color: Colors.red, size: 16),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Penalidad acumulada: S/. ${reserva.penalidadCalculada.toStringAsFixed(2)} (${reserva.diasRetraso} día${reserva.diasRetraso > 1 ? 's' : ''})',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
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
                    const SizedBox(height: 12),
                  ],

                  _InfoRow(
                    icon: Icons.calendar_today,
                    label: 'Fecha del evento',
                    value: DateFormat('dd/MM/yyyy').format(reserva.fechaEvento),
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.access_time,
                    label: 'Reservado el',
                    value: DateFormat('dd/MM/yyyy HH:mm')
                        .format(reserva.fechaCreacion),
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.confirmation_number,
                    label: 'ID Reserva',
                    value:
                        '#${reserva.id.length >= 8 ? reserva.id.substring(0, 8).toUpperCase() : reserva.id.toUpperCase()}',
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetalleReservaScreen(reserva: reserva),
                              ),
                            );
                          },
                          icon: const Icon(Icons.visibility),
                          label: const Text('Ver Detalles'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.deepPurple,
                            side: const BorderSide(color: Colors.deepPurple),
                          ),
                        ),
                      ),
                      if (reserva.estado == 'pendiente') ...[
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _mostrarDialogoCancelar(context, reserva);
                            },
                            icon: const Icon(Icons.cancel),
                            label: const Text('Cancelar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarDialogoCancelar(BuildContext context, Reserva reserva) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Reserva'),
        content:
            const Text('¿Estás seguro de que deseas cancelar esta reserva?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('reservas')
                  .doc(reserva.id)
                  .update({'estado': 'cancelada'});

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Reserva cancelada'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sí, cancelar'),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              Text(
                value,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
