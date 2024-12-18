import 'package:dio/dio.dart';
import 'package:proyecto_sig/features/home/domain/datasources/home.datasource.dart';
import 'package:proyecto_sig/features/home/domain/entities/infoCorte.entitie.dart';
import 'package:proyecto_sig/features/home/domain/entities/infoRuta.entitie.dart';
import 'package:xml/xml.dart';

class HomeDataSourceImpl extends HomeDataSource {
  final dio = Dio(BaseOptions(
    baseUrl: 'http://190.171.244.211:8080/wsVarios',
  ));

  @override
  Future<String> postAuthenticating({
    required String codigo,
    required String password,
  }) async {
    try {
      final data = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <ValidarLoginPassword xmlns="http://tempuri.org/">
      <lsLogin>$codigo</lsLogin>
      <lsPassword>$password</lsPassword>
    </ValidarLoginPassword>
  </soap:Body>
</soap:Envelope>
''';
      final response = await dio.post(
        '/wsAd.asmx?op=ValidarLoginPassword',
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'text/xml; charset=utf-8',
            'SOAPAction': 'http://tempuri.org/ValidarLoginPassword',
          },
          validateStatus: (status) {
            return status! < 500; // Acepta códigos 2XX, 3XX y 4XX
          },
        ),
      );

      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.data);
        return document
            .findAllElements('ValidarLoginPasswordResult')
            .first
            .innerText;
      } else {
        throw Exception(
            'Error en la respuesta del servidor: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error en la petición: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<String> postObtenerCodigoNegocio({required String codigo}) async {
    try {
      final data = '''
      <?xml version="1.0" encoding="utf-8"?>
      <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
        <soap:Body>
          <GBOFN_ObtenerRegistroPorCUsuario xmlns="http://tempuri.org/">
            <lsCusr>$codigo</lsCusr>
          </GBOFN_ObtenerRegistroPorCUsuario>
        </soap:Body>
      </soap:Envelope>
      ''';

      final response =
          await dio.post('/wsGB.asmx?op=GBOFN_ObtenerRegistroPorCUsuario',
              options: Options(headers: {
                'Content-Type': 'text/xml; charset=utf-8',
                'SOAPAction': 'http://tempuri.org/ValidarLoginPassword'
              }),
              data: data);

      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.data);
        return document
            .findAllElements('GBOFN_ObtenerRegistroPorCUsuarioResult')
            .first
            .innerText;
      } else {
        throw Exception(
            'Error en la respuesta del servidor: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error en la petición: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<List<InfoRuta>> postObtenerRutasUtilizar() async {
    try {
      const data = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <W0Corte_ObtenerRutas xmlns="http://activebs.net/">
      <liCper>0</liCper>
    </W0Corte_ObtenerRutas>
  </soap:Body>
</soap:Envelope>
    ''';

      final response = await dio.post(
        '/wsBS.asmx?op=W0Corte_ObtenerRutas',
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'text/xml; charset=utf-8',
            'SOAPAction': 'http://activebs.net/W0Corte_ObtenerRutas'
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.data);

        // Navigate through the SOAP response structure
        final tables = document
            .findAllElements('soap:Body')
            .first
            .findAllElements('W0Corte_ObtenerRutasResponse')
            .first
            .findAllElements('W0Corte_ObtenerRutasResult')
            .first
            .findAllElements('diffgr:diffgram')
            .first
            .findAllElements('NewDataSet')
            .first
            .findAllElements('Table');

        if (tables.isEmpty) {
          print('No se encontraron rutas en la respuesta');
          return []; // Retorna una lista vacía
        }

        final rutas = tables.map((table) {
          final Map<String, dynamic> xmlData = {
            'bsrutnrut': _getElementText(table, 'bsrutnrut'),
            'bsrutdesc': _getElementText(table, 'bsrutdesc')?.trim(),
            'bsrutabrv': _getElementText(table, 'bsrutabrv')?.trim(),
            'bsruttipo': _getElementText(table, 'bsruttipo'),
            'bsrutnzon': _getElementText(table, 'bsrutnzon'),
            'bsrutfcor': _getElementText(table, 'bsrutfcor'),
            'bsrutcper': _getElementText(table, 'bsrutcper'),
            'bsrutstat': _getElementText(table, 'bsrutstat'),
            'bsrutride': _getElementText(table, 'bsrutride'),
            'dNomb': _getElementText(table, 'dNomb')?.trim(),
            'GbzonNzon': _getElementText(table, 'GbzonNzon'),
            'dNzon': _getElementText(table, 'dNzon')?.trim(),
          };

          return InfoRuta.fromXml(xmlData);
        }).toList();

        print('Rutas encontradas: ${rutas.length}');
        return rutas;
      } else {
        throw Exception(
            'Error en la respuesta del servidor: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error en la petición: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<List<InfoCorte>> postObtenerListaQuienCortar(
      {required int tipoRuta}) async {
    try {
      final data = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <W2Corte_ReporteParaCortesSIG xmlns="http://activebs.net/">
      <liNrut>$tipoRuta</liNrut>
      <liNcnt>0</liNcnt>
      <liCper>0</liCper>
    </W2Corte_ReporteParaCortesSIG>
  </soap:Body>
</soap:Envelope>
    ''';

      final response = await dio.post(
        '/wsBS.asmx?op=W2Corte_ReporteParaCortesSIG',
        options: Options(
          headers: {
            'Content-Type': 'text/xml; charset=utf-8',
            'SOAPAction': 'http://activebs.net/W2Corte_ReporteParaCortesSIG'
          },
          validateStatus: (status) => status! < 500,
        ),
        data: data,
      );

      if (response.statusCode == 200) {
        final document = XmlDocument.parse(response.data);

        // Navegación más específica a través de la estructura SOAP
        final tables = document
            .findAllElements('soap:Body')
            .first
            .findAllElements('W2Corte_ReporteParaCortesSIGResponse')
            .first
            .findAllElements('W2Corte_ReporteParaCortesSIGResult')
            .first
            .findAllElements('diffgr:diffgram')
            .first
            .findAllElements('NewDataSet')
            .first
            .findAllElements('Table');

        // Verificar si se encontraron tablas
        if (tables.isEmpty) {
          print('No se encontraron cortes para la ruta $tipoRuta');
          return [];
        }

        final cortes = tables.map((table) {
          // Usar un método auxiliar para extraer los datos
          final Map<String, dynamic> xmlData = {
            'bscocNcoc': _getElementText(table, 'bscocNcoc'),
            'bscntCodf': _getElementText(table, 'bscntCodf'),
            'bscocNcnt': _getElementText(table, 'bscocNcnt'),
            'dNomb': _getElementText(table, 'dNomb')?.trim(),
            'bscocNmor': _getElementText(table, 'bscocNmor'),
            'bscocImor': _getElementText(table, 'bscocImor'),
            'bsmednser': _getElementText(table, 'bsmednser')?.trim(),
            'bsmedNume': _getElementText(table, 'bsmedNume')?.trim(),
            'bscntlati': _getElementText(table, 'bscntlati'),
            'bscntlogi': _getElementText(table, 'bscntlogi'),
            'dNcat': _getElementText(table, 'dNcat')?.trim(),
            'dCobc': _getElementText(table, 'dCobc')?.trim(),
            'dLotes': _getElementText(table, 'dLotes')?.trim(),
          };

          return InfoCorte.fromMap(xmlData);
        }).toList();

        // Verificar si el mapeo resultó en una lista vacía
        if (cortes.isEmpty) {
          print(
              'El mapeo de cortes resultó en una lista vacía para la ruta $tipoRuta');
        } else {
          print(
              'Se encontraron ${cortes.length} cortes para la ruta $tipoRuta');
        }

        return cortes;
      } else {
        throw Exception(
            'Error en la respuesta del servidor: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Error en la petición HTTP: ${e.message}');
      throw Exception('Error en la petición: ${e.message}');
    } catch (e) {
      print('Error inesperado al obtener cortes: $e');
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<String> postUpdateCorteRealizado({
    required String liNcoc,
    required String liCemc,
    required String ldFcor,
    required String liNofn,
  }) async {
    try {
      final data = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
<soap:Body>
          <W3Corte_UpdateCorte xmlns="http://activebs.net/">
            <liNcoc>$liNcoc</liNcoc>
            <liCemc>$liCemc</liCemc>
            <ldFcor>$ldFcor</ldFcor>
            <liPres>0</liPres>
            <liCobc>0</liCobc>       
            <liLcor>0</liLcor>       
            <liNofn>6272</liNofn>
            <lsAppName>GrupoE</lsAppName>
          </W3Corte_UpdateCorte>
</soap:Body>
</soap:Envelope>
    ''';
      final response = await dio.post(
        '/wsBS.asmx',
        options: Options(
          headers: {
            'Content-Type': 'text/xml; charset=utf-8',
            'SOAPAction': 'http://activebs.net/W3Corte_UpdateCorte'
          },
        ),
        data: data,
      );

      if (response.statusCode == 200) {
        // Parsear el documento XML
        final document = XmlDocument.parse(response.data);

        // Obtener el elemento W3Corte_UpdateCorteResult
        final result = document
                .findAllElements('W3Corte_UpdateCorteResult')
                .firstOrNull
                ?.innerText ??
            '';

        return result;
      } else {
        throw Exception(
            'Error en la respuesta del servidor: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error en la petición: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  String? _getElementText(XmlElement table, String elementName) {
    return table.findElements(elementName).firstOrNull?.innerText;
  }
}

class CustomException implements Exception {
  final String message;
  CustomException(this.message);

  @override
  String toString() => message;
}
