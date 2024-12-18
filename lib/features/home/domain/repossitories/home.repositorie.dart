import 'package:proyecto_sig/features/home/domain/entities/infoCorte.entitie.dart';
import 'package:proyecto_sig/features/home/domain/entities/infoRuta.entitie.dart';

abstract class HomeRepositorie {
  Future<String> postAuthenticating(
      {required String codigo, required String password});
  Future<String> postObtenerCodigoNegocio({required String codigo});
  // READ : OBTENER LAS CATEGORIAS DE RUTAS DONDE SE DEBE CORTAR
  Future<List<InfoRuta>> postObtenerRutasUtilizar();
  // READ : OBTENER LA LISTA PERSONA QUE HAY QUE CORTAR MEDIANTE LA RUTA
  Future<List<InfoCorte>> postObtenerListaQuienCortar({required int tipoRuta});
  // READ : UPDATE EL CORTE
  Future<String> postUpdateCorteRealizado(
      {required String liNcoc,
      required String liCemc,
      required String ldFcor,
      required String liNofn});
}
