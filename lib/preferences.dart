import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'speech_control.dart';
import 'language-selector.dart';

class MyPreferencesPage extends StatefulWidget {
  MyPreferencesPage({Key key, this.speechControl, this.prefs}) : super(key: key);

  final String title = 'Preferences';
  final SpeechControl speechControl;
  final SharedPreferences prefs;

  @override
  _MyPreferencesPageState createState() => _MyPreferencesPageState();
}

class _MyPreferencesPageState extends State<MyPreferencesPage> {
  var hostUrlController = new TextEditingController();
  String _currentLanguage = "";

  @override
  initState() {
    super.initState();
    loadPreferencesValue();
  }

  loadPreferencesValue() {
    setState(() {
      hostUrlController.text = widget.prefs.getString('hostURL');
      _currentLanguage = widget.prefs.getString('language');
      _currentLanguage = _currentLanguage ?? widget.speechControl.preferedLocale;
    });
  }

  savePreferencesValue() {
    setState(() {
      widget.prefs.setString('hostURL', hostUrlController.text);
      widget.prefs.setString('language', _currentLanguage);
      widget.speechControl.preferedLocale = _currentLanguage;
    });
  }

  scanQRCode() {
    setState(() async {
      final data = await new QRCodeReader()
        .setForceAutoFocus(true) // default false
        .setTorchEnabled(true) // default false
        .scan();
      hostUrlController.text = data;
    });
  }

  onLanguageChanged(String language) {
    _currentLanguage = language;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Host URL',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: new Icon(MdiIcons.qrcodeScan),
                      onPressed: scanQRCode
                    )
                ),
                controller: hostUrlController,
              ),
              LanguageSelector(
                currentLanguage: _currentLanguage,
                languages: widget.speechControl.supportedLocales,
                onChanged: onLanguageChanged
               )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          savePreferencesValue();
          Navigator.pop(context);
        },
        tooltip: 'Save',
        child: new Icon(Icons.check),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
