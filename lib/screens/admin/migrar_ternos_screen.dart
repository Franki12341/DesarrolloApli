import 'package:flutter/material.dart';
import '../../utils/migrar_ternos.dart';

class MigrarTernosScreen extends StatefulWidget {
  const MigrarTernosScreen({super.key});

  @override
  State<MigrarTernosScreen> createState() => _MigrarTernosScreenState();
}

class _MigrarTernosScreenState extends State<MigrarTernosScreen> {
  bool _migrando = false;
  String _resultado = '';

  Future<void> _ejecutarMigracion() async {
    setState(() {
      _migrando = true;
      _resultado = 'Migrando ternos a Firestore...';
    });

    try {
      await MigrarTernos.subirTernosAFirestore();
      setState(() {
        _resultado =
            '✅ ¡Migración completada!\n\nRevisa la consola para ver los detalles.';
      });
    } catch (e) {
      setState(() {
        _resultado = '❌ Error: $e';
      });
    } finally {
      setState(() {
        _migrando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Migrar Ternos a Firebase'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.cloud_upload,
                size: 100,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 24),
              const Text(
                'Migración de Ternos',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Esto subirá todos los 33 ternos a Firestore.\nSolo hazlo UNA vez.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              if (_resultado.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _resultado.contains('✅')
                        ? Colors.green.shade50
                        : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _resultado.contains('✅')
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),
                  child: Text(
                    _resultado,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _migrando ? null : _ejecutarMigracion,
                  icon: _migrando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.upload),
                  label: Text(_migrando ? 'Migrando...' : 'Iniciar Migración'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
