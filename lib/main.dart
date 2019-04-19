import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:battery/battery.dart';
import 'package:screen/screen.dart';

import 'preferences.dart';
import 'speech_control.dart';

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
    );
  }
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

  @override
  initState() {
    super.initState();
    battery.onBatteryStateChanged.listen((BatteryState state) {
      bool keepScreenOn = (state != BatteryState.discharging);
      Screen.keepOn(keepScreenOn);
    });
    speechControl.requestPermission();
    speechControl.init();
    speechControl.setOnRecognitionCompletedCallback((String text) {
      inputStringController.text = text;
      sendToHost();
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
        tooltip: 'pause VoiceControl',
        child: Icon(Icons.pause)
      );
    } else {
      return new FloatingActionButton(
        onPressed: startSpeechRecognition,
        tooltip: 'start VoiceControl',
        child: Icon(Icons.record_voice_over)
      );
    }
  }

  void readClipboard() async {
    final data = await Clipboard.getData('text/plain');
    if (data?.text?.isEmpty ?? true) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: new Text('Clipboard is empty'),
          duration: new Duration(seconds: 5),
          backgroundColor: Colors.red,
        )
      );
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Input from clipboard'),
          content: Text(data.text),
          actions: <Widget>[
            FlatButton(
              child: Text('Send'),
              onPressed: () {
                inputStringController.text = data.text;
                sendToHost();
                Navigator.of(context).pop();
              }
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop()
            )
          ]
        );
      }
    );
  }

  void sendToHost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final body = {
      "data": this.inputStringController.text
    };
    final url = prefs.getString('hostURL');

    Dio dio = new Dio();
    dio.options.connectTimeout = 3000;
    dio.options.receiveTimeout = 3000;
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
        client.badCertificateCallback=(X509Certificate cert, String host, int port) {
          return true;
        };
    };
    Response response;
    dio.post(url + '/input', data: body)
      .then((res) { response = res;})
      .whenComplete(() {
        if (response?.statusCode != 200) {
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: new Text('Post text failed. ($url)'),
              duration: new Duration(seconds: 5),
              backgroundColor: Colors.red,
            )
          );
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyPreferencesPage()),
            );            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Input String',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: new Icon(MdiIcons.clipboardArrowLeftOutline),
                        onPressed: readClipboard
                      )
                    ),
                      
                  controller: inputStringController,
                  onSaved: (String value) => this.inputStringController.text = value,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: speechControlButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      key: _scaffoldKey
    );
  }
}
