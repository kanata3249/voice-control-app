import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MyPreferencesPage extends StatefulWidget {
  MyPreferencesPage({Key key}) : super(key: key);

  final String title = 'Preferences';

  @override
  _MyPreferencesPageState createState() => _MyPreferencesPageState();
}

class _MyPreferencesPageState extends State<MyPreferencesPage> {
  var hostUrlController = new TextEditingController();

  @override
  initState() {
    super.initState();
        loadPreferencesValue();
  }

  loadPreferencesValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      hostUrlController.text = prefs.getString('hostURL');
    });
  }

  savePreferencesValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('hostURL', hostUrlController.text);
    });
  }

  void scanQRCode() {
    setState(() async {
      final data = await new QRCodeReader()
        .setForceAutoFocus(true) // default false
        .setTorchEnabled(true) // default false
        .scan();
      hostUrlController.text = data;
    });
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
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          savePreferencesValue().then({Navigator.pop(context)})
        },
        tooltip: 'Save',
        child: new Icon(Icons.check),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
