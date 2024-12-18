// Definición de la clase para manejar la información de rutas realizadas
class InfoRutaRealizada {
  final String numeroRuta; // Número identificador de la ruta
  final String estado; // Estado de la ruta (Completado, En Progreso, Cancelado)
  final int cortesCompletados; // Número de cortes completados
  final int cortesTotales; // Número total de cortes planificados
  final int tiempoTotal; // Tiempo total en minutos
  final double distanciaTotal; // Distancia total en kilómetros
  final String horaInicio; // Hora de inicio
  final String horaFin; // Hora de finalización
  final String horaObjetivo; // Hora objetivo de finalización
  final String zona; // Zona de la ciudad
  final String observaciones; // Observaciones adicionales
  final double progreso; // Progreso de la ruta (0.0 a 1.0)

  InfoRutaRealizada({
    required this.numeroRuta,
    required this.estado,
    required this.cortesCompletados,
    required this.cortesTotales,
    required this.tiempoTotal,
    required this.distanciaTotal,
    required this.horaInicio,
    required this.horaFin,
    required this.horaObjetivo,
    required this.zona,
    required this.observaciones,
    required this.progreso,
  });
}

// Lista de ejemplos con datos realistas de Santa Cruz
final List<InfoRutaRealizada> rutasRealizadas = [
  InfoRutaRealizada(
    numeroRuta: "R001",
    estado: "Completado",
    cortesCompletados: 8,
    cortesTotales: 8,
    tiempoTotal: 180, // 3 horas
    distanciaTotal: 12.5,
    horaInicio: "08:00",
    horaFin: "11:00",
    horaObjetivo: "12:00",
    zona: "Plan 3000 - UV 128-129",
    observaciones:
        "Ruta completada sin inconvenientes. Tráfico moderado en Av. Che Guevara",
    progreso: 1.0,
  ),
  InfoRutaRealizada(
    numeroRuta: "R002",
    estado: "Completado",
    cortesCompletados: 6,
    cortesTotales: 6,
    tiempoTotal: 150, // 2.5 horas
    distanciaTotal: 8.3,
    horaInicio: "14:00",
    horaFin: "16:30",
    horaObjetivo: "17:00",
    zona: "Villa 1ro de Mayo - UV 82-83",
    observaciones: "Zona residencial, acceso fácil a medidores",
    progreso: 1.0,
  ),
  InfoRutaRealizada(
    numeroRuta: "R003",
    estado: "En Progreso",
    cortesCompletados: 4,
    cortesTotales: 7,
    tiempoTotal: 90, // 1.5 horas hasta ahora
    distanciaTotal: 5.8,
    horaInicio: "09:30",
    horaFin: "11:00",
    horaObjetivo: "12:30",
    zona: "Av. Banzer - 3er Anillo",
    observaciones:
        "Zona comercial con alto tráfico. Demoras por verificación en negocios",
    progreso: 0.57,
  ),
  InfoRutaRealizada(
    numeroRuta: "R004",
    estado: "Cancelado",
    cortesCompletados: 3,
    cortesTotales: 8,
    tiempoTotal: 75,
    distanciaTotal: 4.2,
    horaInicio: "10:00",
    horaFin: "11:15",
    horaObjetivo: "13:00",
    zona: "Pampa de la Isla - UV 146",
    observaciones: "Ruta cancelada por lluvia intensa. Calles inundadas",
    progreso: 0.375,
  ),
  InfoRutaRealizada(
    numeroRuta: "R005",
    estado: "Completado",
    cortesCompletados: 5,
    cortesTotales: 5,
    tiempoTotal: 135, // 2.25 horas
    distanciaTotal: 7.8,
    horaInicio: "15:00",
    horaFin: "17:15",
    horaObjetivo: "18:00",
    zona: "Los Lotes - UV 233-234",
    observaciones: "Completado antes de tiempo. Buena accesibilidad",
    progreso: 1.0,
  ),
  InfoRutaRealizada(
    numeroRuta: "R006",
    estado: "En Progreso",
    cortesCompletados: 5,
    cortesTotales: 9,
    tiempoTotal: 120,
    distanciaTotal: 6.4,
    horaInicio: "08:30",
    horaFin: "10:30",
    horaObjetivo: "12:30",
    zona: "Santos Dumont - 4to Anillo",
    observaciones:
        "Zona con alta densidad de comercios. Verificaciones adicionales requeridas",
    progreso: 0.55,
  ),
  InfoRutaRealizada(
    numeroRuta: "R007",
    estado: "Completado",
    cortesCompletados: 7,
    cortesTotales: 7,
    tiempoTotal: 165, // 2.75 horas
    distanciaTotal: 9.2,
    horaInicio: "14:30",
    horaFin: "17:15",
    horaObjetivo: "18:00",
    zona: "Satélite Norte - UV 15-16",
    observaciones: "Ruta residencial completada. Buena colaboración de vecinos",
    progreso: 1.0,
  ),
];
