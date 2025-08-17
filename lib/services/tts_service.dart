import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final FlutterTts _tts = FlutterTts();

  static Future<void> speak(String text) async {
    await _tts.setLanguage("de-DE");
    await _tts.setSpeechRate(0.6);
    await _tts.speak(text);
  }
}
