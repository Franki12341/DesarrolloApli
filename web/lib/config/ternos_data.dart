import '../models/terno.dart';
import 'tallas_config.dart';

class TernosData {
  static final Map<String, String> imageIds = {
    // Bebés (Talla 0)
    'Terno Blanco Tafeta Talla 0': '13XhL03yu6JYOhYkZvMIzGY-vw9ejK2DU',
    'Terno Celeste Tafeta Talla 0': '16IiRph7cYdYW9xn8Fj6kAl26D_3cYfL2',

    // Bebés (Talla 2)
    'Terno Negro Smoking Talla 2': '1WRMRbUwoCt6e7P5IYHdjTi_iuX7Px5p9',
    'Terno Negro Clásico Talla 2': '1q3sGDiza9TgevaRyds4EZxR7j1uXQW_6',
    'Terno Azul Noche Talla 2': '1Wd65Q9hNg0NGuH0B5gWnbA9eXkhyhc6g',
    'Terno Azul Marino Talla 2': '1H9KsEwbCpjfAF3A_LcMHF7TqfUx4UTs1',
    'Terno Beige Talla 2': '19Rnsck5raM8xGQN7hQT2vxy8LgA5L73S',
    'Terno Plomo Talla 2': '18ZUQGaexKmD8L8iiiGLfAEVTYtbE40UD',
    'Terno Plomo Plata Talla 2': '1nT4NKzigR4npKSrwEBOXn4DK4rtf1HwO',

    // Niños (Talla 4)
    'Terno Vino Wafer': '1XHVzDp9OBxxQSg2A-6vqzvVz3--Ju4QH',
    'Terno Verde Olivo Tafeta': '1JnAH0OW-zyw7g-VG9ViaCd_EOeft3dqs',

    // Niños (Talla 6)
    'Terno Azul Noche Tafeta Talla 6': '1Gl9AR9wLLyBn8afsvm4zDpU_tWDFYSmz',
    'Terno Negro Smoking Talla 6': '1H89ydaJcnpwA5b1PcO51RtSMySWeLeKY',

    // Niños (Talla 8)
    'Terno Plomo Rata Tafeta': '11b29uKHMmYojQe-VozCwENS_67k_KI70',
    'Terno Negro Smoking Talla 8': '1aKJP7kxvrU7AfKdCACdT0s-H08rKxyP6',

    // Niños (Talla 10)
    'Terno Azul Metálico Tafeta': '1hZUbLPhqs0EJbR9Y4Qpop7Y1O5hitsGd',
    'Terno Blanco Tafeta Talla 10': '1UopVI0Y_mbwGmMCargiD6kYR8cqTxg3r',

    // Niños (Talla 12)
    'Terno Azul Noche Smoking': '1U9lo1tWmyoznEFyFipLKctBH4nOV6swl',
    'Terno Plomo Plata Tafeta Talla 12': '12em10SQqmV3vcNyL_KJJaFfICj2_TSXv',

    // Niños (Talla 14)
    'Terno Celeste Metal Tafeta': '1KyRtci4zlSqfb3qenhHNrOqUgylmrBNz',

    // Niños (Talla 16)
    'Terno Verde Tafeta Talla 16': '1Q76cnTiJUfBF44q-iHeMEev7CawR6YAP',

    // Niños (Talla 18)
    'Terno Gris Tafeta': '1Ejkm7wyBZi0-JQaNoHlRXVx3iR6HhWHZ',

    // Adultos (Talla XS)
    'Terno Marrón Tafeta': '15NqpRUVPF-kBvO9yLA2Quu4F0OlsPQGW',
    'Terno Vino Tafeta': '1B1CTLCypKIXYVxIfrRCfRx_Rtmu65Nbn',

    // Adultos (Talla S)
    'Terno Negro Tafeta Talla S': '1vj6RuOxUHNFgI7BWLAFBTs9lCwgzKZyS',
    'Terno Palo Rosa Tafeta': '1ZxsEL-Zg0JqrtGJXKA_UuvFC23Ub9EIu',

    // Adultos (Talla M)
    'Terno Blanco Smoking': '1yRizgjBn0No6SwLVL-AeGvQHkdBJB6I7',
    'Terno Azul Marino Talla M': '1ZiUl5yLOrcOmAOistbTi4xYAIA9E6nNE',

    // Adultos (Talla L)
    'Terno Verde Entallado': '1o6BKZ0FkPHKPb8NnDatdj42nvr0haGpM',
    'Terno Blanco Tafeta Talla L': '1C0Qx1Y3afDbdZrTC-SKx3-KO77ZXUNgU',

    // Adultos (Talla XL)
    'Terno Blanco Hueso Tafeta': '1nigt1tRdVsp60Uxsr62rIjwKo4ogT1Lv',
    'Terno Celeste Tafeta': '1g7t4ZjNfQQGWs4BfwFlzgvynmYDyTjiX',

    // Adultos (Talla XXL)
    'Terno Azul Marino Smoking': '1jE5mg3QsL0YrKfDklfjKixU3NGo9B_HU',
    'Terno Marrón Oscuro Tafeta': '1Hfaf5Ut06ji6HORapd4kd-k_JtrYu_NX',

    // Adultos (Talla 26)
    'Terno Negro Smoking Talla 26': '1zDQxmaBNBHKyr263b7fSR3PqjySwMgqR',
    'Terno Marrón Claro Tafeta': '1dpwPXM8ll1Pl21r9ft1_9fZX7IELt-W6',
    'Terno Blanco Hueso Príncipe': '19teAL8opcsCG_oExphNoX3ePXTjUnEAq',
    'Terno Plomo Tafeta': '1KqMzvJ1m3Ytag-XxpwzzKGtsf5WO4QdV',
    'Terno Verde Talla 26 A': '175OH2SJPZR6lYnxA01cIAxUJo1ij1-w-',
    'Terno Beige Smoking': '1-Q5InVtrrLxiJHnvUVdLR8C4xEXCEHrU',
    'Terno Verde Talla 26 B': '1aKJP7kxvrU7AfKdCACdT0s-H08rKxyP6',
    'Terno Negro Smoking B': '1BhlaGt-QQqPoM4ZUhraZTge1Kukl2hSJ',
  };

  static String getImageUrl(String imageId) {
    return 'https://drive.google.com/thumbnail?id=$imageId&sz=w1000';
  }

  static List<Terno> getTodosLosTernos() {
    final List<Map<String, dynamic>> ternosData = [
      // ========== BEBÉS (Talla 0) ==========
      {
        'nombre': 'Terno Blanco Tafeta',
        'talla': '0',
        'color': 'Blanco',
        'material': 'Manchester',
        'corte': 'Clásico',
        'estilo': 'Ceremonia',
        'componentes': 2,
        'imageKey': 'Terno Blanco Tafeta Talla 0'
      },
      {
        'nombre': 'Terno Celeste Tafeta',
        'talla': '0',
        'color': 'Celeste',
        'material': 'Manchester',
        'corte': 'Clásico',
        'estilo': 'Ceremonia',
        'componentes': 2,
        'imageKey': 'Terno Celeste Tafeta Talla 0'
      },

      // ========== BEBÉS (Talla 2) ==========
      {
        'nombre': 'Terno Negro Smoking',
        'talla': '2',
        'color': 'Negro',
        'material': 'Manchester',
        'corte': 'Smoking',
        'estilo': 'Gala',
        'componentes': 2,
        'imageKey': 'Terno Negro Smoking Talla 2'
      },
      {
        'nombre': 'Terno Negro Clásico',
        'talla': '2',
        'color': 'Negro',
        'material': 'Manchester',
        'corte': 'Clásico',
        'estilo': 'Ceremonia',
        'componentes': 2,
        'imageKey': 'Terno Negro Clásico Talla 2'
      },
      {
        'nombre': 'Terno Azul Noche',
        'talla': '2',
        'color': 'Azul Noche',
        'material': 'Manchester',
        'corte': 'Clásico',
        'estilo': 'Gala',
        'componentes': 2,
        'imageKey': 'Terno Azul Noche Talla 2'
      },
      {
        'nombre': 'Terno Azul Marino',
        'talla': '2',
        'color': 'Azul Marino',
        'material': 'Manchester',
        'corte': 'Clásico',
        'estilo': 'Ceremonia',
        'componentes': 2,
        'imageKey': 'Terno Azul Marino Talla 2'
      },
      {
        'nombre': 'Terno Beige',
        'talla': '2',
        'color': 'Beige',
        'material': 'Manchester',
        'corte': 'Clásico',
        'estilo': 'Ceremonia',
        'componentes': 2,
        'imageKey': 'Terno Beige Talla 2'
      },
      {
        'nombre': 'Terno Plomo',
        'talla': '2',
        'color': 'Plomo',
        'material': 'Manchester',
        'corte': 'Clásico',
        'estilo': 'Elegante',
        'componentes': 2,
        'imageKey': 'Terno Plomo Talla 2'
      },
      {
        'nombre': 'Terno Plomo Plata',
        'talla': '2',
        'color': 'Plomo Plata',
        'material': 'Manchester',
        'corte': 'Clásico',
        'estilo': 'Gala',
        'componentes': 2,
        'imageKey': 'Terno Plomo Plata Talla 2'
      },

      // ========== NIÑOS (Talla 4) ==========
      {
        'nombre': 'Terno Vino Wafer',
        'talla': '4',
        'color': 'Vino',
        'material': 'Manchester',
        'corte': 'Entallado',
        'estilo': 'Gala',
        'componentes': 3,
        'imageKey': 'Terno Vino Wafer'
      },
      {
        'nombre': 'Terno Verde Olivo',
        'talla': '4',
        'color': 'Verde Olivo',
        'material': 'Manchester',
        'corte': 'Entallado',
        'estilo': 'Gala',
        'componentes': 3,
        'imageKey': 'Terno Verde Olivo Tafeta'
      },

      // ========== NIÑOS (Talla 6) ==========
      {
        'nombre': 'Terno Azul Noche Tafeta',
        'talla': '6',
        'color': 'Azul Noche',
        'material': 'Manchester',
        'corte': 'Entallado',
        'estilo': 'Gala',
        'componentes': 3,
        'imageKey': 'Terno Azul Noche Tafeta Talla 6'
      },
      {
        'nombre': 'Terno Negro Smoking',
        'talla': '6',
        'color': 'Negro',
        'material': 'Manchester',
        'corte': 'Smoking',
        'estilo': 'Gala',
        'componentes': 2,
        'imageKey': 'Terno Negro Smoking Talla 6'
      },

      // ========== NIÑOS (Talla 8) ==========
      {
        'nombre': 'Terno Plomo Rata',
        'talla': '8',
        'color': 'Plomo Rata',
        'material': 'Manchester',
        'corte': 'Entallado',
        'estilo': 'Gala',
        'componentes': 3,
        'imageKey': 'Terno Plomo Rata Tafeta'
      },
      {
        'nombre': 'Terno Negro Elegante',
        'talla': '8',
        'color': 'Negro',
        'material': 'Manchester',
        'corte': 'Smoking',
        'estilo': 'Gala',
        'componentes': 3,
        'imageKey': 'Terno Negro Smoking Talla 8'
      },

      // ========== NIÑOS (Talla 10) ==========
      {
        'nombre': 'Terno Azul Metálico',
        'talla': '10',
        'color': 'Azul Metálico',
        'material': 'Manchester',
        'corte': 'Entallado',
        'estilo': 'Gala',
        'componentes': 2,
        'imageKey': 'Terno Azul Metálico Tafeta'
      },
      {
        'nombre': 'Terno Blanco Ceremonia',
        'talla': '10',
        'color': 'Blanco',
        'material': 'Manchester',
        'corte': 'Clásico',
        'estilo': 'Ceremonia',
        'componentes': 2,
        'imageKey': 'Terno Blanco Tafeta Talla 10'
      },

      // ========== NIÑOS (Talla 12) ==========
      {
        'nombre': 'Terno Azul Noche Elegante',
        'talla': '12',
        'color': 'Azul Noche',
        'material': 'Manchester',
        'corte': 'Entallado',
        'estilo': 'Gala',
        'componentes': 3,
        'imageKey': 'Terno Azul Noche Smoking'
      },
      {
        'nombre': 'Terno Plomo Plata Premium',
        'talla': '12',
        'color': 'Plomo Plata',
        'material': 'Manchester',
        'corte': 'Entallado',
        'estilo': 'Gala',
        'componentes': 3,
        'imageKey': 'Terno Plomo Plata Tafeta Talla 12'
      },

      // ========== NIÑOS (Talla 14) ==========
      {
        'nombre': 'Terno Celeste Metal',
        'talla': '14',
        'color': 'Celeste Metal',
        'material': 'Manchester',
        'corte': 'Entallado',
        'estilo': 'Gala',
        'componentes': 3,
        'imageKey': 'Terno Celeste Metal Tafeta'
      },

      // ========== NIÑOS (Talla 16) ==========
      {
        'nombre': 'Terno Verde Elegante',
        'talla': '16',
        'color': 'Verde',
        'material': 'Manchester',
        'corte': 'Entallado',
        'estilo': 'Gala',
        'componentes': 3,
        'imageKey': 'Terno Verde Tafeta Talla 16'
      },

      // ========== NIÑOS (Talla 18) ==========
      {
        'nombre': 'Terno Gris Premium',
        'talla': '18',
        'color': 'Gris',
        'material': 'Manchester',
        'corte': 'Entallado',
        'estilo': 'Gala',
        'componentes': 3,
        'imageKey': 'Terno Gris Tafeta'
      },

      // ========== ADULTOS (Talla XS) ==========
      {
        'nombre': 'Terno Marrón Italiano',
        'talla': 'XS',
        'color': 'Marrón',
        'material': 'Manchester',
        'corte': 'Italiano',
        'estilo': 'Gala',
        'componentes': 2,
        'imageKey': 'Terno Marrón Tafeta'
      },
      {
        'nombre': 'Terno Vino Elegante',
        'talla': 'XS',
        'color': 'Vino',
        'material': 'Manchester',
        'corte': 'Italiano',
        'estilo': 'Gala',
        'componentes': 3,
        'imageKey': 'Terno Vino Tafeta'
      },

      // ========== ADULTOS (Talla S) ==========
      {
        'nombre': 'Terno Negro Italiano',
        'talla': 'S',
        'color': 'Negro',
        'material': 'Manchester',
        'corte': 'Italiano',
        'estilo': 'Gala',
        'componentes': 2,
        'imageKey': 'Terno Negro Tafeta Talla S'
      },
      {
        'nombre': 'Terno Palo Rosa',
        'talla': 'S',
        'color': 'Palo Rosa',
        'material': 'Manchester',
        'corte': 'Italiano',
        'estilo': 'Gala',
        'componentes': 3,
        'imageKey': 'Terno Palo Rosa Tafeta'
      },

      // ========== ADULTOS (Talla M) ==========
      {
        'nombre': 'Terno Blanco Formal',
        'talla': 'M',
        'color': 'Blanco',
        'material': 'Manchester',
        'corte': 'Smoking',
        'estilo': 'Gala',
        'componentes': 3,
        'imageKey': 'Terno Blanco Smoking'
      },
      {
        'nombre': 'Terno Azul Marino Clásico',
        'talla': 'M',
        'color': 'Azul Marino',
        'material': 'Manchester',
        'corte': 'Italiano',
        'estilo': 'Gala',
        'componentes': 3,
        'imageKey': 'Terno Azul Marino Talla M'
      },

      // ========== ADULTOS (Talla L) ==========
      {
        'nombre': 'Terno Verde Moderno',
        'talla': 'L',
        'color': 'Verde',
        'material': 'Manchester',
        'corte': 'Entallado',
        'estilo': 'Gala',
        'componentes': 2,
        'imageKey': 'Terno Verde Entallado'
      },
      {
        'nombre': 'Terno Blanco Sofisticado',
        'talla': 'L',
        'color': 'Blanco',
        'material': 'Manchester',
        'corte': 'Italiano',
        'estilo': 'Gala',
        'componentes': 3,
        'imageKey': 'Terno Blanco Tafeta Talla L'
      },

      // ========== ADULTOS (Talla XL) ==========
      {
        'nombre': 'Terno Blanco Hueso',
        'talla': 'XL',
        'color': 'Blanco Hueso',
        'material': 'Manchester',
        'corte': 'Italiano',
        'estilo': 'Gala',
        'componentes': 2,
        'imageKey': 'Terno Blanco Hueso Tafeta'
      },
      {
        'nombre': 'Terno Celeste Elegante',
        'talla': 'XL',
        'color': 'Celeste',
        'material': 'Manchester',
        'corte': 'Italiano',
        'estilo': 'Gala',
        'componentes': 3,
        'imageKey': 'Terno Celeste Tafeta'
      },

      // ========== ADULTOS (Talla XXL) ==========
      {
        'nombre': 'Terno Azul Marino Premium',
        'talla': 'XXL',
        'color': 'Azul Marino',
        'material': 'Manchester',
        'corte': 'Smoking',
        'estilo': 'Gala',
        'componentes': 3,
        'imageKey': 'Terno Azul Marino Smoking'
      },
      {
        'nombre': 'Terno Marrón Oscuro',
        'talla': 'XXL',
        'color': 'Marrón Oscuro',
        'material': 'Manchester',
        'corte': 'Italiano',
        'estilo': 'Gala',
        'componentes': 3,
        'imageKey': 'Terno Marrón Oscuro Tafeta'
      },

      // ========== ADULTOS (Talla 26) ==========
      {
        'nombre': 'Terno Negro Smoking Premium',
        'talla': '26',
        'color': 'Negro',
        'material': 'Manchester',
        'corte': 'Smoking',
        'estilo': 'Gala',
        'componentes': 3,
        'imageKey': 'Terno Negro Smoking Talla 26'
      },
      {
        'nombre': 'Terno Marrón Claro',
        'talla': '26',
        'color': 'Marrón Claro',
        'material': 'Manchester',
        'corte': 'Italiano',
        'estilo': 'Gala',
        'componentes': 3,
        'imageKey': 'Terno Marrón Claro Tafeta'
      },
      {
        'nombre': 'Terno Blanco Hueso Príncipe',
        'talla': '26',
        'color': 'Blanco Hueso',
        'material': 'Manchester',
        'corte': 'Italiano',
        'estilo': 'Gala',
        'componentes': 3,
        'imageKey': 'Terno Blanco Hueso Príncipe'
      },
      {
        'nombre': 'Terno Plomo Elegante',
        'talla': '26',
        'color': 'Plomo',
        'material': 'Manchester',
        'corte': 'Italiano',
        'estilo': 'Gala',
        'componentes': 3,
        'imageKey': 'Terno Plomo Tafeta'
      },
      {
        'nombre': 'Terno Verde Imperial',
        'talla': '26',
        'color': 'Verde',
        'material': 'Manchester',
        'corte': 'Italiano',
        'estilo': 'Gala',
        'componentes': 3,
        'imageKey': 'Terno Verde Talla 26 A'
      },
      {
        'nombre': 'Terno Beige Smoking',
        'talla': '26',
        'color': 'Beige',
        'material': 'Manchester',
        'corte': 'Smoking',
        'estilo': 'Gala',
        'componentes': 3,
        'imageKey': 'Terno Beige Smoking'
      },
    ];

    return ternosData.map((data) {
      final imageKey = data['imageKey'] as String;
      final imageId = imageIds[imageKey] ?? '';

      return Terno(
        id: '${data['nombre']}_${data['talla']}'
            .toLowerCase()
            .replaceAll(' ', '_'),
        nombre: data['nombre'] as String,
        talla: data['talla'] as String,
        precio: TallasConfig.getPrecioPorTalla(data['talla'] as String),
        imagenes: [getImageUrl(imageId)],
        descripcion:
            'Elegante ${data['nombre']} de ${data['material']}, corte ${data['corte']} ideal para eventos de ${data['estilo']}. '
            'Conjunto de ${data['componentes']} piezas disponible para alquiler de 3 días.',
        categoria: data['estilo'] as String,
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
