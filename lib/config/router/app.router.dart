import 'package:go_router/go_router.dart';
import 'package:proyecto_sig/features/home/presentation/screens/detalle-corte.screen.dart';
import 'package:proyecto_sig/features/home/presentation/screens/home.screen.dart';
import 'package:proyecto_sig/features/home/presentation/screens/info-cortes.screen.dart';
import 'package:proyecto_sig/features/home/presentation/screens/lista-rutas.screen.dart';
import 'package:proyecto_sig/features/home/presentation/screens/map-loading.screen.dart';
import 'package:proyecto_sig/features/home/presentation/screens/map.screen.dart';

final appRouter = GoRouter(initialLocation: '/', routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const HomeScreen(),
  ),
  GoRoute(
    path: '/map',
    builder: (context, state) => const MapGoogleScreen(),
  ),
  GoRoute(
    path: '/view-reporte',
    builder: (context, state) => const DetalleCorteScreen(),
  ),
  GoRoute(
    path: '/multiples-rutas',
    builder: (context, state) => const ListaRutasScreen(),
  ),
  GoRoute(
    path: '/list-reportes',
    builder: (context, state) => const CortesDashboardScreen(),
  ),
  GoRoute(
    path: '/map-loading',
    builder: (context, state) => const MapLoading(),
  ),
]);
