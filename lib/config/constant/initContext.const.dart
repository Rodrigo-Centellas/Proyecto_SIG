import 'package:flutter/material.dart';
import 'package:proyecto_sig/config/constant/dialog.const.dart';
import 'package:proyecto_sig/config/constant/letter-style.const.dart';

class InitContext {
  static InitContext? _instance;
  late LetterStyle estiloLetras;
  late DialogService dialogService;

  // Constructor privado con lista de inicialización
  InitContext._internal(BuildContext context)
      : estiloLetras = LetterStyle(context);
  // dialogService = DialogService(context);

  // Método factory para crear/obtener instancia
  static InitContext _getInstance(BuildContext context) {
    return _instance ??= InitContext._internal(context);
  }

  // Getter para acceder a size con null check
  static Size get currentSize => _ensureInitialized().estiloLetras.size;

  // Getter para acceder a letterStyle con null check
  static LetterStyle get currentLetterStyle =>
      _ensureInitialized().estiloLetras;

  // Getter para acceder a dialogService con null check
  static DialogService get currentDialogService =>
      _ensureInitialized().dialogService;

  // Método de inicialización
  static void inicializar(BuildContext context) {
    _getInstance(context);
  }

  // Método helper para verificar inicialización
  static InitContext _ensureInitialized() {
    if (_instance == null) {
      throw Exception(
          'InitContext no ha sido inicializado. Llame a inicializar() primero.');
    }
    return _instance!;
  }

  // Método para limpiar la instancia (útil para testing)
  static void dispose() {
    _instance = null;
  }
}
