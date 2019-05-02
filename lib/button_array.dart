import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'messages.dart';

class ButtonArray extends StatefulWidget {
  ButtonArray({Key key, this.buttonSettings, this.onPressed}) : super(key: key);

  final buttonSettings;
  final onPressed;

  @override
  _ButtonArrayState createState() => _ButtonArrayState();
}

class _ButtonArrayState extends State<ButtonArray>
    with SingleTickerProviderStateMixin {
  List<Tab> _tabs = List<Tab>();
  List<Widget> _tabContents = List<Widget>();
  TabController _tabController;

  @override
  initState() {
    super.initState();
    _tabController = TabController(length: 10, vsync: this);
  }

  void prepareTabContents() {
    _tabs = List<Tab>();
    _tabContents = List<Widget>();

    for (var tab in widget.buttonSettings["tab"]) {
      List<Widget> buttons;

      _tabs.add(Tab(text: tab["label"]));
      buttons = tab["buttons"].map<Widget>((button) =>
        Padding( padding: EdgeInsets.only(top: 12.0, right: 12.0, left: 12.0),
          child: OutlineButton(
            child: Text(button['label']),
            onPressed: () => widget.onPressed(button['action']),
            borderSide: BorderSide(color: Colors.blue),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))
          )
        )
      ).toList();
      _tabContents.add(
         StaggeredGridView.count(
          crossAxisCount: 2,
          scrollDirection: Axis.vertical,
          staggeredTiles: buttons.map<StaggeredTile>((_) => StaggeredTile.fit(1)).toList(),
          children: buttons,
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.buttonSettings == null) {
      return Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(Messages.of(context).emptyButtonSettings)
      );
    }
    prepareTabContents();
    return Column(children: <Widget>[
      TabBar(
        tabs: _tabs,
        controller: _tabController,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.blue,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorWeight: 2,
        indicatorPadding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
        labelColor: Colors.black,
      ),
      Expanded(
        child: TabBarView(
          controller: _tabController,
          children: _tabContents
        )
      )
    ]);
  }
}
