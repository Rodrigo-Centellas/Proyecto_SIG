import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proyecto_sig/config/blocs/auth/auth_bloc.dart';
import 'package:proyecto_sig/config/constant/colors.const.dart';
import 'package:proyecto_sig/config/constant/dialog.const.dart';
import 'package:proyecto_sig/features/home/domain/entities/infoCorte.entitie.dart';

class CortesListView extends StatelessWidget {
  const CortesListView({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final size = MediaQuery.of(context).size;

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(size.width * 0.04),
      itemCount: authBloc.state.infoCortes.length,
      itemBuilder: (context, index) {
        final corte = authBloc.state.infoCortes[index];
        return Stack(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: size.width * 0.06),
              padding: EdgeInsets.all(size.width * 0.04),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    kSecondaryColor,
                    kSecondaryColor.withOpacity(0.9),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(size.width * 0.05),
                  bottomRight: Radius.circular(size.width * 0.05),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Upper Section
                  Row(
                    children: [
                      Text(
                        'ID ${corte.bsmedNume}',
                        style: GoogleFonts.jetBrainsMono(
                          color: kPrimaryColor.withOpacity(0.6),
                          fontSize: size.width * 0.035,
                        ),
                      ),
                      const Spacer(),
                      CheckBoxCustom(
                        corte: corte,
                        onBlocEvent: () {
                          authBloc.add(OnChangedInfoCorte(corte));
                          authBloc.add(OnEditRutaTrabajo(corte));
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: size.width * 0.03),

                  // Title and Location
                  Text(
                    corte.dNomb,
                    style: GoogleFonts.spaceMono(
                      fontSize: size.width * 0.045,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor,
                      height: 1.2,
                    ),
                  ),

                  Text(
                    "${corte.bscntlati}, ${corte.bscntlogi}",
                    style: GoogleFonts.spaceMono(
                      fontSize: size.width * 0.035,
                      color: kPrimaryColor.withOpacity(0.7),
                    ),
                  ),

                  // Stats Row
                  Container(
                    margin: EdgeInsets.symmetric(vertical: size.width * 0.04),
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.03,
                      vertical: size.width * 0.02,
                    ),
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(size.width * 0.02),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStat(
                          title: '${corte.bscocImor}',
                          subtitle: 'Balance',
                          size: size,
                        ),
                        _buildStat(
                          title: '${corte.bscocNmor}',
                          subtitle: 'Months',
                          size: size,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Status Indicator
            Positioned(
              right: 0,
              top: size.width * 0.02,
              child: Container(
                width: size.width * 0.015,
                height: size.width * 0.08,
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.4),
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(size.width * 0.01),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStat({
    required String title,
    required String subtitle,
    required Size size,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.jetBrainsMono(
            fontSize: size.width * 0.04,
            fontWeight: FontWeight.w600,
            color: kPrimaryColor,
          ),
        ),
        Text(
          subtitle,
          style: GoogleFonts.jetBrainsMono(
            fontSize: size.width * 0.03,
            color: kPrimaryColor.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}

class CheckBoxCustom extends StatelessWidget {
  final Function() onBlocEvent;
  final InfoCorte corte;

  const CheckBoxCustom({
    super.key,
    required this.onBlocEvent,
    required this.corte,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authBloc = BlocProvider.of<AuthBloc>(context, listen: true);
    final isChecked = authBloc.state.rutaTrabajo
        .any((elemento) => elemento.bscocNcoc == corte.bscocNcoc);

    return GestureDetector(
      onTap: () {
        if (isChecked) {
          onBlocEvent();
          return;
        }
        if (authBloc.state.rutaTrabajo.length >= 9) {
          DialogService.showErrorSnackBar(
            message: "Limite Maximo : 9 puntos de corte",
            context: context,
          );
          return;
        }
        onBlocEvent();
      },
      child: Container(
        width: size.width * 0.08,
        height: size.width * 0.08,
        decoration: BoxDecoration(
          color: isChecked ? kPrimaryColor : Colors.transparent,
          border: Border.all(
            color: kPrimaryColor,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(size.width * 0.01),
        ),
        child: isChecked
            ? Icon(
                Icons.check,
                color: kSecondaryColor,
                size: size.width * 0.05,
              )
            : null,
      ),
    );
  }
}
