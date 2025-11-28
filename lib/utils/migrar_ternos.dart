import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/ternos_data.dart';

class MigrarTernos {
  static Future<void> subirTernosAFirestore() async {
    final firestore = FirebaseFirestore.instance;
    final ternos = TernosData.getTodosLosTernos();

    print('🚀 Iniciando migración de ${ternos.length} ternos...');

    int subidos = 0;
    int errores = 0;

    for (var terno in ternos) {
      try {
        // Usar el ID del terno como document ID
        await firestore.collection('ternos').doc(terno.id).set(terno.toMap());
        subidos++;
        print('✅ Subido: ${terno.nombre} (${terno.talla})');
      } catch (e) {
        errores++;
        print('❌ Error al subir ${terno.nombre}: $e');
      }
    }

    print('\n📊 RESUMEN:');
    print('   ✅ Subidos: $subidos');
    print('   ❌ Errores: $errores');
    print('   📦 Total: ${ternos.length}');
    print('\n🎉 Migración completada!');
  }

  // ✅ Método para duplicar un terno (crear stock)
  static Future<void> duplicarTerno(String ternoId, int cantidad) async {
    final firestore = FirebaseFirestore.instance;

    // Obtener el terno original
    final docSnapshot = await firestore.collection('ternos').doc(ternoId).get();

    if (!docSnapshot.exists) {
      print('❌ Terno no encontrado: $ternoId');
      return;
    }

    final ternoData = docSnapshot.data()!;

    print('🔄 Duplicando "$ternoId" $cantidad veces...');

    for (int i = 1; i <= cantidad; i++) {
      try {
        final nuevoId = '${ternoId}_copia$i';
        await firestore.collection('ternos').doc(nuevoId).set({
          ...ternoData,
          'id': nuevoId,
        });
        print('✅ Creado: $nuevoId');
      } catch (e) {
        print('❌ Error al duplicar: $e');
      }
    }

    print('🎉 Duplicación completada!');
  }
}
