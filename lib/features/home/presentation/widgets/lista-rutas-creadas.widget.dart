import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proyecto_sig/config/constant/const.dart';
import 'package:proyecto_sig/features/home/domain/entities/infoRutaRealizada.entitie.dart';

class RutasCreatedView extends StatelessWidget {
  const RutasCreatedView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
      itemCount: rutasRealizadas.length,
      itemBuilder: (context, index) {
        final ruta = rutasRealizadas[index];
        final porcentaje =
            (ruta.cortesCompletados / ruta.cortesTotales * 100).round();
        final isCompleted = ruta.estado == "Completado";

        return Container(
          margin: EdgeInsets.symmetric(vertical: size.width * 0.04),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(size.width * 0.04),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      kPrimaryColor,
                      kPrimaryColor.withOpacity(0.9),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(size.width * 0.03),
                  boxShadow: [
                    BoxShadow(
                      color: kPrimaryColor.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.03,
                                vertical: size.width * 0.015,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius:
                                    BorderRadius.circular(size.width * 0.02),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.route,
                                    color: Colors.white,
                                    size: size.width * 0.05,
                                  ),
                                  SizedBox(width: size.width * 0.02),
                                  Text(
                                    'Ruta ${ruta.numeroRuta}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.width * 0.04,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: size.width * 0.02),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.02,
                                vertical: size.width * 0.01,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isCompleted ? kQuintaColor : Colors.orange,
                                borderRadius:
                                    BorderRadius.circular(size.width * 0.01),
                              ),
                              child: Text(
                                ruta.estado,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.width * 0.03,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        _CustomProgressIndicator(
                          porcentaje: porcentaje,
                          cortesCompletados: ruta.cortesCompletados,
                          cortesTotales: ruta.cortesTotales,
                        ),
                      ],
                    ),
                    SizedBox(height: size.width * 0.04),
                    Container(
                      padding: EdgeInsets.all(size.width * 0.03),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(size.width * 0.02),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _StatItemDetallado(
                                icon: FontAwesomeIcons.listCheck,
                                value:
                                    '${ruta.cortesCompletados}/${ruta.cortesTotales}',
                                label: 'Cortes',
                                color: Colors.white,
                              ),
                              _StatItemDetallado(
                                icon: FontAwesomeIcons.clock,
                                value: '${ruta.tiempoTotal}min',
                                label: 'Tiempo Total',
                                color: Colors.white,
                              ),
                              _StatItemDetallado(
                                icon: FontAwesomeIcons.route,
                                value: '${ruta.distanciaTotal}km',
                                label: 'Recorrido',
                                color: Colors.white,
                              ),
                            ],
                          ),
                          SizedBox(height: size.width * 0.03),
                          _TimeProgressStatus(
                            startTime: ruta.horaInicio,
                            endTime: ruta.horaFin,
                            tiempoTotal: ruta.tiempoTotal,
                            isCompleted: isCompleted,
                            targetEndTime: ruta.horaObjetivo,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _TimelineProgress(
                startTime: ruta.horaInicio,
                endTime: ruta.horaFin,
                targetEndTime: ruta.horaObjetivo,
                progress: ruta.progreso,
                isCompleted: isCompleted,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TimeProgressStatus extends StatelessWidget {
  final String startTime;
  final String endTime;
  final String targetEndTime;
  final int tiempoTotal;
  final bool isCompleted;

  const _TimeProgressStatus({
    required this.startTime,
    required this.endTime,
    required this.tiempoTotal,
    required this.isCompleted,
    required this.targetEndTime,
  });

  @override
  Widget build(BuildContext context) {
    final String statusText = isCompleted ? 'Completado' : 'Cancelado';
    final Color statusColor = isCompleted ? kQuintaColor : Colors.orange;
    final IconData statusIcon = isCompleted
        ? FontAwesomeIcons.circleCheck
        : FontAwesomeIcons.circleStop;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _TimeBlock(
          label: 'Inicio',
          time: startTime,
          icon: FontAwesomeIcons.play,
          color: Colors.white,
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.03,
            vertical: size.width * 0.02,
          ),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(size.width * 0.02),
            border: Border.all(
              color: statusColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              FaIcon(
                statusIcon,
                color: statusColor,
                size: size.width * 0.045,
              ),
              SizedBox(width: size.width * 0.02),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    statusText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.width * 0.03,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        color: Colors.white70,
                        size: size.width * 0.035,
                      ),
                      SizedBox(width: size.width * 0.01),
                      Text(
                        '${tiempoTotal}min',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.width * 0.035,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        _TimeBlock(
          label: isCompleted ? 'Finalizado' : 'Cancelado en',
          time: endTime,
          icon: isCompleted ? FontAwesomeIcons.flag : FontAwesomeIcons.stop,
          color: Colors.white,
        ),
      ],
    );
  }
}

class _CustomProgressIndicator extends StatelessWidget {
  final int porcentaje;
  final int cortesCompletados;
  final int cortesTotales;

  const _CustomProgressIndicator({
    required this.porcentaje,
    required this.cortesCompletados,
    required this.cortesTotales,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.22,
      height: size.width * 0.22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: porcentaje / 100,
            strokeWidth: size.width * 0.015,
            backgroundColor: Colors.white.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(kQuintaColor),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$porcentaje%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size.width * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$cortesCompletados/$cortesTotales',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: size.width * 0.03,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItemDetallado extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatItemDetallado({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(size.width * 0.025),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: FaIcon(
            icon,
            color: color,
            size: size.width * 0.05,
          ),
        ),
        SizedBox(height: size.width * 0.01),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: size.width * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: color.withOpacity(0.7),
            fontSize: size.width * 0.03,
          ),
        ),
      ],
    );
  }
}

class _TimeBlock extends StatelessWidget {
  final String label;
  final String time;
  final IconData icon;
  final Color color;

  const _TimeBlock({
    required this.label,
    required this.time,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.02,
        vertical: size.width * 0.01,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            icon,
            color: color.withOpacity(0.9),
            size: size.width * 0.04,
          ),
          SizedBox(width: size.width * 0.02),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: color.withOpacity(0.7),
                  fontSize: size.width * 0.025,
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  color: color,
                  fontSize: size.width * 0.035,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimelineProgress extends StatelessWidget {
  final String startTime;
  final String endTime;
  final String targetEndTime;
  final double progress;
  final bool isCompleted;

  const _TimelineProgress({
    required this.startTime,
    required this.endTime,
    required this.targetEndTime,
    required this.progress,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: size.width * 0.04),
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size.width * 0.03),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                startTime,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: size.width * 0.035,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.03,
                  vertical: size.width * 0.01,
                ),
                decoration: BoxDecoration(
                  color: (isCompleted ? kQuintaColor : Colors.orange)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(size.width * 0.02),
                ),
                child: Row(
                  children: [
                    Icon(
                      isCompleted ? Icons.check_circle : Icons.stop_circle,
                      color: isCompleted ? kQuintaColor : Colors.orange,
                      size: size.width * 0.04,
                    ),
                    SizedBox(width: size.width * 0.01),
                    Text(
                      endTime,
                      style: TextStyle(
                        color: isCompleted ? kQuintaColor : Colors.orange,
                        fontSize: size.width * 0.035,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                targetEndTime,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: size.width * 0.035,
                ),
              ),
            ],
          ),
          SizedBox(height: size.width * 0.03),
          Stack(
            children: [
              Container(
                height: size.width * 0.02,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(size.width * 0.01),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: size.width * 0.02,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        isCompleted ? kQuintaColor : Colors.orange,
                        isCompleted
                            ? kQuintaColor.withOpacity(0.8)
                            : Colors.orange.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(size.width * 0.01),
                    boxShadow: [
                      BoxShadow(
                        color: (isCompleted ? kQuintaColor : Colors.orange)
                            .withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width * 0.7 * progress -
                    size.width * 0.02,
                top: -size.width * 0.015,
                child: Container(
                  width: size.width * 0.05,
                  height: size.width * 0.05,
                  decoration: BoxDecoration(
                    color: isCompleted ? kQuintaColor : Colors.orange,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (isCompleted ? kQuintaColor : Colors.orange)
                            .withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: size.width * 0.02,
                      height: size.width * 0.02,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


// FadeInUp(
//           duration: const Duration(milliseconds: 800),
//           child: Container(
//             margin: EdgeInsets.symmetric(vertical: size.width * 0.04),
//             child: Column(
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(size.width * 0.04),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                       colors: [
//                         kPrimaryColor,
//                         kPrimaryColor.withOpacity(0.9),
//                       ],
//                     ),
//                     borderRadius: BorderRadius.circular(size.width * 0.03),
//                     boxShadow: [
//                       BoxShadow(
//                         color: kPrimaryColor.withOpacity(0.3),
//                         blurRadius: 15,
//                         offset: const Offset(0, 5),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Container(
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: size.width * 0.03,
//                                   vertical: size.width * 0.015,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white.withOpacity(0.15),
//                                   borderRadius:
//                                       BorderRadius.circular(size.width * 0.02),
//                                 ),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Icon(
//                                       Icons.route,
//                                       color: Colors.white,
//                                       size: size.width * 0.05,
//                                     ),
//                                     SizedBox(width: size.width * 0.02),
//                                     Text(
//                                       'Ruta #1',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: size.width * 0.04,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(height: size.width * 0.02),
//                               Container(
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: size.width * 0.02,
//                                   vertical: size.width * 0.01,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: isCompleted
//                                       ? kQuintaColor
//                                       : Colors.orange,
//                                   borderRadius:
//                                       BorderRadius.circular(size.width * 0.01),
//                                 ),
//                                 child: Text(
//                                   isCompleted ? 'Completado' : 'Cancelado',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: size.width * 0.03,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           _CustomProgressIndicator(
//                             porcentaje: porcentaje,
//                             cortesCompletados: cortesCompletados,
//                             cortesTotales: cortesTotales,
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: size.width * 0.04),
//                       Container(
//                         padding: EdgeInsets.all(size.width * 0.03),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.1),
//                           borderRadius:
//                               BorderRadius.circular(size.width * 0.02),
//                         ),
//                         child: Column(
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceAround,
//                               children: [
//                                 _StatItemDetallado(
//                                   icon: FontAwesomeIcons.listCheck,
//                                   value: '$cortesCompletados/$cortesTotales',
//                                   label: 'Cortes',
//                                   color: Colors.white,
//                                 ),
//                                 _StatItemDetallado(
//                                   icon: FontAwesomeIcons.clock,
//                                   value: '${tiempoTotal}min',
//                                   label: 'Tiempo Total',
//                                   color: Colors.white,
//                                 ),
//                                 _StatItemDetallado(
//                                   icon: FontAwesomeIcons.route,
//                                   value: '${distanciaTotal}km',
//                                   label: 'Recorrido',
//                                   color: Colors.white,
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: size.width * 0.03),
//                             _TimeProgressStatus(
//                               startTime: '8:30',
//                               endTime: '10:15',
//                               tiempoTotal: tiempoTotal,
//                               isCompleted: isCompleted,
//                               targetEndTime: '12:00',
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 _TimelineProgress(
//                   startTime: '8:30',
//                   endTime: '10:15',
//                   targetEndTime: '12:00',
//                   progress: porcentaje / 100,
//                   isCompleted: isCompleted,
//                 ),
//               ],
//             ),
//           ),
//         );