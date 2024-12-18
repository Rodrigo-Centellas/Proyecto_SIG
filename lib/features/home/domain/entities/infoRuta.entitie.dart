/// Clase que representa una ruta de corte de servicio de agua
///
/// Contiene información sobre la programación de cortes de servicio incluyendo:
/// - [routeId]: Identificador único de la ruta (bsrutnrut)
/// - [description]: Descripción o nombre de la zona de corte (bsrutdesc)
/// - [abbreviation]: Abreviatura de la zona (bsrutabrv)
/// - [routeType]: Tipo de ruta, código interno (bsruttipo)
/// - [zoneNumber]: Número de la zona (bsrutnzon)
/// - [cutDate]: Fecha programada para el corte (bsrutfcor)
/// - [affectedUsers]: Número de usuarios afectados por el corte (bsrutcper)
/// - [status]: Estado del corte (0=pendiente/programado) (bsrutstat)
/// - [referenceId]: ID de referencia único del corte (bsrutride)
/// - [technicianName]: Nombre del técnico asignado (dNomb)
/// - [zoneId]: ID de la zona (GbzonNzon)
/// - [zoneName]: Nombre completo de la zona (dNzon)

class InfoRuta {
  final int routeId; // ID de la ruta de corte
  final String description; // Nombre/descripción de la zona
  final String abbreviation; // Abreviatura de la zona
  final int routeType; // Tipo de ruta
  final int zoneNumber; // Número de zona
  final DateTime cutDate; // Fecha del corte
  final int affectedUsers; // Número de usuarios afectados
  final int status; // Estado del corte
  final int referenceId; // ID de referencia
  final String technicianName; // Nombre del técnico responsable
  final int zoneId; // ID de la zona
  final String zoneName; // Nombre de la zona

  InfoRuta({
    required this.routeId,
    required this.description,
    required this.abbreviation,
    required this.routeType,
    required this.zoneNumber,
    required this.cutDate,
    required this.affectedUsers,
    required this.status,
    required this.referenceId,
    required this.technicianName,
    required this.zoneId,
    required this.zoneName,
  });

  // Factory constructor para crear una instancia desde XML/JSON
  factory InfoRuta.fromXml(Map<String, dynamic> xml) {
    return InfoRuta(
      routeId: int.parse(xml['bsrutnrut'] ?? '0'),
      description: xml['bsrutdesc']?.trim() ?? '',
      abbreviation: xml['bsrutabrv']?.trim() ?? '',
      routeType: int.parse(xml['bsruttipo'] ?? '0'),
      zoneNumber: int.parse(xml['bsrutnzon'] ?? '0'),
      cutDate: DateTime.parse(xml['bsrutfcor'] ?? ''),
      affectedUsers: int.parse(xml['bsrutcper'] ?? '0'),
      status: int.parse(xml['bsrutstat'] ?? '0'),
      referenceId: int.parse(xml['bsrutride'] ?? '0'),
      technicianName: xml['dNomb']?.trim() ?? '',
      zoneId: int.parse(xml['GbzonNzon'] ?? '0'),
      zoneName: xml['dNzon']?.trim() ?? '',
    );
  }

  // Método para convertir la instancia a un Map (útil para persistencia o API)
  Map<String, dynamic> toMap() {
    return {
      'bsrutnrut': routeId,
      'bsrutdesc': description,
      'bsrutabrv': abbreviation,
      'bsruttipo': routeType,
      'bsrutnzon': zoneNumber,
      'bsrutfcor': cutDate.toIso8601String(),
      'bsrutcper': affectedUsers,
      'bsrutstat': status,
      'bsrutride': referenceId,
      'dNomb': technicianName,
      'GbzonNzon': zoneId,
      'dNzon': zoneName,
    };
  }

  @override
  String toString() {
    return 'WaterServiceCutRoute{routeId: $routeId, description: $description, zone: $zoneName, cutDate: $cutDate, technician: $technicianName}';
  }
}
