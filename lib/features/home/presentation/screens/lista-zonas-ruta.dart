import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_sig/config/blocs/auth/auth_bloc.dart';
import 'package:proyecto_sig/config/blocs/map/map_bloc.dart';
import 'package:proyecto_sig/config/constant/const.dart';
import 'package:proyecto_sig/features/home/domain/entities/infoRuta.entitie.dart';

class ListRutasSoloScreen extends StatefulWidget {
  const ListRutasSoloScreen({super.key});

  @override
  State<ListRutasSoloScreen> createState() => _ListRutasSoloScreenState();
}

class _ListRutasSoloScreenState extends State<ListRutasSoloScreen> {
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
    final size = MediaQuery.of(context).size;

    Future<void> handleRouteSelection(
        BuildContext context, InfoRuta route) async {
      authBloc.add(OnChangedInfoRuta(route, context));
      final currentContext = context;
      if (!currentContext.mounted) return;
      await authBlocSubscription?.cancel();
      authBlocSubscription = authBloc.stream.listen((state) {
        if (currentContext.mounted && state.infoRuta != null) {
          mapBloc.add(OnMapInitContent(currentContext));
          authBlocSubscription?.cancel();
          authBlocSubscription = null;
        }
      });
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.02,
      ),
      itemCount: authBloc.state.infoRutas.length,
      itemBuilder: (context, index) {
        final route = authBloc.state.infoRutas[index];
        final isSelected = route.routeId == selectedRouteId;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.only(bottom: size.height * 0.02),
          decoration: BoxDecoration(
            color: isSelected ? kPrimaryColor : kSecondaryColor,
            borderRadius: BorderRadius.circular(size.width * 0.03),
            border: Border.all(
              color: kPrimaryColor.withOpacity(isSelected ? 1 : 0.1),
              width: 1,
            ),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(size.width * 0.03),
              ),
              backgroundColor: Colors.transparent,
              collapsedBackgroundColor: Colors.transparent,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(size.width * 0.02),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? kSecondaryColor.withOpacity(0.1)
                              : kPrimaryColor.withOpacity(0.05),
                          borderRadius:
                              BorderRadius.circular(size.width * 0.015),
                        ),
                      ),
                      SizedBox(width: size.width * 0.03),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              route.description,
                              style: GoogleFonts.inter(
                                fontSize: size.width * 0.04,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? kSecondaryColor
                                    : kPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: IconButton(
                icon: AnimatedRotation(
                  duration: const Duration(milliseconds: 300),
                  turns: isSelected ? 1 : 0,
                  child: Icon(
                    Icons.maps_home_work_outlined,
                    color: isSelected ? kSecondaryColor : kPrimaryColor,
                    size: size.width * 0.06,
                  ),
                ),
                onPressed: () async {
                  if (!isSelected) {
                    await handleRouteSelection(context, route);
                  }
                },
              ),
              children: [
                Container(
                  padding: EdgeInsets.all(size.width * 0.04),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatusChip(
                        'Zone ${route.zoneNumber}',
                        Icons.location_on_outlined,
                        size,
                        isSelected,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(
    String label,
    IconData icon,
    Size size,
    bool isSelected,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.03,
        vertical: size.width * 0.02,
      ),
      decoration: BoxDecoration(
        color: isSelected
            ? kSecondaryColor.withOpacity(0.1)
            : kPrimaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(size.width * 0.02),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: size.width * 0.04,
            color: isSelected ? kSecondaryColor : kPrimaryColor,
          ),
          SizedBox(width: size.width * 0.02),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: size.width * 0.035,
              color: isSelected ? kSecondaryColor : kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
