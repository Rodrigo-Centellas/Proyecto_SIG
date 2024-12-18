part of 'auth_bloc.dart';

class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class OnAuthenticating extends AuthEvent {
  final String codigo;
  final String password;
  final BuildContext context;
  const OnAuthenticating(
      {required this.codigo, required this.password, required this.context});
}

class OnProcessInfoRutas extends AuthEvent {
  final BuildContext context;
  const OnProcessInfoRutas(this.context);
}

class OnProcessInfoCortes extends AuthEvent {
  final int tipoCorte;
  final BuildContext context;
  const OnProcessInfoCortes({
    required this.tipoCorte,
    required this.context,
  });
}

class OnEditRutaTrabajo extends AuthEvent {
  final InfoCorte infoCorte;
  const OnEditRutaTrabajo(this.infoCorte);
}

class OnChangedInfoRuta extends AuthEvent {
  final BuildContext context;
  final InfoRuta infoRuta;
  const OnChangedInfoRuta(this.infoRuta, this.context);
}

class OnChangedInfoCortes extends AuthEvent {
  final InfoRuta infoRuta;
  const OnChangedInfoCortes(this.infoRuta);
}

class OnChangedInfoCorte extends AuthEvent {
  final InfoCorte infoCorte;
  const OnChangedInfoCorte(this.infoCorte);
}

class OnUpdateInfoCorte extends AuthEvent {
  final InfoCorte infoCorte;
  const OnUpdateInfoCorte(this.infoCorte);
}

class OnQueryBusqueda extends AuthEvent {
  final String query;
  const OnQueryBusqueda(this.query);
}

class OnCleanBlocAuth extends AuthEvent {
  const OnCleanBlocAuth();
}

class OnChangeInfoCorteType extends AuthEvent {
  final InfoCorteType data;
  const OnChangeInfoCorteType(this.data);
}

class OnChangedRutasTrabajadas extends AuthEvent {
  final InfoCorte infoCorte;
  const OnChangedRutasTrabajadas(this.infoCorte);
}

class OnChangedTrabajoRuta extends AuthEvent {
  const OnChangedTrabajoRuta();
}
