import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

class UbicacionScreen extends StatelessWidget {
  const UbicacionScreen({super.key});

  // Coordenadas exactas de TernoFit
  static const double _latitud = -12.06271;
  static const double _longitud = -75.21385;
  static const String _direccion = 'Ca. Real 310, Huancayo, Junín';
  static const String _telefono = '+51916738770';
  static const String _whatsapp = '51916738770';
  static const String _nombreTienda = 'TernoFit';

  Future<void> _abrirMapa(BuildContext context) async {
    final Uri mapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$_latitud,$_longitud',
    );

    try {
      if (await canLaunchUrl(mapsUrl)) {
        await launchUrl(
          mapsUrl,
          mode: kIsWeb
              ? LaunchMode.platformDefault
              : LaunchMode.externalApplication,
        );
      } else {
        if (context.mounted) {
          _mostrarError(context, 'No se pudo abrir Google Maps');
        }
      }
    } catch (e) {
      if (context.mounted) {
        _mostrarError(context, 'Error al abrir Google Maps: $e');
      }
    }
  }

  Future<void> _llamar(BuildContext context) async {
    final Uri telUrl = Uri.parse('tel:$_telefono');

    try {
      if (await canLaunchUrl(telUrl)) {
        await launchUrl(telUrl);
      } else {
        if (context.mounted) {
          _mostrarError(context, 'No se pudo realizar la llamada');
        }
      }
    } catch (e) {
      if (context.mounted) {
        _mostrarError(context, 'Error al realizar la llamada: $e');
      }
    }
  }

  Future<void> _abrirWhatsApp(BuildContext context) async {
    final String mensaje = Uri.encodeComponent(
      'Hola, quisiera información sobre alquiler de ternos en TernoFit',
    );
    final Uri whatsappUrl = Uri.parse('https://wa.me/$_whatsapp?text=$mensaje');

    try {
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(
          whatsappUrl,
          mode: kIsWeb
              ? LaunchMode.platformDefault
              : LaunchMode.externalApplication,
        );
      } else {
        if (context.mounted) {
          _mostrarError(context, 'No se pudo abrir WhatsApp');
        }
      }
    } catch (e) {
      if (context.mounted) {
        _mostrarError(context, 'Error al abrir WhatsApp: $e');
      }
    }
  }

  void _mostrarError(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _copiarDireccion(BuildContext context) {
    // En Web no se puede copiar al portapapeles sin permisos adicionales
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dirección: $_direccion'),
        backgroundColor: Colors.deepPurple,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dónde Encontrarnos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header con mapa decorativo
                Container(
                  width: double.infinity,
                  height: isLargeScreen ? 250 : 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.deepPurple,
                        Colors.deepPurple.shade300,
                      ],
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Ícono decorativo de fondo
                      Positioned(
                        right: -30,
                        bottom: -30,
                        child: Icon(
                          Icons.location_on,
                          size: isLargeScreen ? 250 : 200,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      // Contenido principal
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.store,
                              size: isLargeScreen ? 60 : 50,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _nombreTienda,
                            style: TextStyle(
                              fontSize: isLargeScreen ? 32 : 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Huancayo, Junín',
                            style: TextStyle(
                              fontSize: isLargeScreen ? 18 : 16,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(isLargeScreen ? 40 : 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Dirección principal con opción de copiar
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.deepPurple.shade200,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Dirección',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _direccion,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (!kIsWeb)
                              IconButton(
                                icon: const Icon(Icons.copy,
                                    color: Colors.deepPurple),
                                onPressed: () => _copiarDireccion(context),
                                tooltip: 'Copiar dirección',
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Título de acciones rápidas
                      Text(
                        'Acciones Rápidas',
                        style: TextStyle(
                          fontSize: isLargeScreen ? 22 : 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Botones de acción (Responsive)
                      isLargeScreen
                          ? Row(
                              children: [
                                Expanded(
                                  child: _buildActionButton(
                                    context: context,
                                    icon: Icons.directions,
                                    label: 'Cómo llegar',
                                    color: Colors.blue,
                                    onTap: () => _abrirMapa(context),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildActionButton(
                                    context: context,
                                    icon: Icons.phone,
                                    label: 'Llamar',
                                    color: Colors.green,
                                    onTap: () => _llamar(context),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildActionButton(
                                    context: context,
                                    icon: Icons.chat,
                                    label: 'WhatsApp',
                                    color: Colors.teal,
                                    onTap: () => _abrirWhatsApp(context),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildActionButton(
                                        context: context,
                                        icon: Icons.directions,
                                        label: 'Cómo\nllegar',
                                        color: Colors.blue,
                                        onTap: () => _abrirMapa(context),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildActionButton(
                                        context: context,
                                        icon: Icons.phone,
                                        label: 'Llamar',
                                        color: Colors.green,
                                        onTap: () => _llamar(context),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                _buildActionButton(
                                  context: context,
                                  icon: Icons.chat,
                                  label: 'WhatsApp',
                                  color: Colors.teal,
                                  onTap: () => _abrirWhatsApp(context),
                                ),
                              ],
                            ),

                      const SizedBox(height: 32),

                      // Horarios
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.deepPurple.shade50,
                              Colors.blue.shade50,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.deepPurple.shade200,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: Colors.deepPurple.shade700,
                                  size: 28,
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Horarios de Atención',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _buildHorarioRow(
                              'Lunes a Viernes',
                              '9:00 AM - 7:00 PM',
                              Icons.schedule,
                            ),
                            const Divider(height: 24),
                            _buildHorarioRow(
                              'Sábados',
                              '9:00 AM - 5:00 PM',
                              Icons.schedule,
                            ),
                            const Divider(height: 24),
                            _buildHorarioRow(
                              'Domingos',
                              'Cerrado',
                              Icons.event_busy,
                              isDisabled: true,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Botón grande de Google Maps
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton.icon(
                          onPressed: () => _abrirMapa(context),
                          icon: const Icon(Icons.map, size: 28),
                          label: const Text(
                            'Abrir en Google Maps',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Info adicional
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.amber.shade200, width: 2),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.amber.shade700,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Recuerda agendar tu cita con anticipación para garantizar la disponibilidad de tu terno',
                                style: TextStyle(
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Contacto directo
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.green.shade200, width: 2),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.phone_in_talk,
                              color: Colors.green.shade700,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '¿Tienes dudas?',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    "Llámanos al ${_telefono.replaceAll('+51', '+51 ')}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () => _llamar(context),
                                        icon: const Icon(Icons.phone, size: 18),
                                        label: const Text('Llamar'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      ElevatedButton.icon(
                                        onPressed: () =>
                                            _abrirWhatsApp(context),
                                        icon: const Icon(Icons.chat, size: 18),
                                        label: const Text('WhatsApp'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.teal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Helpers: fin del contenido principal
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorarioRow(String dia, String horas, IconData icon,
      {bool isDisabled = false}) {
    return Row(
      children: [
        Icon(icon,
            color: isDisabled ? Colors.grey : Colors.deepPurple, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dia,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDisabled ? Colors.grey : Colors.black),
              ),
              const SizedBox(height: 4),
              Text(
                horas,
                style:
                    TextStyle(color: isDisabled ? Colors.grey : Colors.black87),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
