import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/auth_provider.dart';
import '../models/reserva.dart';
import 'ubicacion_screen.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final usuario = authProvider.usuario;

    if (usuario == null) {
      return const Scaffold(
        body: Center(
          child: Text('No hay usuario'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mi Perfil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple.shade50, Colors.white],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Header con avatar
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(30),
                    decoration: const BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            child: Text(
                              usuario.nombre[0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          usuario.nombre,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          usuario.email,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Estadísticas
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('reservas')
                        .where('usuarioId', isEqualTo: usuario.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(
                            color: Colors.deepPurple,
                          ),
                        );
                      }

                      final reservas = snapshot.data!.docs
                          .map((doc) => Reserva.fromMap(
                              doc.data() as Map<String, dynamic>))
                          .toList();

                      final totalReservas = reservas.length;
                      final pendientes =
                          reservas.where((r) => r.estado == 'pendiente').length;
                      final completadas = reservas
                          .where((r) => r.estado == 'completada')
                          .length;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            // Responsive: columnas en móvil, fila en tablet/web
                            if (constraints.maxWidth > 600) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: _EstadisticaCard(
                                      icono: Icons.receipt_long,
                                      valor: totalReservas.toString(),
                                      etiqueta: 'Total',
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _EstadisticaCard(
                                      icono: Icons.schedule,
                                      valor: pendientes.toString(),
                                      etiqueta: 'Pendientes',
                                      color: Colors.orange,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _EstadisticaCard(
                                      icono: Icons.check_circle,
                                      valor: completadas.toString(),
                                      etiqueta: 'Completadas',
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _EstadisticaCard(
                                          icono: Icons.receipt_long,
                                          valor: totalReservas.toString(),
                                          etiqueta: 'Total',
                                          color: Colors.blue,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: _EstadisticaCard(
                                          icono: Icons.schedule,
                                          valor: pendientes.toString(),
                                          etiqueta: 'Pendientes',
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  _EstadisticaCard(
                                    icono: Icons.check_circle,
                                    valor: completadas.toString(),
                                    etiqueta: 'Completadas',
                                    color: Colors.green,
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Información personal
                  _SeccionPerfil(
                    titulo: 'Información Personal',
                    icono: Icons.person,
                    children: [
                      _InfoTile(
                        icono: Icons.person_outline,
                        titulo: 'Nombre Completo',
                        valor: usuario.nombre,
                      ),
                      _InfoTile(
                        icono: Icons.email_outlined,
                        titulo: 'Email',
                        valor: usuario.email,
                      ),
                      _InfoTile(
                        icono: Icons.badge_outlined,
                        titulo: 'DNI',
                        valor: usuario.dni,
                      ),
                      _InfoTile(
                        icono: Icons.phone_outlined,
                        titulo: 'Teléfono',
                        valor: usuario.telefono,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Opciones
                  _SeccionPerfil(
                    titulo: 'Configuración',
                    icono: Icons.settings,
                    children: [
                      // ✅ Botón de Ubicación
                      ListTile(
                        leading: const Icon(Icons.location_on,
                            color: Colors.deepPurple),
                        title: const Text('Ubicación de la Tienda'),
                        subtitle: const Text('Ver dónde recoger tus ternos'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UbicacionScreen(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading:
                            const Icon(Icons.edit, color: Colors.deepPurple),
                        title: const Text('Editar Perfil'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Función en desarrollo'),
                              backgroundColor: Colors.deepPurple,
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading:
                            const Icon(Icons.lock, color: Colors.deepPurple),
                        title: const Text('Cambiar Contraseña'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Función en desarrollo'),
                              backgroundColor: Colors.deepPurple,
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading:
                            const Icon(Icons.help, color: Colors.deepPurple),
                        title: const Text('Ayuda y Soporte'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Contacta al +51 916 738 770'),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 3),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading:
                            const Icon(Icons.info, color: Colors.deepPurple),
                        title: const Text('Acerca de'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          showAboutDialog(
                            context: context,
                            applicationName: 'TernoFit',
                            applicationVersion: '1.0.0',
                            applicationIcon: const Icon(
                              Icons.checkroom,
                              size: 50,
                              color: Colors.deepPurple,
                            ),
                            children: const [
                              Text('Aplicación de alquiler de ternos'),
                              Text('Desarrollado con Flutter'),
                              SizedBox(height: 8),
                              Text('📍 Ca. Real 310, Huancayo'),
                              Text('📞 +51 916 738 770'),
                            ],
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Botón cerrar sesión
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final confirmar = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              title: const Row(
                                children: [
                                  Icon(Icons.logout, color: Colors.red),
                                  SizedBox(width: 12),
                                  Text('Cerrar Sesión'),
                                ],
                              ),
                              content: const Text(
                                '¿Estás seguro de que deseas cerrar sesión?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Cancelar'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Cerrar Sesión'),
                                ),
                              ],
                            ),
                          );

                          if (confirmar == true && context.mounted) {
                            await authProvider.cerrarSesion();
                          }
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text(
                          'Cerrar Sesión',
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
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Widget de Estadística Card
class _EstadisticaCard extends StatelessWidget {
  final IconData icono;
  final String valor;
  final String etiqueta;
  final Color color;

  const _EstadisticaCard({
    required this.icono,
    required this.valor,
    required this.etiqueta,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        children: [
          Icon(icono, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            valor,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            etiqueta,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget de Sección Perfil
class _SeccionPerfil extends StatelessWidget {
  final String titulo;
  final IconData icono;
  final List<Widget> children;

  const _SeccionPerfil({
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
