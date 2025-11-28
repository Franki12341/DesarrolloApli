class ImagesConfig {
  // Mapeo completo de descripciones a IDs de Google Drive (Cuenta Personal)
  // TODAS las imágenes están públicas y accesibles
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

  // Obtener URL directa de visualización de Google Drive
  static String getImageUrl(String nombre) {
    final id = imageIds[nombre];
    if (id == null) {
      return 'https://via.placeholder.com/400x600/CCCCCC/666666?text=${Uri.encodeComponent(nombre)}';
    }
    // Usar thumbnail de Google Drive (funciona con cuenta personal)
    return 'https://drive.google.com/thumbnail?id=$id&sz=w1000';
  }

  // Obtener lista de nombres disponibles
  static List<String> get imageNames => imageIds.keys.toList();

  // Obtener todas las URLs
  static List<String> getAllImageUrls() {
    return imageNames.map((nombre) => getImageUrl(nombre)).toList();
  }

  // Buscar por palabras clave
  static List<String> searchByKeyword(String keyword) {
    final lowerKeyword = keyword.toLowerCase();
    return imageNames
        .where((name) => name.toLowerCase().contains(lowerKeyword))
        .toList();
  }

  // Filtrar por categoría
  static List<String> getByCategory(String category) {
    switch (category.toLowerCase()) {
      case 'niño':
      case 'nino':
        return imageNames
            .where((name) => name.toLowerCase().contains('niño'))
            .toList();
      case 'smoking':
        return imageNames
            .where((name) => name.toLowerCase().contains('smoking'))
            .toList();
      case 'chaleco':
        return imageNames
            .where((name) => name.toLowerCase().contains('chaleco'))
            .toList();
      case 'tafeta':
        return imageNames
            .where((name) => name.toLowerCase().contains('tafeta'))
            .toList();
      case 'principe':
      case 'príncipe':
        return imageNames
            .where((name) => name.toLowerCase().contains('príncipe'))
            .toList();
      case 'ceremonia':
        return imageNames
            .where((name) => name.toLowerCase().contains('ceremonia'))
            .toList();
      default:
        return imageNames;
    }
  }

  // Obtener por color
  static List<String> getByColor(String color) {
    final lowerColor = color.toLowerCase();
    final colorMap = {
      'negro': ['negro'],
      'azul': ['azul'],
      'plomo': ['plomo', 'gris'],
      'gris': ['gris', 'plomo'],
      'beige': ['beige'],
      'vino': ['vino'],
      'verde': ['verde'],
      'blanco': ['blanco'],
      'marrón': ['marrón', 'cafe', 'café', 'chocolate'],
      'cafe': ['café', 'marrón', 'chocolate'],
      'rosa': ['rosa', 'salmón'],
    };

    final searchTerms = colorMap[lowerColor] ?? [lowerColor];
    return imageNames.where((name) {
      final lowerName = name.toLowerCase();
      return searchTerms.any((term) => lowerName.contains(term));
    }).toList();
  }

  // Obtener ternos para niños
  static List<String> getTernosNino() {
    return getByCategory('niño');
  }

  // Obtener ternos con chaleco
  static List<String> getTernosConChaleco() {
    return getByCategory('chaleco');
  }

  // Obtener ternos estilo smoking
  static List<String> getTernosSmoking() {
    return getByCategory('smoking');
  }

  // Estadísticas
  static Map<String, int> getStatistics() {
    return {
      'total': imageIds.length,
      'niños': getTernosNino().length,
      'con_chaleco': getTernosConChaleco().length,
      'smoking': getTernosSmoking().length,
      'tafeta': getByCategory('tafeta').length,
    };
  }
}
