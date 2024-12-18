class InfoCorte {
  /// Número de orden de corte del servicio
  final int bscocNcoc;

  /// Código fiscal o código de finca del inmueble
  final int bscntCodf;

  /// Número de cuenta del cliente
  final int bscocNcnt;

  /// Nombre completo del cliente/usuario
  final String dNomb;

  /// Cantidad de meses que el cliente está atrasado en sus pagos
  final int bscocNmor;

  /// Monto total adeudado por el cliente
  final double bscocImor;

  /// Número de serie del medidor de agua
  final String bsmednser;

  /// Número identificador del medidor
  final String bsmedNume;

  /// Coordenada de latitud de la ubicación del medidor
  final double bscntlati;

  /// Coordenada de longitud de la ubicación del medidor
  final double bscntlogi;

  /// Categoría del servicio (ej: "Domestica")
  final String dNcat;

  /// Observaciones sobre el estado del corte
  final String dCobc;

  /// Dirección física del inmueble (UV, Manzano, Lote)
  final String dLotes;

  InfoCorte({
    required this.bscocNcoc,
    required this.bscntCodf,
    required this.bscocNcnt,
    required this.dNomb,
    required this.bscocNmor,
    required this.bscocImor,
    required this.bsmednser,
    required this.bsmedNume,
    required this.bscntlati,
    required this.bscntlogi,
    required this.dNcat,
    required this.dCobc,
    required this.dLotes,
  });

  // Factory constructor para crear una instancia desde un Map (útil para JSON/XML parsing)
  factory InfoCorte.fromMap(Map<String, dynamic> map) {
    return InfoCorte(
      bscocNcoc: int.parse(map['bscocNcoc'].toString()),
      bscntCodf: int.parse(map['bscntCodf'].toString()),
      bscocNcnt: int.parse(map['bscocNcnt'].toString()),
      dNomb: map['dNomb'].toString(),
      bscocNmor: int.parse(map['bscocNmor'].toString()),
      bscocImor: double.parse(map['bscocImor'].toString()),
      bsmednser: map['bsmednser'].toString().trim(),
      bsmedNume: map['bsmedNume'].toString().trim(),
      bscntlati: double.parse(map['bscntlati'].toString()),
      bscntlogi: double.parse(map['bscntlogi'].toString()),
      dNcat: map['dNcat'].toString().trim(),
      dCobc: map['dCobc'].toString().trim(),
      dLotes: map['dLotes'].toString(),
    );
  }
}
