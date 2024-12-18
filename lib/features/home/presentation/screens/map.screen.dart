import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:proyecto_sig/config/blocs/auth/auth_bloc.dart';
import 'package:proyecto_sig/config/blocs/location/location_bloc.dart';
import 'package:proyecto_sig/config/blocs/map/map_bloc.dart';
import 'package:proyecto_sig/features/home/presentation/screens/map-loading.screen.dart';
import 'package:proyecto_sig/features/home/presentation/widgets/map-view.dart';

const kPrimaryColor = Colors.white;
const kSecondaryColor = Colors.black;

class MapGoogleScreen extends StatefulWidget {
  const MapGoogleScreen({super.key});

  @override
  State<MapGoogleScreen> createState() => _MapGoogleScreenState();
}

class _MapGoogleScreenState extends State<MapGoogleScreen> {
  late MapBloc _mapBloc;
  late AuthBloc _authBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mapBloc = BlocProvider.of<MapBloc>(context);
    _authBloc = BlocProvider.of<AuthBloc>(context);
  }

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  @override
  void dispose() {
    _mapBloc.add(const OnCleanBlocMapGoogle());
    _authBloc.add(const OnCleanBlocAuth());
    super.dispose();
  }

  Future<void> _initLocation() async {
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final authBloc = BlocProvider.of<AuthBloc>(context);
    await locationBloc.getActualPosition();
    if (!mounted) return;
    authBloc.add(OnProcessInfoRutas(context));
    authBloc.add(OnProcessInfoCortes(tipoCorte: 73, context: context));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, locationState) {
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (locationState.lastKnownLocation == null ||
                authState.infoRutas.isEmpty ||
                authState.infoCortes.isEmpty) {
              return const MapLoading();
            }

            return Stack(
              children: [
                BlocListener<MapBloc, MapState>(
                  listener: (context, state) {
                    if (state.urlAppMarcador != "") {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        context.push('/view-reporte');
                        BlocProvider.of<MapBloc>(context)
                            .add(const OnResetNavigationMarcador());
                      });
                    }
                  },
                  child: BlocBuilder<MapBloc, MapState>(
                    builder: (context, mapState) {
                      return MapViewGoogleMap(
                        initialLocation: const LatLng(
                            -16.379681784255467, -60.96071984288463),
                        polygons: mapState.polygons.values.toSet(),
                        polylines: mapState.polylines.values.toSet(),
                        markers: mapState.markers.values.toSet(),
                      );
                    },
                  ),
                ),
                _CustomMapControls(size: size),
              ],
            );
          },
        );
      },
    );
  }
}

class _CustomMapControls extends StatelessWidget {
  final Size size;

  const _CustomMapControls({required this.size});

  @override
  Widget build(BuildContext context) {
    final mapBloc = BlocProvider.of<MapBloc>(context, listen: true);
    final authBloc = BlocProvider.of<AuthBloc>(context, listen: true);
    return Positioned(
      bottom: size.height * 0.01,
      right: size.width * 0.02,
      child: Container(
        decoration: BoxDecoration(
          color: kSecondaryColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(size.width * 0.03),
          boxShadow: [
            BoxShadow(
              color: kSecondaryColor.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: EdgeInsets.all(size.width * 0.015),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (authBloc.state.trabajandoRuta)
              _MapControlButton(
                icon: FontAwesomeIcons.message,
                onPressed: () {
                  showRouteStatusDialog(context);
                },
                tooltip: 'Current Location',
                size: size,
              ),
            SizedBox(height: size.height * 0.01),
            _MapControlButton(
              icon: FontAwesomeIcons.locationDot,
              onPressed: () async {
                await mapBloc.restoreNormalView();
              },
              tooltip: 'Current Location',
              size: size,
            ),
            SizedBox(height: size.height * 0.01),
            _MapControlButton(
              icon: FontAwesomeIcons.clipboardList,
              onPressed: () => context.push("/list-reportes"),
              tooltip: 'View Reports',
              size: size,
            ),
            SizedBox(height: size.height * 0.01),
            _MapControlButton(
              icon: FontAwesomeIcons.streetView,
              onPressed: () async {
                await mapBloc.moveToHorizonView();
              },
              tooltip: 'Street View',
              size: size,
            ),
          ],
        ),
      ),
    );
  }
}

class _MapControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;
  final Size size;

  const _MapControlButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      textStyle: TextStyle(
        color: kSecondaryColor,
        fontSize: size.width * 0.03,
      ),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(size.width * 0.01),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(size.width * 0.02),
          child: Container(
            padding: EdgeInsets.all(size.width * 0.03),
            child: Icon(
              icon,
              color: kPrimaryColor,
              size: size.width * 0.055,
            ),
          ),
        ),
      ),
    );
  }
}

class MapAction {
  final IconData icon;
  final VoidCallback onPressed;

  const MapAction({
    required this.icon,
    required this.onPressed,
  });
}

class DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0, size.height)
      ..lineTo(size.width - 40, size.height)
      ..lineTo(size.width, size.height - 40)
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

void showRouteStatusDialog(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final size = MediaQuery.of(context).size;
        final authBloc = BlocProvider.of<AuthBloc>(context, listen: true);
        final mapBloc = BlocProvider.of<MapBloc>(context, listen: true);

        final totalPoints = authBloc.state.rutaTrabajo?.length ?? 9;
        final completedPoints = authBloc.state.rutaTrabajoAux?.length ?? 0;
        final distanciaMetros =
            mapBloc.state.dataGoogleRuta?.distanciaMetros ?? 1000;

        // Cálculos detallados
        final kilometros = (distanciaMetros / 1000).floor();
        final metros = (distanciaMetros % 1000).round();
        final tiempoBase = ((distanciaMetros / 1000) / 15);
        final tiempoPuntos = (9 * 10) / 60;
        final tiempoTotal = tiempoBase + tiempoPuntos;
        final horas = tiempoTotal.floor();
        final minutos = ((tiempoTotal - horas) * 60).floor();
        final segundos = (((tiempoTotal - horas) * 60 - minutos) * 60).round();

        return Center(
          child: SingleChildScrollView(
            child: Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              child: Container(
                width: size.width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(size.width * 0.04),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    ClipPath(
                      clipper: DiagonalClipper(),
                      child: Container(
                        height: size.height * 0.12,
                        width: double.infinity,
                        color: Colors.black,
                        child: Stack(
                          children: [
                            Positioned(
                              right: size.width * 0.05,
                              bottom: size.width * 0.05,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '$completedPoints/$totalPoints',
                                    style: GoogleFonts.rajdhani(
                                      fontSize: size.width * 0.08,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: size.width * 0.02),
                                  Icon(
                                    Icons.route,
                                    color: Colors.white,
                                    size: size.width * 0.07,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Content
                    Padding(
                      padding: EdgeInsets.all(size.width * 0.05),
                      child: Column(
                        children: [
                          _buildMetricTile(
                            context: context,
                            icon: Icons.straighten,
                            title: 'Distancia Total',
                            value: '$kilometros,$metros',
                            unit: 'km',
                          ),
                          _buildMetricTile(
                            context: context,
                            icon: Icons.timer_outlined,
                            title: 'Tiempo Estimado',
                            value:
                                '${horas}:${minutos.toString().padLeft(2, '0')}',
                            unit: 'h',
                            subtitle: '${segundos}s',
                          ),

                          Divider(
                            color: Colors.black12,
                            thickness: size.width * 0.002,
                          ),

                          // Stats row
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: size.width * 0.03),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildSmallMetric(
                                    context: context,
                                    label: 'Velocidad',
                                    value: '15',
                                    unit: 'km/h',
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: size.width * 0.1,
                                  color: Colors.black12,
                                ),
                                Expanded(
                                  child: _buildSmallMetric(
                                    context: context,
                                    label: 'T. por Punto',
                                    value: '10',
                                    unit: 'min',
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: size.width * 0.05),

                          // Buttons
                          Row(
                            children: [
                              Expanded(
                                child: _buildButton(
                                  context: context,
                                  icon: Icons.visibility_off,
                                  label: 'Cerrar Modal',
                                  onTap: () {
                                    mapBloc.add(const OnChangedWorkMapType());
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              SizedBox(width: size.width * 0.03),
                              Expanded(
                                child: _buildButton(
                                  context: context,
                                  icon: Icons.check_circle_outline,
                                  label: 'Terminar Ruta',
                                  isPrimary: true,
                                  onTap: () {
                                    mapBloc.add(OnMapInitContent(context));
                                    authBloc.add(const OnCleanBlocAuth());
                                    mapBloc.add(const OnChangedWorkMapType());
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
}

Widget _buildMetricTile({
  required BuildContext context,
  required IconData icon,
  required String title,
  required String value,
  required String unit,
  String? subtitle,
}) {
  final size = MediaQuery.of(context).size;

  return Padding(
    padding: EdgeInsets.symmetric(vertical: size.width * 0.02),
    child: Row(
      children: [
        Container(
          padding: EdgeInsets.all(size.width * 0.02),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: size.width * 0.05),
        ),
        SizedBox(width: size.width * 0.04),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: size.width * 0.03,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value,
                    style: GoogleFonts.rajdhani(
                      fontSize: size.width * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: size.width * 0.01),
                  Text(
                    unit,
                    style: TextStyle(
                      fontSize: size.width * 0.035,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(width: size.width * 0.01),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: size.width * 0.03,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildSmallMetric({
  required BuildContext context,
  required String label,
  required String value,
  required String unit,
}) {
  final size = MediaQuery.of(context).size;

  return Column(
    children: [
      Text(
        label,
        style: TextStyle(
          color: Colors.black54,
          fontSize: size.width * 0.03,
        ),
      ),
      SizedBox(height: size.width * 0.01),
      RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black),
          children: [
            TextSpan(
              text: value,
              style: GoogleFonts.rajdhani(
                fontSize: size.width * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: ' $unit',
              style: TextStyle(
                fontSize: size.width * 0.03,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _buildButton({
  required BuildContext context,
  required IconData icon,
  required String label,
  required VoidCallback onTap,
  bool isPrimary = false,
}) {
  final size = MediaQuery.of(context).size;

  return Material(
    color: isPrimary ? Colors.black : Colors.white,
    borderRadius: BorderRadius.circular(size.width * 0.02),
    child: InkWell(
      borderRadius: BorderRadius.circular(size.width * 0.02),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: size.width * 0.03),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: isPrimary ? 0 : 1,
          ),
          borderRadius: BorderRadius.circular(size.width * 0.02),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isPrimary ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: size.width * 0.035,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
