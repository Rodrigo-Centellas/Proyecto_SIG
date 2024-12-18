import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:proyecto_sig/config/blocs/auth/auth_bloc.dart';
import 'package:proyecto_sig/config/blocs/map/map_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart';

// Constants
const kPrimaryColor = Colors.white;
const kSecondaryColor = Colors.black;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SpeechToText _speechToText = SpeechToText();
  final ImagePicker _imagePicker = ImagePicker();
  String codigoFuncionario = '';
  String password = '';

  @override
  void initState() {
    super.initState();
    _initializePermissions();
  }

  Future<void> _initializePermissions() async {
    final mapBloc = BlocProvider.of<MapBloc>(context);
    await mapBloc.askGpsAccess();
    await _requestBasicPermissions();
    await _initSpeechToText();
    await _requestCameraPermissions();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Modern header section
              Container(
                height: size.height * 0.3,
                width: size.width,
                decoration: BoxDecoration(
                  color: kSecondaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(size.width * 0.1),
                    bottomRight: Radius.circular(size.width * 0.1),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.water_drop,
                      size: size.width * 0.15,
                      color: kPrimaryColor,
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      "AquaConnect",
                      style: GoogleFonts.poppins(
                        fontSize: size.width * 0.08,
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                      ),
                    ),
                    Text(
                      "Gestion de Puntos de Cortes",
                      style: GoogleFonts.poppins(
                        fontSize: size.width * 0.04,
                        color: kPrimaryColor.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),

              // Login form section
              Padding(
                padding: EdgeInsets.all(size.width * 0.06),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(size.width * 0.04),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(size.width * 0.05),
                    child: Column(
                      children: [
                        ModernTextField(
                          hint: 'Employee ID',
                          icon: Icons.person_outline,
                          onChanged: (value) {
                            setState(() {
                              codigoFuncionario = value;
                            });
                          },
                        ),
                        SizedBox(height: size.height * 0.02),
                        ModernTextField(
                          hint: 'Password',
                          icon: Icons.lock_outline,
                          isPassword: true,
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                        ),
                        SizedBox(height: size.height * 0.02),
                        SizedBox(height: size.height * 0.03),
                        ElevatedButton(
                          onPressed: () {
                            // Maintain original authentication logic
                            BlocProvider.of<AuthBloc>(context).add(
                              OnAuthenticating(
                                context: context,
                                codigo: codigoFuncionario, // Add actual values
                                password: password, // Add actual values
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kSecondaryColor,
                            minimumSize:
                                Size(size.width * 0.7, size.height * 0.06),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(size.width * 0.02),
                            ),
                          ),
                          child: Text(
                            'Inicio de Sesion',
                            style: GoogleFonts.poppins(
                              color: kPrimaryColor,
                              fontSize: size.width * 0.04,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Info text
            ],
          ),
        ),
      ),
    );
  }

  // Maintain original permission handling
  Future<void> _requestBasicPermissions() async {
    try {
      await Permission.storage.request();
      if (Platform.isIOS) {
        await Permission.photos.request();
      }
    } catch (e) {
      debugPrint('Basic permissions error: $e');
    }
  }

  Future<void> _initSpeechToText() async {
    try {
      var status = await Permission.microphone.request();
      if (status.isGranted) {
        await _speechToText.initialize(
          onStatus: (status) => debugPrint('Speech status: $status'),
          onError: (error) => debugPrint('Speech error: $error'),
        );
      }
    } catch (e) {
      debugPrint('Speech to text init error: $e');
    }
  }

  Future<void> _requestCameraPermissions() async {
    try {
      await Permission.camera.request();
    } catch (e) {
      debugPrint('Camera permission error: $e');
    }
  }
}

// Modern reusable widgets
class ModernTextField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool isPassword;
  final ValueChanged<String> onChanged;

  const ModernTextField({
    super.key,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return TextField(
      obscureText: isPassword,
      onChanged: onChanged,
      style: GoogleFonts.poppins(
        fontSize: size.width * 0.04,
        color: kSecondaryColor,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
          fontSize: size.width * 0.04,
          color: kSecondaryColor.withOpacity(0.5),
        ),
        prefixIcon: Icon(icon, color: kSecondaryColor, size: size.width * 0.06),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(size.width * 0.02),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: kSecondaryColor.withOpacity(0.1),
      ),
    );
  }
}

class ModernDropdown extends StatelessWidget {
  final String hint;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const ModernDropdown({
    super.key,
    required this.hint,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
      decoration: BoxDecoration(
        color: kSecondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(size.width * 0.02),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(
            hint,
            style: GoogleFonts.poppins(
              fontSize: size.width * 0.04,
              color: kSecondaryColor.withOpacity(0.5),
            ),
          ),
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down, size: size.width * 0.08),
          items: options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: size.width * 0.04,
                  color: kSecondaryColor,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
