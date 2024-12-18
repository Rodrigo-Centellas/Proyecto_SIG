class CorteRealizoTiempo {
  final String horaInicio; // "09:15"
  final String horaLocalizacion; // "09:25"
  final String horaCorte; // "09:45"
  final String horaRegistro; // "10:00"
  final int tiempoTotal; // 45 (en minutos)
  final String estado; // "Completado"
  final String observaciones; // "Corte realizado correctamente sin incidencias"
  // final InfoCorte infoCorte;

  CorteRealizoTiempo({
    required this.horaInicio,
    required this.horaLocalizacion,
    required this.horaCorte,
    required this.horaRegistro,
    required this.tiempoTotal,
    required this.estado,
    required this.observaciones,
    // required this.infoCorte,
  });

  // Método para crear desde un Map (útil si los datos vienen de una API o base de datos)
  factory CorteRealizoTiempo.fromMap(Map<String, dynamic> map) {
    return CorteRealizoTiempo(
      horaInicio: map['horaInicio'] ?? '',
      horaLocalizacion: map['horaLocalizacion'] ?? '',
      horaCorte: map['horaCorte'] ?? '',
      horaRegistro: map['horaRegistro'] ?? '',
      tiempoTotal: map['tiempoTotal'] ?? 0,
      estado: map['estado'] ?? '',
      observaciones: map['observaciones'] ?? '',
      // infoCorte: InfoCorte.fromMap(map['infoCorte']),
    );
  }

  // Método para convertir a Map (útil para almacenamiento o envío a API)
  Map<String, dynamic> toMap() {
    return {
      'horaInicio': horaInicio,
      'horaLocalizacion': horaLocalizacion,
      'horaCorte': horaCorte,
      'horaRegistro': horaRegistro,
      'tiempoTotal': tiempoTotal,
      'estado': estado,
      'observaciones': observaciones,
      // 'infoCorte': infoCorte.toMap(),
    };
  }
}

final List<CorteRealizoTiempo> corteData = [
  CorteRealizoTiempo(
    horaInicio: "08:15",
    horaLocalizacion: "08:30",
    horaCorte: "08:45",
    horaRegistro: "09:00",
    tiempoTotal: 45,
    estado: "Completado",
    observaciones:
        "Barrio Villa 1ro de Mayo, UV-52, Mz-12. Cliente ausente, medidor en exterior.",
  ),
  CorteRealizoTiempo(
    horaInicio: "09:15",
    horaLocalizacion: "09:40",
    horaCorte: "10:00",
    horaRegistro: "10:15",
    tiempoTotal: 60,
    estado: "Completado",
    observaciones:
        "Av. Banzer 3er anillo, edificio Torres del Sol. Acceso demorado por guardia.",
  ),
  CorteRealizoTiempo(
    horaInicio: "10:30",
    horaLocalizacion: "10:45",
    horaCorte: "11:05",
    horaRegistro: "11:20",
    tiempoTotal: 50,
    estado: "Completado",
    observaciones:
        "Barrio Los Mangales, calle Los Tajibos. Medidor con difícil acceso.",
  ),
  CorteRealizoTiempo(
    horaInicio: "11:30",
    horaLocalizacion: "11:45",
    horaCorte: "12:00",
    horaRegistro: "12:15",
    tiempoTotal: 45,
    estado: "Completado",
    observaciones: "Plan 3000, UV-128. Cliente presente, sin inconvenientes.",
  ),
  CorteRealizoTiempo(
    horaInicio: "14:00",
    horaLocalizacion: "14:20",
    horaCorte: "14:40",
    horaRegistro: "15:00",
    tiempoTotal: 60,
    estado: "Completado",
    observaciones:
        "Av. Paraguá, Condominio Las Palmas. Coordinación con administración.",
  ),
  CorteRealizoTiempo(
    horaInicio: "15:15",
    horaLocalizacion: "15:35",
    horaCorte: "15:55",
    horaRegistro: "16:10",
    tiempoTotal: 55,
    estado: "Completado",
    observaciones:
        "Barrio Equipetrol Norte, calle Las Begonias. Medidor en buen estado.",
  ),
  CorteRealizoTiempo(
    horaInicio: "16:30",
    horaLocalizacion: "16:50",
    horaCorte: "17:10",
    horaRegistro: "17:25",
    tiempoTotal: 55,
    estado: "Completado",
    observaciones:
        "Urb. Las Palmas, UV-42. Cliente solicitó prórroga, se procedió según protocolo.",
  ),
  CorteRealizoTiempo(
    horaInicio: "08:00",
    horaLocalizacion: "08:20",
    horaCorte: "08:40",
    horaRegistro: "09:00",
    tiempoTotal: 60,
    estado: "Completado",
    observaciones:
        "Av. Cristo Redentor, 4to anillo. Local comercial, corte temprano.",
  ),
  CorteRealizoTiempo(
    horaInicio: "09:15",
    horaLocalizacion: "09:35",
    horaCorte: "09:55",
    horaRegistro: "10:10",
    tiempoTotal: 55,
    estado: "Completado",
    observaciones:
        "Barrio Sirari, calle Los Pitones. Medidor en interior, cliente facilitó acceso.",
  ),
  CorteRealizoTiempo(
    horaInicio: "10:30",
    horaLocalizacion: "10:50",
    horaCorte: "11:10",
    horaRegistro: "11:30",
    tiempoTotal: 60,
    estado: "Completado",
    observaciones:
        "Ciudadela Andrés Ibáñez, UV-85. Zona de difícil acceso por lluvia.",
  ),
  CorteRealizoTiempo(
    horaInicio: "11:45",
    horaLocalizacion: "12:00",
    horaCorte: "12:20",
    horaRegistro: "12:35",
    tiempoTotal: 50,
    estado: "Completado",
    observaciones:
        "Barrio El Remanso, calle Los Tusequis. Procedimiento estándar.",
  ),
  CorteRealizoTiempo(
    horaInicio: "14:30",
    horaLocalizacion: "14:45",
    horaCorte: "15:05",
    horaRegistro: "15:20",
    tiempoTotal: 50,
    estado: "Completado",
    observaciones: "Av. Alemana, 3er anillo. Zona comercial, alta afluencia.",
  ),
  CorteRealizoTiempo(
    horaInicio: "15:30",
    horaLocalizacion: "15:50",
    horaCorte: "16:10",
    horaRegistro: "16:25",
    tiempoTotal: 55,
    estado: "Completado",
    observaciones:
        "Barrio Santa Rosita, UV-156. Cliente ausente, se dejó notificación.",
  ),
  CorteRealizoTiempo(
    horaInicio: "16:40",
    horaLocalizacion: "17:00",
    horaCorte: "17:20",
    horaRegistro: "17:35",
    tiempoTotal: 55,
    estado: "Completado",
    observaciones:
        "Urb. El Paraíso, Radial 10. Medidor en buen estado, sin complicaciones.",
  ),
  CorteRealizoTiempo(
    horaInicio: "17:45",
    horaLocalizacion: "18:00",
    horaCorte: "18:20",
    horaRegistro: "18:35",
    tiempoTotal: 50,
    estado: "Completado",
    observaciones:
        "Av. Santos Dumont, 6to anillo. Último servicio del día, zona residencial.",
  ),
];
