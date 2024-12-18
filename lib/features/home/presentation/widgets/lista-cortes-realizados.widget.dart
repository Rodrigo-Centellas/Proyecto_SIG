import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proyecto_sig/config/constant/colors.const.dart';
import 'package:proyecto_sig/config/constant/principal.const.dart';
import 'package:proyecto_sig/features/home/domain/entities/infoCorte.entitie.dart';

class CortesRealizadosView extends StatelessWidget {
  const CortesRealizadosView({super.key, required this.listaCorteBeta});

  final List<InfoCorte> listaCorteBeta;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
      itemCount: listaCorteBeta.length,
      itemBuilder: (context, index) {
        final corte = listaCorteBeta[index];
        return Container(
          margin: EdgeInsets.only(bottom: size.width * 0.03),
          child: Material(
            elevation: 8,
            shadowColor: kQuintaColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(size.width * 0.03),
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
              ),
              child: ExpansionTile(
                leading: Container(
                  padding: EdgeInsets.all(size.width * 0.02),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [kQuintaColor, kQuintaColor.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: kQuintaColor.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.checkDouble,
                    color: Colors.white,
                    size: size.width * 0.05,
                  ),
                ),
                title: Text(
                  corte.dNomb,
                  style: letterStyle.letra1Comunicados.copyWith(
                    fontSize: size.width * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.clock,
                      size: size.width * 0.035,
                      color: kCuartoColor,
                    ),
                    SizedBox(width: size.width * 0.02),
                    Text(
                      'Completado en 45 min',
                      style: letterStyle.letra3Comunicados.copyWith(
                        fontSize: size.width * 0.035,
                        color: kCuartoColor,
                      ),
                    ),
                  ],
                ),
                children: [
                  Container(
                    padding: EdgeInsets.all(size.width * 0.04),
                    child: Column(
                      children: [
                        _ProcessTimeline(
                          steps: [
                            'Inicio de corte: 09:15',
                            'Medidor localizado: 09:25',
                            'Corte realizado: 09:45',
                            'Registro completado: 10:00'
                          ],
                        ),
                        SizedBox(height: size.width * 0.04),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _StatusChip(
                              label: 'Tiempo: 45min',
                              color: kCuartoColor,
                              icon: FontAwesomeIcons.stopwatch,
                            ),
                            _StatusChip(
                              label: 'Estado: Completado',
                              color: kQuintaColor,
                              icon: FontAwesomeIcons.check,
                            ),
                          ],
                        ),
                        SizedBox(height: size.width * 0.04),
                        Container(
                          padding: EdgeInsets.all(size.width * 0.03),
                          decoration: BoxDecoration(
                            color: kPrimaryColor.withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(size.width * 0.03),
                          ),
                          child: Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.circleInfo,
                                color: kPrimaryColor,
                                size: size.width * 0.05,
                              ),
                              SizedBox(width: size.width * 0.02),
                              Expanded(
                                child: Text(
                                  'Corte realizado correctamente sin incidencias',
                                  style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: size.width * 0.035,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _StatusChip({
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.03,
        vertical: size.width * 0.02,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(size.width * 0.03),
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            icon,
            size: size.width * 0.04,
            color: color,
          ),
          SizedBox(width: size.width * 0.02),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: size.width * 0.035,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProcessTimeline extends StatelessWidget {
  final List<String> steps;

  const _ProcessTimeline({required this.steps});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isLast = index == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: size.width * 0.06,
                  height: size.width * 0.06,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [kQuintaColor, kQuintaColor.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: kQuintaColor.withOpacity(0.3),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.check,
                    size: size.width * 0.04,
                    color: Colors.white,
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: size.width * 0.08,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          kQuintaColor,
                          kQuintaColor.withOpacity(0.3),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: size.width * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step,
                    style: TextStyle(
                      color: kCuartoColor,
                      fontSize: size.width * 0.04,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (!isLast) SizedBox(height: size.width * 0.04),
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
