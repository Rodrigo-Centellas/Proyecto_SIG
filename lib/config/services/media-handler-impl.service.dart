import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:proyecto_sig/config/services/media-handler.service.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class MediaHandlerServiceImpl implements MediaHandlerService {
  final ImagePickerPlatform imagePickerImplementation =
      ImagePickerPlatform.instance;
  final ImagePicker _picker = ImagePicker();
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;

  // READ : METODOS PARA IMAGENES
  @override
  Future<String?> selectPhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo == null) return null;
    return photo.path;
  }

  @override
  Future<String?> takePhoto() async {
    final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);
    if (photo == null) return null;
    return photo.path;
  }

  @override
  Future<String?> uploadImage(String filePath) async {
    final Dio dio = Dio();
    String url = 'https://api.cloudinary.com/v1_1/da9xsfose/image/upload';
    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
      'upload_preset': 'fqw7ooma',
    });

    try {
      var response = await dio.post(url, data: formData);
      if (response.statusCode == 200) {
        // Aquí puedes extraer la URL de la imagen de la respuesta
        // Por ejemplo: return response.data['secure_url'];
        return response.data['secure_url'].toString();
      } else {
        throw Exception(
            "Error al subir la imagen, código de estado: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error al subir la imagen: $e");
    }
  }

  // READ : METODOS PARA AUDIO/VOZ

  @override
  void dispose() {
    _speech.cancel();
  }

  @override
  Future<bool> initSpeechService() async {
    if (_isInitialized) return true;

    // Solicitar permiso de micrófono
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw Exception('Permiso de micrófono denegado');
    }

    // Inicializar el servicio
    _isInitialized = await _speech.initialize(
      onStatus: (status) => print('Status: $status'),
      onError: (error) => print('Error: $error'),
    );

    return _isInitialized;
  }

  @override
  // TODO: implement isAvailable
  bool get isAvailable => throw UnimplementedError();

  @override
  bool isListening() {
    return _speech.isListening;
  }

  @override
  Future<void> startListening(
      {required Function(String text) onResult, String? localeId}) async {
    if (!_isInitialized) {
      await initSpeechService();
    }

    if (!_speech.isListening) {
      await _speech.listen(
        onResult: (result) {
          final recognizedWords = result.recognizedWords;
          onResult(recognizedWords);
        },
        localeId: localeId ?? 'es_ES',
        cancelOnError: true,
        partialResults: true,
      );
    }
  }

  @override
  Future<void> stopListening() async {
    if (_speech.isListening) {
      await _speech.stop();
    }
  }
}
