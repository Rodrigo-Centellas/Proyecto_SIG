import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_sig/config/blocs/auth/auth_bloc.dart';
import 'package:proyecto_sig/config/blocs/map/map_bloc.dart';
import 'package:proyecto_sig/config/constant/const.dart';
import 'package:proyecto_sig/features/home/domain/entities/infoRuta.entitie.dart';

class ListaRutasScreen extends StatefulWidget {
  const ListaRutasScreen({
    super.key,
  });

  @override
  State<ListaRutasScreen> createState() => _ListaRutasScreenState();
}

class _ListaRutasScreenState extends State<ListaRutasScreen> {
  StreamSubscription? authBlocSubscription;

  @override
  void dispose() {
    authBlocSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context, listen: true);
    final mapBloc = BlocProvider.of<MapBloc>(context, listen: false);
    final selectedRouteId = authBloc.state.infoRuta!.routeId;

    Future<void> handleRouteSelection(
        BuildContext context, InfoRuta route) async {
      authBloc.add(OnChangedInfoRuta(route, context));
      // Capturar el contexto antes de la operación asíncrona
      final currentContext = context;

      // Verificar si el widget está montado antes de continuar
      if (!currentContext.mounted) return;

      // Cancelar la suscripción anterior si existe
      await authBlocSubscription?.cancel();

      // Crear una nueva suscripción
      authBlocSubscription = authBloc.stream.listen((state) {
        // Verificar si el widget sigue montado antes de usar el contexto
        if (currentContext.mounted && state.infoRuta != null) {
          // Usar el contexto capturado
          mapBloc.add(OnMapInitContent(currentContext));
          // Limpiar la suscripción
          authBlocSubscription?.cancel();
          authBlocSubscription = null;
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.arrowLeft,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'RUTAS DE CORTE',
          style: letterStyle.letra4Mapa.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Indicador de ruta activa
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: size.width * 0.04,
              vertical: size.width * 0.02,
            ),
            padding: EdgeInsets.all(size.width * 0.03),
            decoration: BoxDecoration(
              color: kQuintaColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(size.width * 0.02),
              border: Border.all(color: kQuintaColor),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: kQuintaColor),
                SizedBox(width: size.width * 0.02),
                Expanded(
                  child: Text(
                    'Ruta activa: ${authBloc.state.infoRuta!.description}',
                    style: TextStyle(
                      color: kQuintaColor,
                      fontWeight: FontWeight.bold,
                      fontSize: size.width * 0.04,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          Container(
            margin: EdgeInsets.all(size.width * 0.04),
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.04,
              vertical: size.width * 0.02,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(size.width * 0.03),
              boxShadow: [
                BoxShadow(
                  color: kPrimaryColor.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.magnifyingGlass,
                  color: kCuartoColor,
                  size: size.width * 0.05,
                ),
                SizedBox(width: size.width * 0.03),
                Expanded(
                  child: TextField(
                    style: letterStyle.letraInput.copyWith(
                      fontSize: size.width * 0.04,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Buscar ruta o zona...',
                      hintStyle: letterStyle.placeholderInput,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Routes List
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              itemCount: authBloc.state.infoRutas.length,
              itemBuilder: (context, index) {
                final route = authBloc.state.infoRutas[index];
                final isSelected = route.routeId == selectedRouteId;

                return Container(
                  margin: EdgeInsets.only(bottom: size.width * 0.03),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(size.width * 0.03),
                    border: isSelected
                        ? Border.all(color: kPrimaryColor, width: 2)
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      leading: IconButton(
                        icon: FaIcon(
                          FontAwesomeIcons.mapLocation,
                          color: isSelected ? kQuintaColor : kPrimaryColor,
                          size: size.width * 0.06,
                        ),
                        onPressed: null,
                      ),
                      title: Text(
                        route.description,
                        style: letterStyle.letra1Comunicados.copyWith(
                          fontSize: size.width * 0.045,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? kQuintaColor : Colors.black87,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Zona: ${route.zoneName}',
                            style: letterStyle.letra3Comunicados.copyWith(
                              fontSize: size.width * 0.035,
                              color: kCuartoColor,
                            ),
                          ),
                          Text(
                            'Fecha: ${DateFormat('dd/MM/yyyy').format(route.cutDate)}',
                            style: letterStyle.letra3Comunicados.copyWith(
                              fontSize: size.width * 0.035,
                              color: kCuartoColor,
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: FaIcon(
                          FontAwesomeIcons.database,
                          color: kCuartoColor,
                          size: size.width * 0.06,
                        ),
// En el onPressed del botón
                        onPressed: () async {
                          if (!isSelected) {
                            await handleRouteSelection(context, route);
                          }
                        },
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(size.width * 0.04),
                          child: Column(
                            children: [
                              _buildInfoRow(
                                'Técnico',
                                route.technicianName,
                                FontAwesomeIcons.userGear,
                              ),
                              SizedBox(height: size.width * 0.02),
                              _buildInfoRow(
                                'Usuarios Afectados',
                                route.affectedUsers.toString(),
                                FontAwesomeIcons.users,
                              ),
                              SizedBox(height: size.width * 0.02),
                              _buildInfoRow(
                                'Estado',
                                route.status == 0 ? 'Pendiente' : 'Completado',
                                FontAwesomeIcons.circleInfo,
                                isStatus: true,
                                status: route.status,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon,
      {bool isStatus = false, int status = 0}) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(size.width * 0.02),
          decoration: BoxDecoration(
            color: isStatus
                ? (status == 0 ? Colors.orange : kQuintaColor).withOpacity(0.1)
                : kPrimaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(size.width * 0.02),
          ),
          child: FaIcon(
            icon,
            color: isStatus
                ? (status == 0 ? Colors.orange : kQuintaColor)
                : kPrimaryColor,
            size: size.width * 0.05,
          ),
        ),
        SizedBox(width: size.width * 0.03),
        SizedBox(
          width: size.width * 0.65,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: size.width * 0.035,
                ),
              ),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isStatus
                      ? (status == 0 ? Colors.orange : kQuintaColor)
                      : Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: size.width * 0.04,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
