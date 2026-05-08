class LocationData {
  static final Map<String, List<String>> countriesWithCities = {
    'Argentina': ['Buenos Aires', 'Córdoba', 'Rosario', 'Mendoza', 'La Plata', 'San Miguel de Tucumán', 'Mar del Plata'],
    'Bolivia': ['La Paz', 'Santa Cruz', 'Cochabamba', 'Sucre', 'Oruro'],
    'Brasil': ['São Paulo', 'Río de Janeiro', 'Brasilia', 'Salvador', 'Fortaleza', 'Belo Horizonte', 'Curitiba'],
    'Chile': ['Santiago', 'Valparaíso', 'Concepción', 'La Serena', 'Antofagasta', 'Temuco'],
    'Colombia': ['Bogotá', 'Medellín', 'Cali', 'Barranquilla', 'Cartagena', 'Bucaramanga'],
    'Costa Rica': ['San José', 'Alajuela', 'Cartago', 'Heredia'],
    'Cuba': ['La Habana', 'Santiago de Cuba', 'Camagüey', 'Santa Clara'],
    'Ecuador': ['Quito', 'Guayaquil', 'Cuenca', 'Santo Domingo'],
    'El Salvador': ['San Salvador', 'Santa Ana', 'San Miguel'],
    'España': ['Madrid', 'Barcelona', 'Valencia', 'Sevilla', 'Bilbao', 'Málaga'],
    'Guatemala': ['Ciudad de Guatemala', 'Mixco', 'Villa Nueva', 'Quetzaltenango'],
    'Honduras': ['Tegucigalpa', 'San Pedro Sula', 'La Ceiba', 'Choloma'],
    'México': ['Ciudad de México', 'Guadalajara', 'Monterrey', 'Puebla', 'Tijuana', 'León', 'Cancún'],
    'Nicaragua': ['Managua', 'León', 'Masaya', 'Matagalpa'],
    'Panamá': ['Ciudad de Panamá', 'San Miguelito', 'Colón', 'David'],
    'Paraguay': ['Asunción', 'Ciudad del Este', 'San Lorenzo', 'Luque'],
    'Perú': ['Lima', 'Arequipa', 'Trujillo', 'Chiclayo', 'Piura', 'Cusco'],
    'Puerto Rico': ['San Juan', 'Bayamón', 'Carolina', 'Ponce'],
    'República Dominicana': ['Santo Domingo', 'Santiago', 'San Pedro de Macorís', 'La Romana'],
    'Uruguay': ['Montevideo', 'Salto', 'Ciudad de la Costa', 'Paysandú'],
    'Venezuela': ['Caracas', 'Maracaibo', 'Valencia', 'Barquisimeto', 'Maracay', 'Ciudad Guayana'],
    'Estados Unidos': ['Nueva York', 'Los Ángeles', 'Chicago', 'Houston', 'Miami', 'San Francisco'],
    'Canadá': ['Toronto', 'Montreal', 'Vancouver', 'Ottawa', 'Calgary'],
  };

  static List<String> get countries => countriesWithCities.keys.toList()..sort();

  static List<String> getCities(String country) {
    return countriesWithCities[country] ?? [];
  }

  static List<String> genders = [
    'Masculino',
    'Femenino',
    'Prefiero no decir',
  ];
}
