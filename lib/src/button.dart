import 'package:flutter/material.dart';

import '../enums.dart';

class Button extends StatelessWidget {
  ButtonType type;
  String size;
  String text;
  bool disabled;
  Function onPress;

  Button(
    this.text, {
    Key key,
    this.disabled,
    this.type = ButtonType.primary,
    this.size,
    this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (type == ButtonType.primary) {
      return FlatButton(
        onPressed: disabled == true ? null : _log,
        child: Padding(padding: EdgeInsets.all(10.0), child: Text(text)),
        color: Colors.blue,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.white,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(6)),
      );
    }

    if (type == ButtonType.gost) {
      return OutlineButton(
        onPressed: disabled == true ? null : _log,
        child: Padding(padding: EdgeInsets.all(10.0), child: Text(text)),
        borderSide: new BorderSide(color: Theme.of(context).primaryColor),
        textColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      );
    }
  }

  _log() {
    if (onPress is Function) {
      onPress();
    }
  }
}
