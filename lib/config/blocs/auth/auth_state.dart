part of 'auth_bloc.dart';

enum InfoCorteType { view, update }

class AuthState extends Equatable {
  final bool viewWindowInfo;
  final InfoCorte? infoCorte;
  final InfoRuta? infoRuta;

  final String codigoFuncionario;
  final List<InfoCorte> infoCortes;
  final List<InfoRuta> infoRutas;

  // READ : ANALIZIS DE RUTA CREADA DE TRABAJO
  // LOGIC : Informacion de las rutas de cortes seleccionadas
  final List<InfoCorte> rutaTrabajo;
  final List<InfoCorte> rutaTrabajoAux;
  final bool trabajandoRuta;

  final InfoCorteType infoCorteType;

  const AuthState({
    this.viewWindowInfo = true,
    this.codigoFuncionario = '',
    this.infoCorte,
    this.infoRuta,
    this.infoCortes = const [],
    this.infoRutas = const [],
    this.rutaTrabajo = const [],
    this.rutaTrabajoAux = const [],
    this.trabajandoRuta = false,
    this.infoCorteType = InfoCorteType.view,
  });
  AuthState copyWith({
    bool? viewWindowInfo,
    InfoCorte? infoCorte,
    InfoRuta? infoRuta,
    String? codigoFuncionario,
    List<InfoCorte>? infoCortes,
    List<InfoRuta>? infoRutas,
    List<InfoCorte>? rutaTrabajo,
    List<InfoCorte>? rutaTrabajoAux,
    InfoCorteType? infoCorteType,
    bool? trabajandoRuta,
  }) {
    return AuthState(
      viewWindowInfo: viewWindowInfo ?? this.viewWindowInfo,
      infoCorte: infoCorte ?? this.infoCorte,
      infoRuta: infoRuta ?? this.infoRuta,
      codigoFuncionario: codigoFuncionario ?? this.codigoFuncionario,
      infoCortes: infoCortes ?? this.infoCortes,
      infoRutas: infoRutas ?? this.infoRutas,
      rutaTrabajo: rutaTrabajo ?? this.rutaTrabajo,
      rutaTrabajoAux: rutaTrabajoAux ?? this.rutaTrabajoAux,
      infoCorteType: infoCorteType ?? this.infoCorteType,
      trabajandoRuta: trabajandoRuta ?? this.trabajandoRuta,
    );
  }

  @override
  List<Object?> get props => [
        viewWindowInfo,
        infoCorte,
        infoRuta,
        codigoFuncionario,
        infoCortes,
        rutaTrabajo,
        rutaTrabajoAux,
        infoRutas,
        infoCorteType,
        trabajandoRuta,
      ];
}
