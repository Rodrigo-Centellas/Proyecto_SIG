import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_sig/config/blocs/auth/auth_bloc.dart';
import 'package:proyecto_sig/config/blocs/map/map_bloc.dart';
import 'package:proyecto_sig/config/constant/colors.const.dart';
import 'package:proyecto_sig/config/constant/dialog.const.dart';
import 'package:proyecto_sig/features/home/presentation/screens/lista-zonas-ruta.dart';
import 'package:proyecto_sig/features/home/presentation/widgets/lista-cortes-general.widget.dart';

class CortesDashboardScreen extends StatelessWidget {
  const CortesDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context, listen: true);
    final mapBloc = BlocProvider.of<MapBloc>(context, listen: true);
    final size = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: kSecondaryColor,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Monitoreo Rutas y Cortes',
                style: GoogleFonts.sora(
                  fontSize: size.width * 0.05,
                  fontWeight: FontWeight.w600,
                  color: kPrimaryColor,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: const Column(
          children: [
            Expanded(
              child: TabBarView(
                children: [CortesListView(), ListRutasSoloScreen()],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          color: Colors.black,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.all(size.width * 0.04),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(size.width * 0.02),
                  border: Border.all(color: kPrimaryColor.withOpacity(0.2)),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(size.width * 0.015),
                  ),
                  labelColor: kSecondaryColor,
                  unselectedLabelColor: kPrimaryColor,
                  labelStyle: GoogleFonts.sora(
                    fontSize: size.width * 0.035,
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: [
                    _buildTab(
                      FontAwesomeIcons.bolt,
                      'Active Zone',
                      size,
                    ),
                    _buildTab(
                      FontAwesomeIcons.locationDot,
                      'Zone',
                      size,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(size.width * 0.04),
                color: kSecondaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      icon: FontAwesomeIcons.arrowLeft,
                      label: 'Back',
                      onPressed: () => Navigator.pop(context),
                      size: size,
                    ),
                    _buildActionButton(
                      icon: FontAwesomeIcons.route,
                      label: 'Generate',
                      onPressed: () {
                        if (authBloc.state.rutaTrabajo.length >= 9) {
                          authBloc.add(const OnChangedTrabajoRuta());
                          authBloc.add(const OnChangeInfoCorteType(
                              InfoCorteType.update));
                          mapBloc.add(OnGenerarRuta(context));
                        } else {
                          DialogService.showErrorSnackBar(
                              message:
                                  "Se requiere al menos 9 cortes para generar una ruta",
                              context: context);
                        }
                      },
                      size: size,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(IconData icon, String text, Size size) {
    return Tab(
      height: size.height * 0.06,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(icon, size: size.width * 0.04),
          SizedBox(height: size.height * 0.005),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Size size,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.04,
          vertical: size.width * 0.02,
        ),
        decoration: BoxDecoration(
          color: kPrimaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(size.width * 0.02),
          border: Border.all(
            color: kPrimaryColor.withOpacity(0.2),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              icon,
              color: kPrimaryColor,
              size: size.width * 0.045,
            ),
            SizedBox(height: size.width * 0.01),
            Text(
              label,
              style: GoogleFonts.sora(
                color: kPrimaryColor,
                fontSize: size.width * 0.03,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
