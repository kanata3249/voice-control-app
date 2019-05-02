// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a messages locale. All the
// messages from the main program should be duplicated here with the same
// function name.

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

// ignore: unnecessary_new
final messages = new MessageLookup();

// ignore: unused_element
final _keepAnalysisHappy = Intl.defaultLocale;

// ignore: non_constant_identifier_names
typedef MessageIfAbsent(String message_str, List args);

class MessageLookup extends MessageLookupByLibrary {
  get localeName => 'messages';

  static m0(url) => "Can\'t not load button settings\nURL: ${url}";

  static m1(url) => "Post text failed\nURL: ${url}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "applicationTitle" : MessageLookupByLibrary.simpleMessage("Voice Control"),
    "cancel" : MessageLookupByLibrary.simpleMessage("Cancel"),
    "clipboardEmpty" : MessageLookupByLibrary.simpleMessage("Clipboard is empty"),
    "defaultLocale" : MessageLookupByLibrary.simpleMessage("default"),
    "emptyButtonSettings" : MessageLookupByLibrary.simpleMessage("Button settings empty."),
    "hostUrl" : MessageLookupByLibrary.simpleMessage("Host URL"),
    "inputFromClipboard" : MessageLookupByLibrary.simpleMessage("Input from clipboard"),
    "inputText" : MessageLookupByLibrary.simpleMessage("Input String"),
    "loadButtonFailed" : m0,
    "pause" : MessageLookupByLibrary.simpleMessage("pause VoiceControl"),
    "preferencesTitle" : MessageLookupByLibrary.simpleMessage("Preferences"),
    "save" : MessageLookupByLibrary.simpleMessage("Save"),
    "send" : MessageLookupByLibrary.simpleMessage("Send"),
    "sendFailed" : m1,
    "speechRecognitionLocale" : MessageLookupByLibrary.simpleMessage("Speech recognition locale:"),
    "start" : MessageLookupByLibrary.simpleMessage("start VoiceControl")
  };
}
