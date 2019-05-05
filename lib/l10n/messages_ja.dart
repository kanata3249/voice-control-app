// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ja locale. All the
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
  get localeName => 'ja';

  static m0(url) => "ボタン設定の読込み失敗\nURL: ${url}";

  static m1(url) => "送信失敗\nURL: ${url}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "cancel" : MessageLookupByLibrary.simpleMessage("Cancel"),
    "clipboardEmpty" : MessageLookupByLibrary.simpleMessage("クリップボードは空です"),
    "defaultLocale" : MessageLookupByLibrary.simpleMessage("端末設定に従う"),
    "emptyButtonSettings" : MessageLookupByLibrary.simpleMessage("ボタン設定なし"),
    "hostUrl" : MessageLookupByLibrary.simpleMessage("ホストURL"),
    "inputFromClipboard" : MessageLookupByLibrary.simpleMessage("クリップボードから入力"),
    "inputText" : MessageLookupByLibrary.simpleMessage("入力テキスト"),
    "loadButtonFailed" : m0,
    "pause" : MessageLookupByLibrary.simpleMessage("音声入力開始"),
    "preferencesTitle" : MessageLookupByLibrary.simpleMessage("設定"),
    "privacyPolicyLabel" : MessageLookupByLibrary.simpleMessage("プライバシーポリシーについて"),
    "save" : MessageLookupByLibrary.simpleMessage("保存"),
    "send" : MessageLookupByLibrary.simpleMessage("送信"),
    "sendFailed" : m1,
    "speechRecognitionLocale" : MessageLookupByLibrary.simpleMessage("音声言語:"),
    "start" : MessageLookupByLibrary.simpleMessage("音声入力停止")
  };
}
