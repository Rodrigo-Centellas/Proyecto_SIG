class DataGoogleRuta {
  final int distanciaMetros;
  final String duracion;
  final String codigoRuta;

  DataGoogleRuta({
    required this.distanciaMetros,
    required this.duracion,
    required this.codigoRuta,
  });

  factory DataGoogleRuta.fromJson(Map<String, dynamic> json) {
    return DataGoogleRuta(
      distanciaMetros: json['routes'][0]['distanceMeters'] ?? 0,
      duracion: json['routes'][0]['duration'] ?? '',
      codigoRuta: json['routes'][0]['polyline']['encodedPolyline'] ?? '',
    );
  }
}
