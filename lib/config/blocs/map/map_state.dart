part of 'map_bloc.dart';

enum DetailMapGoogle { hybrid, none, normal, satellite, terrain }

enum TypeMovilidad { moto, auto, caminar, bicicleta }

enum RutaAlternativa { none, yes }

enum InitRuta { none, oficina, posicion }

enum WorkMapType { inspeccionRuta, none }

class MapState extends Equatable {
  // LOGIC : Control del zoom
  final double statusZoom;

  final bool processMap;
  final bool isMapInitialized;
  final bool followUser;

  Map<String, Marker> markers;
  Map<String, Polyline> polylines;
  Map<String, Polygon> polygons;

  // LOGIC : CONTROL DE MAPA
  final DetailMapGoogle detailMapGoogle;
  final TypeMovilidad typeMovilidad;
  final InitRuta initRuta;
  final String urlAppMarcador;

  // LOGIC : CONTROL TIPO MAPA TRABAJO
  final WorkMapType workMapType;

  // READ  : PERMISOS PARA LA APLICACION
  // LOGIC : GPS ESTADO
  final bool isGpsEnabled;
  // LOGIC : PERMISOS DEL GPS
  final bool isGpsPermissionGranted;
  // READ : ANALIZIS DE RUTA CREADA DE TRABAJO
  // LOGIC : DATOS DE GOOGLE RUTA
  DataGoogleRuta? dataGoogleRuta;

  MapState(
      {this.isGpsEnabled = false,
      this.urlAppMarcador = '',
      this.isGpsPermissionGranted = false,
      this.statusZoom = 17,
      this.processMap = true,
      this.isMapInitialized = false,
      this.followUser = false,
      Map<String, Marker>? markers,
      Map<String, Polyline>? polylines,
      Map<String, Polygon>? polygons,
      this.workMapType = WorkMapType.none,
      this.detailMapGoogle = DetailMapGoogle.normal,
      this.initRuta = InitRuta.oficina,
      this.typeMovilidad = TypeMovilidad.moto,
      this.dataGoogleRuta})
      : markers = markers ?? const {},
        polylines = polylines ?? const {},
        polygons = polygons ?? const {};

  MapState copyWith({
    bool? isGpsEnabled,
    String? urlAppMarcador,
    bool? isGpsPermissionGranted,
    double? statusZoom,
    bool? processMap,
    bool? isMapInitialized,
    bool? followUser,
    Map<String, Marker>? markers,
    Map<String, Polyline>? polylines,
    Map<String, Polygon>? polygons,
    DetailMapGoogle? detailMapGoogle,
    WorkMapType? workMapType,
    TypeMovilidad? typeMovilidad,
    InitRuta? initRuta,
    DataGoogleRuta? dataGoogleRuta,
  }) {
    return MapState(
      urlAppMarcador: urlAppMarcador ?? this.urlAppMarcador,
      isGpsEnabled: isGpsEnabled ?? this.isGpsEnabled,
      isGpsPermissionGranted:
          isGpsPermissionGranted ?? this.isGpsPermissionGranted,
      statusZoom: statusZoom ?? this.statusZoom,
      processMap: processMap ?? this.processMap,
      isMapInitialized: isMapInitialized ?? this.isMapInitialized,
      followUser: followUser ?? this.followUser,
      markers: markers ?? this.markers,
      polylines: polylines ?? this.polylines,
      polygons: polygons ?? this.polygons,
      detailMapGoogle: detailMapGoogle ?? this.detailMapGoogle,
      workMapType: workMapType ?? this.workMapType,
      typeMovilidad: typeMovilidad ?? this.typeMovilidad,
      initRuta: initRuta ?? this.initRuta,
      dataGoogleRuta: dataGoogleRuta ?? this.dataGoogleRuta,
    );
  }

  @override
  List<Object?> get props => [
        isGpsEnabled,
        urlAppMarcador,
        isGpsPermissionGranted,
        statusZoom,
        processMap,
        isMapInitialized,
        followUser,
        markers,
        polylines,
        polygons,
        detailMapGoogle,
        workMapType,
        typeMovilidad,
        initRuta,
        urlAppMarcador,
        dataGoogleRuta,
      ];
}
