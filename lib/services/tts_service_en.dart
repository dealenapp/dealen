import 'package:flutter_tts/flutter_tts.dart';

class TtsServiceEn {
  static final FlutterTts _tts = FlutterTts();

  static Future<void> speak(String text) async {
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.6);
    await _tts.speak(text);
  }
}
