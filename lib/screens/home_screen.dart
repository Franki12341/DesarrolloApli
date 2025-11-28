import 'package:flutter/material.dart';
import '../config/tallas_config.dart';
import '../config/ternos_data.dart';
import '../widgets/terno_card.dart';
import '../widgets/carrito_badge.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _busqueda = '';

  @override
  Widget build(BuildContext context) {
    final ternosAgrupados = TernosData.getTernosAgrupadosPorTalla();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TernoFit',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: const [
          CarritoBadge(),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.deepPurple[50],
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _busqueda = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Buscar por color, nombre...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: TallasConfig.tallas.length,
              itemBuilder: (context, index) {
                final talla = TallasConfig.tallas[index];
                final ternos = ternosAgrupados[talla] ?? [];

                final ternosFiltrados = _busqueda.isEmpty
                    ? ternos
                    : ternos.where((terno) {
                        return terno.nombre.toLowerCase().contains(_busqueda) ||
                            terno.color.toLowerCase().contains(_busqueda) ||
                            terno.categoria.toLowerCase().contains(_busqueda);
                      }).toList();

                if (ternosFiltrados.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      color: Colors.deepPurple[100],
                      child: Row(
                        children: [
                          Text(
                            TallasConfig.getIconoTalla(talla),
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  TallasConfig.getNombreCorto(talla),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple[900],
                                  ),
                                ),
                                Text(
                                  TallasConfig.getCategoriaEdad(talla),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.deepPurple[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'S/. ${TallasConfig.getPrecioPorTalla(talla).toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 280,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        itemCount: ternosFiltrados.length,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            width: 180,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: TernoCard(terno: ternosFiltrados[index]),
                            ),
                          );
                        },
                      ),
                    ),
                    const Divider(height: 1, thickness: 1),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
