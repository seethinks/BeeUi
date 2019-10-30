import 'package:flutter/material.dart';

import 'bottom_sheet_fix.dart';

class BeeUi {
  static showBottomModal(
      {@required BuildContext context,
      @required WidgetBuilder builder,
      bool dismissOnTap = true,
      String title}) {
    assert(context != null);
    assert(builder != null);

    final List<Widget> arr = [];

    if (title != null) {
      arr.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[Text(title), Text("取消")],
        ),
      );
      arr.add(SizedBox(
        height: 10,
      ));
    }

    return showModalBottomSheetApp<Null>(
        context: context,
        dismissOnTap: true,
        builder: (BuildContext context) {
          return new Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                // borderRadius:
                //     BorderRadius.vertical(top: Radius.circular(16))
              ),
              // padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[builder(context)],
              ));
        });
  }

  static showBottomButtonsModal(
      {@required BuildContext context,
      @required List<Widget> buttons,
      bool dismissOnTap = true}) {
    assert(context != null);
    assert(buttons != null);

    buttons.add(Container(
      color: Colors.black,
      height: 5,
    ));
    buttons.add(ListTile(
        title: Text("取消",
            style: TextStyle(color: Theme.of(context).textTheme.body1.color),
            textAlign: TextAlign.center)));

    return BeeUi.showBottomModal(
        context: context,
        builder: (BuildContext context) {
          return Column(
              children: ListTile.divideTiles(
            context: context,
            tiles: buttons,
          ).toList());
        });
  }

  static alert(BuildContext context,
      {Text title, Widget content, List<Widget> actions}) {
    return showDialog(
        context: context,
        // builder: (context) {
        //   return Theme(
        //     data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.orange),
        //     child: AlertDialog(
        //       title: title,
        //       content: content,
        //       actions: actions,
        //     ),
        //   );
        // };

        builder: (context) => AlertDialog(
              title: title,
              content: content,
              actions: actions,
            ));
  }
}
