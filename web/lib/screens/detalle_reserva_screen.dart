import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reserva.dart';

class DetalleReservaScreen extends StatelessWidget {
  final Reserva reserva;

  const DetalleReservaScreen({super.key, required this.reserva});

  Color _getColorEstado(String estado) {
    switch (estado.toLowerCase()) {
      case 'pendiente':
        return Colors.orange;
      case 'confirmada':
        return Colors.green;
      case 'en uso':
        return Colors.blue;
      case 'completada':
        return Colors.grey;
      case 'cancelada':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar con imagen expandible
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.deepPurple,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Reserva #${reserva.id.substring(0, 8).toUpperCase()}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: reserva.items.first.terno.imagenes.first,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.checkroom, size: 100),
                    ),
                  ),
                  // Degradado oscuro
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Contenido
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Badge de estado grande
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: _getColorEstado(reserva.estado),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: _getColorEstado(reserva.estado).withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    'ESTADO: ${reserva.estado.toUpperCase()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),

                // Timeline del estado
                _TimelineEstado(
                  estadoActual: reserva.estado,
                  fechaReserva: reserva.fechaReserva,
                ),

                const SizedBox(height: 20),

                // Información del cliente
                _SeccionInfo(
                  titulo: 'Información del Cliente',
                  icono: Icons.person,
                  children: [
                    _InfoTile(
                      icono: Icons.person_outline,
                      titulo: 'Nombre',
                      valor: reserva.clienteNombre,
                    ),
                    _InfoTile(
                      icono: Icons.badge_outlined,
                      titulo: 'DNI',
                      valor: reserva.clienteDNI,
                    ),
                    _InfoTile(
                      icono: Icons.phone_outlined,
                      titulo: 'Teléfono',
                      valor: reserva.clienteTelefono,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Detalles de la reserva
                _SeccionInfo(
                  titulo: 'Detalles de la Reserva',
                  icono: Icons.calendar_today,
                  children: [
                    _InfoTile(
                      icono: Icons.event,
                      titulo: 'Fecha del Evento',
                      valor: DateFormat('EEEE, dd MMMM yyyy', 'es')
                          .format(reserva.fechaEvento),
                    ),
                    _InfoTile(
                      icono: Icons.schedule,
                      titulo: 'Fecha de Reserva',
                      valor: DateFormat('dd/MM/yyyy HH:mm')
                          .format(reserva.fechaReserva),
                    ),
                    _InfoTile(
                      icono: Icons.shopping_bag_outlined,
                      titulo: 'Cantidad de Ternos',
                      valor: '${reserva.items.length} terno(s)',
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Lista de ternos
                _SeccionTernos(items: reserva.items),

                const SizedBox(height: 20),

                // Observaciones
                if (reserva.observaciones != null &&
                    reserva.observaciones!.isNotEmpty)
                  _SeccionInfo(
                    titulo: 'Observaciones',
                    icono: Icons.notes,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          reserva.observaciones!,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 20),

                // Total
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.deepPurple, Colors.deepPurple.shade700],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'TOTAL A PAGAR',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'S/. ${reserva.total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Botones de acción
                if (reserva.estado == 'pendiente')
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _mostrarDialogoCancelar(context);
                            },
                            icon: const Icon(Icons.cancel),
                            label: const Text(
                              'Cancelar Reserva',
                              style: TextStyle(fontSize: 16),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // Contactar soporte
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Contacta al +51 999 999 999 para modificar tu reserva',
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.support_agent),
                            label: const Text(
                              'Modificar Reserva',
                              style: TextStyle(fontSize: 16),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.deepPurple,
                              side: const BorderSide(
                                color: Colors.deepPurple,
                                width: 2,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoCancelar(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text('Cancelar Reserva'),
          ],
        ),
        content: const Text(
          '¿Estás seguro de que deseas cancelar esta reserva? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('reservas')
                  .doc(reserva.id)
                  .update({'estado': 'cancelada'});

              if (context.mounted) {
                Navigator.pop(context); // Cerrar diálogo
                Navigator.pop(context); // Volver a la lista
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Reserva cancelada exitosamente'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sí, cancelar'),
          ),
        ],
      ),
    );
  }
}

// Widget de Timeline
class _TimelineEstado extends StatelessWidget {
  final String estadoActual;
  final DateTime fechaReserva;

  const _TimelineEstado({
    required this.estadoActual,
    required this.fechaReserva,
  });

  @override
  Widget build(BuildContext context) {
    final estados = [
      {'nombre': 'Pendiente', 'icono': Icons.schedule},
      {'nombre': 'Confirmada', 'icono': Icons.check_circle},
      {'nombre': 'En uso', 'icono': Icons.shopping_bag},
      {'nombre': 'Completada', 'icono': Icons.done_all},
    ];

    final indiceActual = estados.indexWhere(
      (e) => e['nombre'].toString().toLowerCase() == estadoActual.toLowerCase(),
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Seguimiento del Pedido',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ...List.generate(estados.length, (index) {
            final estado = estados[index];
            final completado = index <= indiceActual;
            final esActual = index == indiceActual;
            final esUltimo = index == estados.length - 1;

            return Column(
              children: [
                Row(
                  children: [
                    // Círculo
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: completado ? Colors.green : Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        estado['icono'] as IconData,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Texto
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            estado['nombre'] as String,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: esActual
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: completado ? Colors.black : Colors.grey,
                            ),
                          ),
                          if (esActual)
                            Text(
                              'Estado actual',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green[700],
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Check
                    if (completado && !esActual)
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                  ],
                ),
                // Línea conectora
                if (!esUltimo)
                  Container(
                    margin: const EdgeInsets.only(left: 19, top: 4, bottom: 4),
                    width: 2,
                    height: 30,
                    color: completado ? Colors.green : Colors.grey[300],
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

// Widget de Sección
class _SeccionInfo extends StatelessWidget {
  final String titulo;
  final IconData icono;
  final List<Widget> children;

  const _SeccionInfo({
    required this.titulo,
    required this.icono,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icono, color: Colors.deepPurple),
                const SizedBox(width: 12),
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }
}

// Widget de Info Tile
class _InfoTile extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String valor;

  const _InfoTile({
    required this.icono,
    required this.titulo,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icono, color: Colors.grey[600], size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  valor,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget de Sección de Ternos
class _SeccionTernos extends StatelessWidget {
  final List items;

  const _SeccionTernos({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.checkroom, color: Colors.deepPurple),
                SizedBox(width: 12),
                Text(
                  'Ternos Reservados',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...items.map((item) {
            final terno = item.terno;
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: terno.imagenes.first,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.checkroom),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.checkroom),
                  ),
                ),
              ),
              title: Text(
                terno.nombre,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text('Talla: ${terno.talla} | Cant: ${item.cantidad}'),
              trailing: Text(
                'S/. ${item.subtotal.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
