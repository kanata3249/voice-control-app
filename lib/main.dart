import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:io';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:battery/battery.dart';
import 'package:screen/screen.dart';

import 'messages.dart';
import 'preferences.dart';
import 'speech_control.dart';
import 'button_array.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Control',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Voice Control'),
      localizationsDelegates: [
        const _MyLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('ja', ''),
      ],
    );
  }
}

class _MyLocalizationsDelegate extends LocalizationsDelegate<Messages> {
  const _MyLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en','ja'].contains(locale.languageCode);

  @override
  Future<Messages> load(Locale locale) => Messages.load(locale);

  @override
  bool shouldReload(_MyLocalizationsDelegate old) => false;
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var battery = Battery();
  var inputStringController = new TextEditingController();
  SpeechControl speechControl = new SpeechControl();
  bool _isMuted = true;
  var buttons;
  Dio dio;
  SharedPreferences _prefs;

  @override
  initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;

      speechControl.requestPermission();
      speechControl.init();
      speechControl.preferedLocale = prefs.getString("language") ?? speechControl.defaultLocale;
      speechControl.setOnRecognitionCompletedCallback((String text) {
        inputStringController.text = text;
        sendToHost();
      });

      dio = new Dio();
      dio.options.connectTimeout = 3000;
      dio.options.receiveTimeout = 3000;
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) {
          return true;
        };
      };

      loadButtonSetting();
    });

    battery.onBatteryStateChanged.listen((BatteryState state) {
      bool keepScreenOn = (state != BatteryState.discharging);
      Screen.isKeptOn.then((bool keepOn) {
        if (keepOn != keepScreenOn) {
          Screen.keepOn(keepScreenOn);
        }
      });
    });
  }

  startSpeechRecognition() {
    speechControl.start();
    setState(() => _isMuted = false);
  }

  pauseSpeechRecognition() async {
    speechControl.pause();
    setState(() => _isMuted = true);
  }

  speechControlButton() {
    if (!_isMuted) {
      return new FloatingActionButton(
          onPressed: pauseSpeechRecognition,
          tooltip: Messages.of(context).pause,
          child: Icon(Icons.pause));
    } else {
      return new FloatingActionButton(
          onPressed: startSpeechRecognition,
          tooltip: Messages.of(context).start,
          child: Icon(Icons.record_voice_over));
    }
  }

  void readClipboard() async {
    final data = await Clipboard.getData('text/plain');
    if (data?.text?.isEmpty ?? true) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: new Text(Messages.of(context).clipboardEmpty),
        duration: new Duration(seconds: 5),
        backgroundColor: Colors.red,
      ));
      return;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(Messages.of(context).inputFromClipboard),
              content: Text(data.text),
              actions: <Widget>[
                FlatButton(
                    child: Text(Messages.of(context).send),
                    onPressed: () {
                      inputStringController.text = data.text;
                      sendToHost();
                      Navigator.of(context).pop();
                    }),
                FlatButton(
                    child: Text(Messages.of(context).cancel),
                    onPressed: () => Navigator.of(context).pop())
              ]);
        });
  }

  void showErrorMessage(String message, int duration) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: new Text(message),
      duration: new Duration(seconds: duration),
      backgroundColor: Colors.red,
    ));
  }

  void sendToHost() async {
    final body = {"data": this.inputStringController.text};
    final url = _prefs.getString('hostURL');

    Response response;
    dio.post(url + '/input', data: body).then((Response res) {
      response = res;
    }).whenComplete(() {
      if (response?.statusCode != 200) {
        showErrorMessage(Messages.of(context).sendFailed(url), 5);
      }
    });
  }

  void loadButtonSetting() {
    final url = _prefs.getString('hostURL');
    if (url == null) {
      return;
    }
    Response response;
    dio.get(url + '/buttons').then ((Response res) {
      response = res;
    }).whenComplete(() {
      if (response?.statusCode == 200) {
        setState(() => buttons = response.data);
     } else {
       showErrorMessage(Messages.of(context).loadButtonFailed(url), 5);
     }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Messages.of(context).applicationTitle),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                loadButtonSetting();
              }
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyPreferencesPage(speechControl: speechControl, prefs: _prefs)),
                );
              },
            )
          ],
        ),
        body: Column(children: [
          Expanded(
            child: ButtonArray(
                buttonSettings: buttons,
                onPressed: (action) {
                  inputStringController.text = action;
                  sendToHost();
                }),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16.0, left: 16.0, bottom: 90.0),
            child: Form(
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: Messages.of(context).inputText,
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                        icon: new Icon(MdiIcons.clipboardArrowLeftOutline),
                        onPressed: readClipboard)),
                controller: inputStringController,
                onSaved: (String value) =>
                    this.inputStringController.text = value,
              ),
            ),
          ),
        ]),
        floatingActionButton: speechControlButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        key: _scaffoldKey);
  }
}
