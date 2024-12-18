import 'package:flutter/material.dart';

class CustomMarker extends StatelessWidget {
  final String numero;
  final Color color;
  final double size;

  const CustomMarker({
    Key? key,
    required this.numero,
    this.color = const Color(0xFF2B2E83),
    this.size = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MarkerNumerado(
        numero: numero,
        colorPersonalizado: color,
        size: size,
      ),
      size: Size(size, size * 1.3),
    );
  }
}

class MarkerNumerado extends CustomPainter {
  final String numero;
  final Color? colorPersonalizado; // Ahora es opcional (puede ser null)
  final double size;
  final Color _defaultColor = const Color(0xFFFF1744); // Color rojo por defecto

  MarkerNumerado({
    required this.numero,
    this.colorPersonalizado, // Ya no tiene valor por defecto
    this.size = 100,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = this.size;
    final double height = this.size * 1.3;
    final center = Offset(width / 2, width / 2);

    // Usar el color personalizado si existe, sino usar el color por defecto
    final Color baseColor = colorPersonalizado ?? _defaultColor;
    final Color darkColor = HSLColor.fromColor(baseColor)
        .withLightness(
            (HSLColor.fromColor(baseColor).lightness * 0.7).clamp(0.0, 1.0))
        .toColor();

    // Sombra principal del marcador
    final Path shadowPath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: width * 0.4))
      ..moveTo(width * 0.5, height * 0.95)
      ..lineTo(width * 0.35, width * 0.85)
      ..quadraticBezierTo(
        width * 0.5,
        width * 0.82,
        width * 0.65,
        width * 0.85,
      )
      ..close();

    // Sombra exterior más suave
    canvas.drawPath(
      shadowPath,
      Paint()
        ..color = Colors.black.withOpacity(0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // Círculo principal con gradiente
    final Paint backgroundPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          baseColor,
          darkColor,
        ],
        stops: const [0.4, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: width * 0.4));
    canvas.drawCircle(center, width * 0.4, backgroundPaint);

    // Pin base
    final Path pinPath = Path()
      ..moveTo(width * 0.5, height * 0.95)
      ..lineTo(width * 0.35, width * 0.85)
      ..quadraticBezierTo(
        width * 0.5,
        width * 0.82,
        width * 0.65,
        width * 0.85,
      )
      ..close();

    // Sombra interior del pin
    canvas.drawPath(
      pinPath,
      Paint()
        ..color = Colors.black.withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 3),
    );

    // Pin con gradiente
    final Paint pinPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          baseColor,
          darkColor,
        ],
      ).createShader(Rect.fromLTWH(0, 0, width, height));
    canvas.drawPath(pinPath, pinPaint);

    // Efecto de brillo
    final Paint highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx - width * 0.15, center.dy - width * 0.15),
      width * 0.12,
      highlightPaint,
    );

    // Número
    if (numero.isNotEmpty) {
      final textSpan = TextSpan(
        text: numero,
        style: TextStyle(
          color: Colors.white,
          fontSize: width * 0.32,
          fontWeight: FontWeight.w900,
          letterSpacing: 1,
        ),
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          center.dx - (textPainter.width / 2),
          center.dy - (textPainter.height / 2),
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
