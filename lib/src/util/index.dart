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

    const arr = [];

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
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16))),
              padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[builder(context)],
              ));
        });
  }
}
