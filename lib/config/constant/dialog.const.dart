import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DialogService {
  static const kPrimaryColor = Colors.white;
  static const kSecondaryColor = Colors.black;

  // Success notification with slide animation
  static void showSuccessSnackBar(String message, BuildContext context) {
    final size = MediaQuery.of(context).size;

    final notification = SnackBar(
      content: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              kSecondaryColor.withOpacity(0.05),
              kSecondaryColor.withOpacity(0.02),
            ],
          ),
          borderRadius: BorderRadius.circular(size.width * 0.04),
        ),
        child: ListTile(
          leading: AnimatedRotation(
            turns: 1,
            duration: const Duration(milliseconds: 500),
            child: Icon(
              Icons.done_all_rounded,
              color: kSecondaryColor,
              size: size.width * 0.07,
            ),
          ),
          title: Text(
            message,
            style: GoogleFonts.questrial(
              fontSize: size.width * 0.038,
              color: kSecondaryColor,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
      backgroundColor: kPrimaryColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(size.width * 0.04),
          bottomRight: Radius.circular(size.width * 0.04),
        ),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.02,
      ),
      elevation: 0,
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(notification);
  }

  // Error notification with pulse animation
  static void showErrorSnackBar({
    required String message,
    required BuildContext context,
  }) {
    final size = MediaQuery.of(context).size;

    final notification = SnackBar(
      content: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.04,
              vertical: size.height * 0.015,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: kPrimaryColor.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(size.width * 0.02),
            ),
            child: Row(
              children: [
                SizedBox(width: size.width * 0.08),
                Expanded(
                  child: Text(
                    message,
                    style: GoogleFonts.spaceMono(
                      fontSize: size.width * 0.034,
                      color: kPrimaryColor,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: -size.width * 0.02,
            top: -size.height * 0.012,
            child: Container(
              padding: EdgeInsets.all(size.width * 0.02),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: kPrimaryColor.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(
                Icons.priority_high_rounded,
                color: kSecondaryColor,
                size: size.width * 0.05,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: kSecondaryColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(size.width * 0.02),
      ),
      margin: EdgeInsets.only(
        bottom: size.height * 0.02,
        left: size.width * 0.04,
        right: size.width * 0.04,
      ),
      duration: const Duration(seconds: 4),
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(notification);
  }

  // Loading overlay with geometric animation
  static void showLoadingDialog({
    required BuildContext context,
    String? message,
  }) {
    final size = MediaQuery.of(context).size;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: kSecondaryColor.withOpacity(0.4),
      builder: (context) => Material(
        type: MaterialType.transparency,
        child: PopScope(
          canPop: false,
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: size.width * 0.75),
              margin: EdgeInsets.symmetric(horizontal: size.width * 0.06),
              padding: EdgeInsets.all(size.width * 0.06),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(size.width * 0.06),
                  topRight: Radius.circular(size.width * 0.02),
                  bottomLeft: Radius.circular(size.width * 0.02),
                  bottomRight: Radius.circular(size.width * 0.06),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: size.width * 0.16,
                    height: size.width * 0.16,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: kSecondaryColor.withOpacity(0.1),
                        width: size.width * 0.004,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(size.width * 0.04),
                        bottomRight: Radius.circular(size.width * 0.04),
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        TweenAnimationBuilder(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(seconds: 2),
                          builder: (context, value, child) =>
                              CircularProgressIndicator(
                            value: value,
                            strokeWidth: size.width * 0.005,
                            color: kSecondaryColor,
                          ),
                        ),
                        Icon(
                          Icons.grid_3x3,
                          color: kSecondaryColor,
                          size: size.width * 0.06,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.024),
                  Text(
                    message ?? 'Procesando Solicitud',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.urbanist(
                      fontSize: size.width * 0.042,
                      fontWeight: FontWeight.w600,
                      color: kSecondaryColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: size.height * 0.012),
                  Text(
                    'Optimización del Sistema en Progreso',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.urbanist(
                      fontSize: size.width * 0.032,
                      color: kSecondaryColor.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
