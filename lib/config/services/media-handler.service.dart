// Clase abstracta base
abstract class MediaHandlerService {
  // Métodos para imágenes
  Future<String?> takePhoto();
  Future<String?> selectPhoto();
  Future<String?> uploadImage(String filePath);

  // Métodos para audio/voz
  Future<bool> initSpeechService();
  Future<void> startListening({
    required Function(String text) onResult,
    String? localeId,
  });
  Future<void> stopListening();
  bool isListening();
  bool get isAvailable;
  void dispose();
}
