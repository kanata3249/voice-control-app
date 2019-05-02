import 'dart:math';
import 'package:flutter/material.dart';

import 'messages.dart';

class LanguageSelector extends StatefulWidget {
  LanguageSelector({Key key, this.currentLanguage, this.languages, this.onChanged }) : super(key: key);
  
  final String currentLanguage;
  final List<String> languages;
  final ValueChanged<String> onChanged;

  @override
  _LanguageSelectorState createState() => new _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  int _key;
  String _currentLanguage;

  @override
  void initState() {
    super.initState();
    _currentLanguage = widget.currentLanguage;
    _collapse();
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(context);
  }

  Widget _buildTiles(BuildContext context) {
    return ExpansionTile(
      key: Key(_key.toString()),
      initiallyExpanded: false,
      title: Row(
        children: [
          Text(Messages.of(context).speechRecognitionLocale),
          Expanded(
            child: Text(_currentLanguage, textAlign: TextAlign.center )
          )
        ]
      ),
      children: [
        SizedBox(
          height: 380.0,
          child: ListView(
            shrinkWrap: false,
            children: new List.generate(widget.languages.length, (int index) {
              return new ListTile(
                title: new Text(widget.languages[index]),
                trailing: _currentLanguage == widget.languages[index]
                    ? new Icon(Icons.check, color: Colors.green)
                    : null,
                selected: _currentLanguage == widget.languages[index],
                onTap: () {
                  setState(() {
                    _currentLanguage = widget.languages[index];
                    _collapse();
                    widget.onChanged(_currentLanguage);
                  });
                }
              );
            })
          )
        )
      ]
    );
  }

  _collapse() {
    int newKey;
    do {
      _key = new Random().nextInt(10000);
    } while (newKey == _key);
  }
}