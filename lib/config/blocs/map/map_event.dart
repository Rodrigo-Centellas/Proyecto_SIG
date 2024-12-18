part of 'map_bloc.dart';

class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object> get props => [];
}

class OnMapInitContent extends MapEvent {
  final BuildContext context;

  const OnMapInitContent(this.context);
}

class OnGoogleMapController extends MapEvent {
  final GoogleMapController controller;
  const OnGoogleMapController(this.controller);
}

class OnCameraPosition extends MapEvent {
  final CameraPosition cameraPosition;
  const OnCameraPosition(this.cameraPosition);
}

class GpsAndPermissionEvent extends MapEvent {
  final bool isGpsEnabled;
  final bool isPermissionGranted;

  const GpsAndPermissionEvent(
      {required this.isGpsEnabled, required this.isPermissionGranted});
}

class OnChangeDetailMapGoogle extends MapEvent {
  final DetailMapGoogle detail;

  const OnChangeDetailMapGoogle(this.detail);
}

class OnGenerarRuta extends MapEvent {
  final BuildContext context;
  const OnGenerarRuta(this.context);
}

class OnCleanBlocMapGoogle extends MapEvent {
  const OnCleanBlocMapGoogle();
}

class OnChangedWorkMapType extends MapEvent {
  const OnChangedWorkMapType();
}

class OnChangedTypeMovilidad extends MapEvent {
  final TypeMovilidad data;
  const OnChangedTypeMovilidad(this.data);
}

class OnChangedInitRuta extends MapEvent {
  final InitRuta data;
  const OnChangedInitRuta(this.data);
}

class OnEditPuntoCorteRutaTrabajo extends MapEvent {
  final InfoCorte infoCorte;
  final String estado;
  final BuildContext context;
  const OnEditPuntoCorteRutaTrabajo(this.infoCorte, this.estado, this.context);
}

class OnGoNavigationMarcador extends MapEvent {
  const OnGoNavigationMarcador();
}

class OnResetNavigationMarcador extends MapEvent {
  const OnResetNavigationMarcador();
}

class OnChangedDataGoogleRuta extends MapEvent {
  final DataGoogleRuta dataGoogleRuta;
  const OnChangedDataGoogleRuta(this.dataGoogleRuta);
}
