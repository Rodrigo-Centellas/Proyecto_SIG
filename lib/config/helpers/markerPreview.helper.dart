import 'package:flutter/material.dart';
import 'package:proyecto_sig/config/helpers/widget-to-marker.helper.dart';

class MarkerPreviewApp extends StatelessWidget {
  const MarkerPreviewApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Vista Previa de Marcadores'),
          backgroundColor: const Color(0xFF2B2E83),
        ),
        body: const MarkerPreviewScreen(),
      ),
    );
  }
}

class MarkerPreviewScreen extends StatelessWidget {
  const MarkerPreviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200], // Fondo gris claro para mejor contraste
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Diferentes tamaños:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomMarker(numero: "1", size: 40),
                const SizedBox(width: 20),
                CustomMarker(numero: "2", size: 60),
                const SizedBox(width: 20),
                CustomMarker(numero: "3", size: 80),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              'Diferentes colores:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomMarker(
                  numero: "1",
                  size: 60, // Ajusta el tamaño según necesites
                  color: const Color(0xFF2B2E83),
                ),
                const SizedBox(width: 20),
                CustomMarker(
                  numero: "2",
                  size: 60,
                  color: Color(0xFFFF9800),
                ),
                const SizedBox(width: 20),
                CustomMarker(
                  numero: "3",
                  size: 60,
                  color: Color(0xFF43A047),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
