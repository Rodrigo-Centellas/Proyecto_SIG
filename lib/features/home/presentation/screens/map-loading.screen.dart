import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MapLoading extends StatelessWidget {
  const MapLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Grid Pattern Background
          Positioned.fill(
            child: CustomPaint(
              painter: GridPainter(),
            ),
          ),

          // Main Content
          Center(
            child: Container(
              width: size.width * 0.85,
              padding: EdgeInsets.all(size.width * 0.06),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(size.width * 0.08),
                  bottomRight: Radius.circular(size.width * 0.08),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Custom Loading Animation
                  SizedBox(
                    width: size.width * 0.25,
                    height: size.width * 0.25,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer rotating square
                        TweenAnimationBuilder(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(seconds: 2),
                          builder: (context, value, child) => Transform.rotate(
                            angle: value * 6.28,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: size.width * 0.005,
                                ),
                                borderRadius:
                                    BorderRadius.circular(size.width * 0.02),
                              ),
                            ),
                          ),
                        ),

                        // Progress indicator
                        TweenAnimationBuilder(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(seconds: 4),
                          builder: (context, value, child) =>
                              CircularProgressIndicator(
                            value: value,
                            strokeWidth: size.width * 0.008,
                            color: Colors.black,
                          ),
                        ),

                        // Center diamond shape
                        Transform.rotate(
                          angle: 0.785, // 45 degrees
                          child: Container(
                            width: size.width * 0.08,
                            height: size.width * 0.08,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                                  BorderRadius.circular(size.width * 0.01),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: size.height * 0.04),

                  // Modern Loading Text
                  Text(
                    "Iniciando Sistema",
                    style: GoogleFonts.rajdhani(
                      fontSize: size.width * 0.045,
                      fontWeight: FontWeight.w600,
                      letterSpacing: size.width * 0.004,
                      color: Colors.black,
                    ),
                  ),

                  SizedBox(height: size.height * 0.02),

                  // Progress Text
                  Text(
                    "Sincronizando con el WebService",
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: size.width * 0.032,
                      color: Colors.black.withOpacity(0.6),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1;

    double spacing = 30;

    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paint,
      );
    }

    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
