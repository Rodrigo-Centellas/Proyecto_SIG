import 'package:proyecto_sig/features/home/domain/datasources/home.datasource.dart';
import 'package:proyecto_sig/features/home/domain/entities/infoCorte.entitie.dart';
import 'package:proyecto_sig/features/home/domain/entities/infoRuta.entitie.dart';
import 'package:proyecto_sig/features/home/domain/repossitories/home.repositorie.dart';
import 'package:proyecto_sig/features/home/infrastructure/datasources/home.datasource.dart';

class HomeRepositorieImpl extends HomeRepositorie {
  final HomeDataSource datasource;

  HomeRepositorieImpl({HomeDataSource? datasource})
      : datasource = datasource ?? HomeDataSourceImpl();

  @override
  Future<String> postAuthenticating(
      {required String codigo, required String password}) async {
    return await datasource.postAuthenticating(
        codigo: codigo, password: password);
  }

  @override
  Future<String> postObtenerCodigoNegocio({required String codigo}) async {
    return await datasource.postObtenerCodigoNegocio(codigo: codigo);
  }

  @override
  Future<List<InfoCorte>> postObtenerListaQuienCortar(
      {required int tipoRuta}) async {
    return await datasource.postObtenerListaQuienCortar(tipoRuta: tipoRuta);
  }

  @override
  Future<List<InfoRuta>> postObtenerRutasUtilizar() async {
    return await datasource.postObtenerRutasUtilizar();
  }

  @override
  Future<String> postUpdateCorteRealizado(
      {required String liNcoc,
      required String liCemc,
      required String ldFcor,
      required String liNofn}) {
    return datasource.postUpdateCorteRealizado(
        liNcoc: liNcoc, liCemc: liCemc, ldFcor: ldFcor, liNofn: liNofn);
  }
}
