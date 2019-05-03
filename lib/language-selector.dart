import 'package:flutter/material.dart';

class LanguageSelector extends StatefulWidget {
  LanguageSelector({Key key, this.currentLanguage, this.languages, this.decoration, this.onChanged }) : super(key: key);
  
  final String currentLanguage;
  final List<String> languages;
  final ValueChanged<String> onChanged;
  final InputDecoration decoration;

  @override
  _LanguageSelectorState createState() => new _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  String _currentLanguage;

  @override
  void initState() {
    super.initState();
    _currentLanguage = widget.currentLanguage;
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(context);
  }

  Widget _buildTiles(BuildContext context) {
    return InputDecorator(
      key: Key(_currentLanguage),
      decoration: widget.decoration,
      isEmpty: false,
      child:
        DropdownButtonHideUnderline (
          child: DropdownButton<String> (
            value: _currentLanguage,
            items: widget.languages.map((language) =>
              DropdownMenuItem<String>(
                value: language,
                child: Text(language)
              )
            ).toList(),
            onChanged: (String selectedValue) => setState(() {
              _currentLanguage = selectedValue;
              widget.onChanged(selectedValue);
            }),
          )
        )
    );
  }
}