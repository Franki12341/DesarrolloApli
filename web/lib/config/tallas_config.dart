class TallasConfig {
  static const List<String> tallas = [
    '0',
    '2',
    '4',
    '6',
    '8',
    '10',
    '12',
    '14',
    '16',
    '18',
    '26',
    'XS',
    'S',
    'M',
    'L',
    'XL',
    'XXL',
  ];

  static double getPrecioPorTalla(String talla) {
    switch (talla) {
      case '0':
        return 80.0;
      case '2':
        return 90.0;
      case '4':
        return 100.0;
      case '6':
        return 110.0;
      case '8':
        return 120.0;
      case '10':
        return 130.0;
      case '12':
        return 140.0;
      case '14':
        return 145.0;
      case '16':
        return 150.0;
      case '18':
        return 155.0;
      case '26':
        return 158.0;
      case 'XS':
        return 160.0;
      case 'S':
        return 165.0;
      case 'M':
        return 170.0;
      case 'L':
        return 180.0;
      case 'XL':
        return 190.0;
      case 'XXL':
        return 200.0;
      default:
        return 150.0;
    }
  }

  static String getCategoriaEdad(String talla) {
    switch (talla) {
      case '0':
        return '👶 Bebé (6-12 meses)';
      case '2':
        return '👧 Niño Pequeño (2-3 años)';
      case '4':
        return '🧒 Niño (4-5 años)';
      case '6':
        return '🧒 Niño (6-7 años)';
      case '8':
        return '👦 Niño (8-9 años)';
      case '10':
        return '👦 Niño (10-11 años)';
      case '12':
        return '🧑 Pre-Adolescente (12-13 años)';
      case '14':
        return '🧑 Pre-Adolescente (14-15 años)';
      case '16':
        return '👨 Adolescente (16-17 años)';
      case '18':
        return '👨 Adolescente/Joven (18+ años)';
      case '26':
        return '👔 Adulto Joven (Talla 26)';
      case 'XS':
        return '👔 Adulto XS (Extra Small)';
      case 'S':
        return '👔 Adulto S (Small)';
      case 'M':
        return '👔 Adulto M (Medium)';
      case 'L':
        return '👔 Adulto L (Large)';
      case 'XL':
        return '👔 Adulto XL (Extra Large)';
      case 'XXL':
        return '👔 Adulto XXL (Double XL)';
      default:
        return '👔 Talla Estándar';
    }
  }

  static String getIconoTalla(String talla) {
    if (['0', '2', '4'].contains(talla)) {
      return '👶';
    } else if (['6', '8', '10'].contains(talla)) {
      return '🧒';
    } else if (['12', '14', '16', '18'].contains(talla)) {
      return '🧑';
    } else {
      return '👔';
    }
  }

  static String getNombreCorto(String talla) {
    return 'TALLA $talla';
  }
}
