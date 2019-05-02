import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import './l10n/messages_all.dart';

class Messages {
  static Future<Messages> load(Locale locale) {
    final String name = locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return new Messages();
    });
  }

  static Messages of(BuildContext context) {
    return Localizations.of<Messages>(context, Messages);
  }

  static final Messages instance = new Messages();

  String get pause => Intl.message('pause VoiceControl', name: "pause");
  String get start => Intl.message('start VoiceControl', name: "start");
  String get send => Intl.message('Send', name: "send");
  String get cancel => Intl.message('Cancel', name: "cancel");
  String get save => Intl.message('Save', name: "save");
  String get clipboardEmpty => Intl.message('Clipboard is empty', name: "clipboardEmpty");
  String get inputText => Intl.message('Input String', name: "inputText");
  String get inputFromClipboard => Intl.message('Input from clipboard', name: "inputFromClipboard");
  String sendFailed(url) => Intl.message('Post text failed\nURL: $url', name: "sendFailed", args: [url]);
  String loadButtonFailed(url) => Intl.message('Can\'t not load button settings\nURL: $url', name: "loadButtonFailed", args: [url]);
  String get emptyButtonSettings => Intl.message('Button settings empty.', name: "emptyButtonSettings");
  String get speechRecognitionLocale => Intl.message('Speech recognition locale:', name: "speechRecognitionLocale");
  String get preferencesTitle => Intl.message('Preferences', name: "preferencesTitle");
  String get applicationTitle => Intl.message('Voice Control', name: "applicationTitle");
  String get hostUrl => Intl.message('Host URL', name: "hostUrl");
  String get defaultLocale => Intl.message('default', name: "defaultLocale");
}