import 'package:speech_recognition/speech_recognition.dart';
import 'package:simple_permissions/simple_permissions.dart';

typedef void StringCallback(String value);

class SpeechControl {
  SpeechRecognition speech;
  bool speechRecognitionAvailable = false;
  bool isMuted = true;
  bool isListening = false;
  String currentLocale;
  Future future;

  StringCallback onRecognitionCompleted = (String text) => {};

  requestPermission() async {
    final PermissionStatus res = await SimplePermissions.requestPermission(Permission.RecordAudio);
    if (res == PermissionStatus.deniedNeverAsk) {
      SimplePermissions.openSettings();
    }
  }

  void init() {
    speech = new SpeechRecognition();

    speech.setCurrentLocaleHandler(
      (String locale) {
        currentLocale = locale;
      }
    );

    speech.setAvailabilityHandler(
      (bool result) {
        if (!result && speechRecognitionAvailable) {
          continueSpeechRecognition();
        }
        speechRecognitionAvailable = result;
      }
    );

    speech.setRecognitionResultHandler(
      (String text) {
        if (text.length != 0) {
          // ignore partial result
        }
      }
    );

    speech.setRecognitionStartedHandler(
      () {
        isListening = true;
      }
    );

    speech.setRecognitionCompleteHandler(
      (String text) {
        isListening = false;
        if (text.length != 0) {
          onRecognitionCompleted(text);
        }
        continueSpeechRecognition();
      }
    );

    speech.activate().then(
      (res) {
        speechRecognitionAvailable = res;
      }
    );
  }

  start() {
    speech.listen(locale:currentLocale);
    isMuted = false;
  }

  pause() async {
    await future;
    speech.stop().then((result) {
        isListening = result;
    });
    isMuted = true;
  }

  setOnRecognitionCompletedCallback(StringCallback callback) {
    onRecognitionCompleted = callback;
  }

  continueSpeechRecognition() {
    if (!isMuted && future == null) {
      future = new Future.delayed(const Duration(milliseconds: 100), () {
        speech.listen(locale:currentLocale);
        future = null;
      });
    }
  }
}
