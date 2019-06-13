import 'package:beeui/src/icon.dart';
import 'package:flutter/material.dart';

import '../enums.dart';

class XSelect extends StatelessWidget {
  BoxDecoration decoration;
  final String label;
  final FormLayout layout;
  final String placeholder;
  final bool disabled;
  final Function onPress;
  final String value;

  XSelect(
      {Key key,
      this.decoration,
      this.value,
      this.label,
      this.placeholder,
      this.disabled = false,
      this.onPress,
      this.layout = FormLayout.horizontal})
      : super(key: key);
  Widget buildTextField() {
    const TextStyle labelStyle = TextStyle(color: Colors.white, fontSize: 12.0);
    bool isVertical = layout == FormLayout.vertical;
    var arr = <Widget>[];
    if (label != null) {
      var _label = Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Text(label, textAlign: TextAlign.left, style: labelStyle));
      arr.add(_label);
    }

    var textField = Container(
        margin: EdgeInsets.fromLTRB(isVertical ? 0 : 10, 0, 0, 0),
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        decoration: decoration,
        // decoration: BoxDecoration(color: Color(0xFFe8e8e8)),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(value != null ? value : placeholder),
            ),
            Icon(
              BeeIcon.rightArrow,
              color: Colors.grey,
              size: 22,
            )
          ],
        ));

    arr.add(isVertical ? textField : Expanded(child: textField));

    //如果是垂直布局
    if (isVertical) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: arr);
    } else {
      return Row(children: arr);
    }
  }

  @override
  Widget build(BuildContext context) {
    decoration = BoxDecoration(
      border: Border(bottom: BorderSide(color: Color(0xFFe8e8e8), width: 1)),
    );

    return Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: InkWell(
          key: key,
          onTap: () {
            if (disabled is bool && disabled == false && onPress is Function) {
              onPress();
            }
          },
          child: buildTextField(),
        ));
  }
}
