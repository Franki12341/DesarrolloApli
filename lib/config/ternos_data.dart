import '../models/terno.dart';
import 'tallas_config.dart';

class TernosData {
  static final Map<String, String> imageIds = {
    'Terno Beige Claro Corte Smoking con Chaleco Negro':
        '1-Q5InVtrrLxiJHnvUVdLR8C4xEXCEHrU',
    'Terno Negro Elegante Formal': '11b29uKHMmYojQe-VozCwENS_67k_KI70',
    'Terno Azul Rey Premium': '12em10SQqmV3vcNyL_KJJaFfICj2_TSXv',
    'Terno Plomo Claro Moderno': '15NqpRUVPF-kBvO9yLA2Quu4F0OlsPQGW',
    'Terno Verde Bosque': '175OH2SJPZR6lYnxA01cIAxUJo1ij1-w-',
    'Terno Beige Corte Príncipe con Chaleco Verde':
        '19teAL8opcsCG_oExphNoX3ePXTjUnEAq',
    'Terno Café Chocolate': '1B1CTLCypKIXYVxIfrRCfRx_Rtmu65Nbn',
    'Terno Negro Corte Smoking con Chaleco':
        '1BhlaGt-QQqPoM4ZUhraZTge1Kukl2hSJ',
    'Terno Vino con Chaleco': '1C0Qx1Y3afDbdZrTC-SKx3-KO77ZXUNgU',
    'Terno Plomo con Chaleco': '1Ejkm7wyBZi0-JQaNoHlRXVx3iR6HhWHZ',
    'Terno Azul Celeste Verano': '1Gl9AR9wLLyBn8afsvm4zDpU_tWDFYSmz',
    'Terno Negro Tafeta con Chaleco Corte Smoking Niño':
        '1H89ydaJcnpwA5b1PcO51RtSMySWeLeKY',
    'Terno Gris Carbón': '1Hfaf5Ut06ji6HORapd4kd-k_JtrYu_NX',
    'Terno Blanco Ceremonia': '1ItYmpIBqz5ywcMbwu19XqdXwW-BCgP-q',
    'Chaleco Plomo Niño': '1JnAH0OW-zyw7g-VG9ViaCd_EOeft3dqs',
    'Terno Azul Marino Clásico': '1KqMzvJ1m3Ytag-XxpwzzKGtsf5WO4QdV',
    'Terno Beige Claro Tafeta Niño': '1KyRtci4zlSqfb3qenhHNrOqUgylmrBNz',
    'Terno Rosa Salmón': '1Q76cnTiJUfBF44q-iHeMEev7CawR6YAP',
    'Terno Negro Tafeta con Chaleco y Rayas Rojas Niño':
        '1U9lo1tWmyoznEFyFipLKctBH4nOV6swl',
    'Terno Gris Perla': '1UopVI0Y_mbwGmMCargiD6kYR8cqTxg3r',
    'Terno Plomo Plata Corte Príncipe': '1XHVzDp9OBxxQSg2A-6vqzvVz3--Ju4QH',
    'Terno Marrón Oscuro': '1ZiUl5yLOrcOmAOistbTi4xYAIA9E6nNE',
    'Terno Azul Marino con Chaleco Tipo Jaquet':
        '1ZxsEL-Zg0JqrtGJXKA_UuvFC23Ub9EIu',
    'Terno Verde Menta': '1aKJP7kxvrU7AfKdCACdT0s-H08rKxyP6',
    'Terno Azul Marino Corte Smoking': '1dpwPXM8ll1Pl21r9ft1_9fZX7IELt-W6',
    'Terno Negro con Chaleco Corte Smoking':
        '1g7t4ZjNfQQGWs4BfwFlzgvynmYDyTjiX',
    'Terno Azul Acero': '1hZUbLPhqs0EJbR9Y4Qpop7Y1O5hitsGd',
    'Terno Verde Tafeta': '1jE5mg3QsL0YrKfDklfjKixU3NGo9B_HU',
    'Terno Gris Oxford Premium': '1nigt1tRdVsp60Uxsr62rIjwKo4ogT1Lv',
    'Terno Azul Marino con Chaleco': '1o6BKZ0FkPHKPb8NnDatdj42nvr0haGpM',
    'Terno Verde Tafeta con Chaleco Niño': '1vj6RuOxUHNFgI7BWLAFBTs9lCwgzKZyS',
    'Terno Azul Marino con Chaleco Corte Smoking':
        '1yRizgjBn0No6SwLVL-AeGvQHkdBJB6I7',
    'Terno Plomo Oscuro Tafeta': '1zDQxmaBNBHKyr263b7fSR3PqjySwMgqR',
  };

  static String getImageUrl(String imageId) {
    return 'https://drive.google.com/thumbnail?id=$imageId&sz=w1000';
  }

  static List<Terno> getTodosLosTernos() {
    final List<Map<String, dynamic>> ternosData = [
      {
        'nombre': 'Terno Blanco Ceremonia',
        'talla': '0',
        'color': 'Blanco',
        'categoria': 'Ceremonia'
      },
      {
        'nombre': 'Terno Beige Claro Tafeta Niño',
        'talla': '0',
        'color': 'Beige',
        'categoria': 'Tafeta'
      },
      {
        'nombre': 'Chaleco Plomo Niño',
        'talla': '2',
        'color': 'Plomo',
        'categoria': 'Chaleco'
      },
      {
        'nombre': 'Terno Rosa Salmón',
        'talla': '2',
        'color': 'Rosa',
        'categoria': 'Casual'
      },
      {
        'nombre': 'Terno Verde Tafeta con Chaleco Niño',
        'talla': '4',
        'color': 'Verde',
        'categoria': 'Tafeta'
      },
      {
        'nombre': 'Terno Negro Tafeta con Chaleco y Rayas Rojas Niño',
        'talla': '4',
        'color': 'Negro',
        'categoria': 'Tafeta'
      },
      {
        'nombre': 'Terno Negro Tafeta con Chaleco Corte Smoking Niño',
        'talla': '6',
        'color': 'Negro',
        'categoria': 'Smoking'
      },
      {
        'nombre': 'Terno Azul Celeste Verano',
        'talla': '6',
        'color': 'Azul',
        'categoria': 'Verano'
      },
      {
        'nombre': 'Terno Verde Menta',
        'talla': '8',
        'color': 'Verde',
        'categoria': 'Casual'
      },
      {
        'nombre': 'Terno Café Chocolate',
        'talla': '8',
        'color': 'Café',
        'categoria': 'Elegante'
      },
      {
        'nombre': 'Terno Plomo Claro Moderno',
        'talla': '10',
        'color': 'Plomo',
        'categoria': 'Moderno'
      },
      {
        'nombre': 'Terno Verde Bosque',
        'talla': '10',
        'color': 'Verde',
        'categoria': 'Elegante'
      },
      {
        'nombre': 'Terno Gris Perla',
        'talla': '12',
        'color': 'Gris',
        'categoria': 'Elegante'
      },
      {
        'nombre': 'Terno Marrón Oscuro',
        'talla': '12',
        'color': 'Marrón',
        'categoria': 'Clásico'
      },
      {
        'nombre': 'Terno Plomo con Chaleco',
        'talla': '14',
        'color': 'Plomo',
        'categoria': 'Chaleco'
      },
      {
        'nombre': 'Terno Gris Carbón',
        'talla': '14',
        'color': 'Gris',
        'categoria': 'Elegante'
      },
      {
        'nombre': 'Terno Vino con Chaleco',
        'talla': '16',
        'color': 'Vino',
        'categoria': 'Chaleco'
      },
      {
        'nombre': 'Terno Verde Tafeta',
        'talla': '16',
        'color': 'Verde',
        'categoria': 'Tafeta'
      },
      {
        'nombre': 'Terno Azul Rey Premium',
        'talla': '18',
        'color': 'Azul',
        'categoria': 'Premium'
      },
      {
        'nombre': 'Terno Plomo Plata Corte Príncipe',
        'talla': '18',
        'color': 'Plomo',
        'categoria': 'Príncipe'
      },
      {
        'nombre': 'Terno Azul Acero',
        'talla': '26',
        'color': 'Azul',
        'categoria': 'Moderno'
      },
      {
        'nombre': 'Terno Gris Oxford Premium',
        'talla': '26',
        'color': 'Gris',
        'categoria': 'Premium'
      },
      {
        'nombre': 'Terno Beige Corte Príncipe con Chaleco Verde',
        'talla': 'XS',
        'color': 'Beige',
        'categoria': 'Príncipe'
      },
      {
        'nombre': 'Terno Azul Marino Clásico',
        'talla': 'XS',
        'color': 'Azul',
        'categoria': 'Clásico'
      },
      {
        'nombre': 'Terno Plomo Oscuro Tafeta',
        'talla': 'S',
        'color': 'Plomo',
        'categoria': 'Tafeta'
      },
      {
        'nombre': 'Terno Azul Marino con Chaleco Tipo Jaquet',
        'talla': 'S',
        'color': 'Azul',
        'categoria': 'Jaquet'
      },
      {
        'nombre': 'Terno Negro Elegante Formal',
        'talla': 'M',
        'color': 'Negro',
        'categoria': 'Formal'
      },
      {
        'nombre': 'Terno Azul Marino con Chaleco',
        'talla': 'M',
        'color': 'Azul',
        'categoria': 'Chaleco'
      },
      {
        'nombre': 'Terno Beige Claro Corte Smoking con Chaleco Negro',
        'talla': 'L',
        'color': 'Beige',
        'categoria': 'Smoking'
      },
      {
        'nombre': 'Terno Negro Corte Smoking con Chaleco',
        'talla': 'L',
        'color': 'Negro',
        'categoria': 'Smoking'
      },
      {
        'nombre': 'Terno Azul Marino Corte Smoking',
        'talla': 'XL',
        'color': 'Azul',
        'categoria': 'Smoking'
      },
      {
        'nombre': 'Terno Negro con Chaleco Corte Smoking',
        'talla': 'XL',
        'color': 'Negro',
        'categoria': 'Smoking'
      },
      {
        'nombre': 'Terno Azul Marino con Chaleco Corte Smoking',
        'talla': 'XXL',
        'color': 'Azul',
        'categoria': 'Smoking'
      },
    ];

    return ternosData.map((data) {
      final nombre = data['nombre'] as String;
      final talla = data['talla'] as String;
      final imageId = imageIds[nombre] ?? '';

      return Terno(
        id: nombre.toLowerCase().replaceAll(' ', '_'),
        nombre: nombre,
        talla: talla,
        precio: TallasConfig.getPrecioPorTalla(talla),
        imagenes: [getImageUrl(imageId)],
        descripcion: 'Elegante $nombre disponible para alquiler de 3 días.',
        categoria: data['categoria'] as String,
        color: data['color'] as String,
        disponible: true,
      );
    }).toList();
  }

  static List<Terno> getTernosPorTalla(String talla) {
    return getTodosLosTernos().where((terno) => terno.talla == talla).toList();
  }

  static Map<String, List<Terno>> getTernosAgrupadosPorTalla() {
    final Map<String, List<Terno>> agrupados = {};

    for (var talla in TallasConfig.tallas) {
      agrupados[talla] = getTernosPorTalla(talla);
    }

    return agrupados;
  }
}
