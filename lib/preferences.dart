import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'messages.dart';
import 'speech_control.dart';
import 'language-selector.dart';

class MyPreferencesPage extends StatefulWidget {
  MyPreferencesPage({Key key, this.speechControl, this.prefs}) : super(key: key);

  final SpeechControl speechControl;
  final SharedPreferences prefs;

  @override
  _MyPreferencesPageState createState() => _MyPreferencesPageState();
}

class _MyPreferencesPageState extends State<MyPreferencesPage> {
  var hostUrlController = new TextEditingController();
  String _currentLanguage = "";
  List<String> _supportedLanguages;

  @override
  initState() {
    super.initState();
    loadPreferencesValue();
  }

  loadPreferencesValue() {
    setState(() {
      hostUrlController.text = widget.prefs.getString('hostURL');
      _currentLanguage = widget.prefs.getString('language');
      _currentLanguage = _currentLanguage ?? widget.speechControl.defaultLocale;
      _supportedLanguages = null;
    });
  }

  savePreferencesValue() {
    setState(() {
      widget.prefs.setString('hostURL', hostUrlController.text);
      widget.prefs.setString('language', _currentLanguage);
      widget.speechControl.preferedLocale = _currentLanguage;
    });
  }

  scanQRCode() async {
    final Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.camera]);
//    if (permissions[PermissionGroup.microphone] == PermissionStatus.deniedNeverAsk) {
//      SimplePermissions.openSettings();
//    }


    if (permissions[PermissionGroup.camera] == PermissionStatus.granted) {
      final data = await new QRCodeReader()
        .setForceAutoFocus(true) // default false
        .setTorchEnabled(true) // default false
        .scan();
      setState(() {
        hostUrlController.text = data;
      });
    }
  }

  onLanguageChanged(String language) {
    _currentLanguage = language;
    if (language == _supportedLanguages[0]) {
      _currentLanguage = widget.speechControl.defaultLocale;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_supportedLanguages == null) {
      _supportedLanguages = List<String>.from(widget.speechControl.supportedLocales);
      _supportedLanguages.insert(0, Messages.of(context).defaultLocale);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(Messages.of(context).preferencesTitle),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: Messages.of(context).hostUrl,
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(MdiIcons.qrcodeScan),
                    onPressed: scanQRCode
                  )
                ),
                controller: hostUrlController,
              ),
              Padding( padding: EdgeInsets.all(8.0) ),
              LanguageSelector(
                currentLanguage: _currentLanguage == widget.speechControl.defaultLocale ? _supportedLanguages[0] : _currentLanguage,
                decoration: InputDecoration(
                  labelText: Messages.of(context).speechRecognitionLocale,
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.only(left: 10.0, right: 10.0, top: 4.0, bottom: 4.0)
                ),
                languages: _supportedLanguages,
                onChanged: onLanguageChanged
              ),
              Expanded(
                child: Padding(padding: EdgeInsets.all(0.0))
              ),
              Padding(
                padding: EdgeInsets.only( bottom: 20.0, left: 5.0 ),
                child: Row(
                  children: [
                    InkWell(
                      child: Text(
                        Messages.of(context).privacyPolicyLabel,
                        style: TextStyle(decoration: TextDecoration.underline, fontSize: 16.0, color: Colors.blue)
                      ),
                      onTap: () async {
                        final String url = Messages.of(context).privacyPolicyURL;
                        if (await canLaunch(url)) {
                          await launch(url);
                        }
                      }
                    ),
                  ]
                )
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
        tooltip: Messages.of(context).save,
        child: new Icon(Icons.check),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
