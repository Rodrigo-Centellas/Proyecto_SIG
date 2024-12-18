import 'dart:convert';
import 'dart:math' show pi, sin, cos, sqrt, atan2;
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:proyecto_sig/config/constant/colors.const.dart';
import 'package:proyecto_sig/config/helpers/widget-to-marker.helper.dart';
import 'package:proyecto_sig/features/home/domain/entities/dataGoogleRuta.entitie.dart';

class HelperMap {
  // READ : CREAR UN MARCADOR PERSONALIZADO A PARTIR DE UNA IMAGEN ASSET
  static Future<BitmapDescriptor> getAssetImageMarker(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);

    // Decodificar la imagen primero para obtener sus dimensiones originales
    final ui.Codec codec =
        await ui.instantiateImageCodec(data.buffer.asUint8List());
    final ui.FrameInfo fi = await codec.getNextFrame();

    // Calcular las dimensiones manteniendo la proporción
    final double aspectRatio = fi.image.width / fi.image.height;
    int targetWidth = 140;
    int targetHeight = (targetWidth / aspectRatio).round();

    // Crear la imagen redimensionada
    final imageCodec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetHeight: targetHeight,
      targetWidth: targetWidth,
      allowUpscaling: false,
    );

    final frame = await imageCodec.getNextFrame();
    final imageData = await frame.image.toByteData(
      format: ui.ImageByteFormat.png, // PNG para mejor calidad sin pérdida
    );

    return BitmapDescriptor.fromBytes(imageData!.buffer.asUint8List());
  }

  // LOGIC : CREAR UN MARCADOR PERSONALIZADO A PARTIR DE UNA IMAGEN DE RED
  static Future<BitmapDescriptor> getNetworkImageMarker(
      String urlMarker) async {
    final resp = await Dio().get(
      urlMarker,
      options: Options(responseType: ResponseType.bytes),
    );

    final imageCodec = await ui.instantiateImageCodec(resp.data,
        targetHeight: 140, targetWidth: 140);
    final frame = await imageCodec.getNextFrame();
    final data = await frame.image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.bytes(data!.buffer.asUint8List());
  }

  // LOGIC : CREAR UN MARCADOR PERSONALIZADO A PARTIR DE UN WIDGET
  static Future<BitmapDescriptor> getMarkerIcon(String number,
      {Color color = kPrimaryColor}) async {
    // Configuramos el tamaño del marcador
    const double size = 180.0;

    // Creamos el recorder y canvas
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Pintamos el CustomMarker directamente en el canvas
    final marker = MarkerNumerado(
      colorPersonalizado: color,
      numero: number,
      size: size,
    );

    // Definimos el tamaño del área de pintado
    final markerSize = Size(size, size * 1.3);

    // Pintamos el marcador
    marker.paint(canvas, markerSize);

    // Finalizamos la grabación y convertimos a imagen
    final picture = recorder.endRecording();
    final image = await picture.toImage(
      markerSize.width.toInt(),
      markerSize.height.toInt(),
    );

    // Convertimos a bytes
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List);
  }

  static Future<DataGoogleRuta> getRoutePuntosCorte(List<LatLng> puntos) async {
    // if (puntos.length < 2) {
    //   throw Exception('Se requieren al menos 2 puntos para crear una ruta');
    // }

    String origenJson = '''
    "origin": {
        "location": {
            "latLng": {
                "latitude": ${puntos.first.latitude},
                "longitude": ${puntos.first.longitude}
            }
        }
    }
    ''';

    String destinoJson = '''
    "destination": {
        "location": {
            "latLng": {
                "latitude": ${puntos.last.latitude},
                "longitude": ${puntos.last.longitude}
            }
        }
    }
    ''';

    List<LatLng> puntosIntermedios = puntos.sublist(1, puntos.length - 1);
    String puntosIntermediosJson = puntosIntermedioBody(puntosIntermedios);

    String body = '''
    {
      $origenJson,
      $destinoJson,
      "intermediates": $puntosIntermediosJson,
      "travelMode": "TWO_WHEELER",
      "polylineQuality": "HIGH_QUALITY",
      "routingPreference": "TRAFFIC_UNAWARE",
      "computeAlternativeRoutes": false,
      "routeModifiers": {
          "avoidTolls": false,
          "avoidHighways": false,
          "avoidFerries": false,
          "avoidIndoor": false
      }
    }
    ''';

    try {
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        validateStatus: (status) => status! < 500,
      ));

      var response = await dio.post(
        'https://routes.googleapis.com/directions/v2:computeRoutes',
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'X-Goog-Api-Key': 'AIzaSyDYq6w1N7meIbXFGd56FrrfoGN4c7U-r2g',
            'X-Goog-FieldMask':
                'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline'
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      switch (response.statusCode) {
        case 200:
          if (response.data?['routes']?.isNotEmpty == true) {
            return DataGoogleRuta.fromJson(response.data);
          }
          throw Exception('No se encontró una ruta válida');

        case 401:
          throw Exception('Error de autenticación: API key inválida');

        case 403:
          throw Exception('Error de autorización: Sin permisos suficientes');

        case 429:
          throw Exception('Límite de cuota excedido');

        default:
          throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        switch (e.type) {
          case DioExceptionType.connectionTimeout:
            throw Exception('Tiempo de conexión agotado');
          case DioExceptionType.sendTimeout:
            throw Exception('Tiempo de envío agotado');
          case DioExceptionType.receiveTimeout:
            throw Exception('Tiempo de respuesta agotado');
          case DioExceptionType.badResponse:
            throw Exception(
                'Respuesta inválida del servidor: ${e.response?.statusCode}');
          case DioExceptionType.connectionError:
            throw Exception(
                'Error de conexión: Verifique su conexión a internet');
          default:
            throw Exception('Error de red: ${e.message}');
        }
      }
      throw Exception('Error inesperado: $e');
    }
  }

  static double calculateDistance(LatLng point1, LatLng point2) {
    const double radius = 6371000; // Radio de la Tierra en metros

    double lat1 = point1.latitude * pi / 180;
    double lat2 = point2.latitude * pi / 180;
    double dLat = (point2.latitude - point1.latitude) * pi / 180;
    double dLon = (point2.longitude - point1.longitude) * pi / 180;

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return radius * c; // Distancia en metros
  }

  static String puntosIntermedioBody(List<LatLng> puntosCorte) {
    var puntos = puntosCorte.take(puntosCorte.length - 1).map((punto) {
      return {
        "location": {
          "latLng": {
            "latitude": punto.latitude,
            "longitude": punto.longitude,
          }
        }
      };
    }).toList();

    return jsonEncode(puntos);
  }

  static List<LatLng> findOptimalRoute(LatLng origin, List<LatLng> points) {
    // 1. Validación inicial
    if (points.isEmpty) return [origin];
    if (points.length == 1) return [origin, points.first];

    // 2. Inicialización de variables
    List<LatLng> remainingPoints =
        List.from(points); // Crea una copia de los puntos originales
    List<LatLng> optimizedRoute = [origin]; // Comienza con el punto de origen
    LatLng currentPosition = origin;

    // 3. Algoritmo del vecino más cercano
    while (remainingPoints.isNotEmpty) {
      double minDistance = double.infinity;
      LatLng? nearestPoint;
      int nearestIndex = -1;

      // 3.1 Buscar el punto más cercano a la posición actual
      for (int i = 0; i < remainingPoints.length; i++) {
        double distance =
            calculateDistance(currentPosition, remainingPoints[i]);

        if (distance < minDistance) {
          minDistance = distance;
          nearestPoint = remainingPoints[i];
          nearestIndex = i;
        }
      }

      // 3.2 Agregar el punto más cercano a la ruta
      if (nearestPoint != null) {
        optimizedRoute.add(nearestPoint);
        currentPosition = nearestPoint;
        remainingPoints.removeAt(nearestIndex);
      }
    }

    return optimizedRoute;
  }

  // Método auxiliar para imprimir las distancias (útil para debugging)
  static void printRouteDistances(List<LatLng> route) {
    double totalDistance = 0;
    for (int i = 0; i < route.length - 1; i++) {
      double distance = calculateDistance(route[i], route[i + 1]);
      print(
          'Distancia del punto ${i} al ${i + 1}: ${(distance / 1000).toStringAsFixed(2)} km');
      totalDistance += distance;
    }
    print('Distancia total: ${(totalDistance / 1000).toStringAsFixed(2)} km');
  }
}

  // static List<LatLng> optimizarRuta(List<LatLng> puntos) {
  //   if (puntos.length <= 2) return puntos;

  //   // Mantener el primer punto fijo
  //   List<LatLng> rutaOptimizada = [puntos.first];
  //   List<LatLng> puntosRestantes = List.from(puntos.skip(1));

  //   while (puntosRestantes.isNotEmpty) {
  //     LatLng ultimoPunto = rutaOptimizada.last;

  //     // Encontrar el punto más cercano
  //     LatLng puntoMasCercano = puntosRestantes.reduce((curr, next) {
  //       double distanciaCurr = _calcularDistancia(ultimoPunto.latitude,
  //           ultimoPunto.longitude, curr.latitude, curr.longitude);

  //       double distanciaNext = _calcularDistancia(ultimoPunto.latitude,
  //           ultimoPunto.longitude, next.latitude, next.longitude);

  //       return distanciaCurr < distanciaNext ? curr : next;
  //     });

  //     rutaOptimizada.add(puntoMasCercano);
  //     puntosRestantes.remove(puntoMasCercano);
  //   }

  //   return rutaOptimizada;
  // }

  // static double _calcularDistancia(
  //     double lat1, double lon1, double lat2, double lon2) {
  //   const double radioTierra = 6371.0; // Radio de la Tierra en km

  //   double dLat = _toRadianes(lat2 - lat1);
  //   double dLon = _toRadianes(lon2 - lon1);

  //   double a = sin(dLat / 2) * sin(dLat / 2) +
  //       cos(_toRadianes(lat1)) *
  //           cos(_toRadianes(lat2)) *
  //           sin(dLon / 2) *
  //           sin(dLon / 2);

  //   double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  //   return radioTierra * c;
  // }

  // static double _toRadianes(double grados) {
  //   return grados * pi / 180.0;
  // }

  // static bool sonPuntosProximos(LatLng p1, LatLng p2) {
  //   const tolerancia = 0.0001; // Aproximadamente 11 metros
  //   return (p1.latitude - p2.latitude).abs() < tolerancia &&
  //       (p1.longitude - p2.longitude).abs() < tolerancia;
  // }

  // static List<LatLng> crearPuntosOffset(List<LatLng> puntos, double offset) {
  //   return puntos
  //       .map((punto) => LatLng(
  //             punto.latitude + offset,
  //             punto.longitude + offset,
  //           ))
  //       .toList();
  // }

