import 'package:flutter/material.dart';

import '../enums.dart';

class Button extends StatelessWidget {
  ButtonType type;
  String size;
  String text;
  final double radius;
  final Color color;
  bool disabled;
  Function onPress;

  Button(
    this.text, {
    Key key,
    this.disabled,
    this.type = ButtonType.primary,
    this.size,
    this.color,
    this.radius = 4,
    this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (type == ButtonType.primary) {
      return FlatButton(
        padding: EdgeInsets.symmetric(vertical: 10),
        onPressed: disabled == true ? null : _log,
        child: Text(text, style: TextStyle(fontSize: 14)),
        color: color ?? Theme.of(context).buttonColor,
        textColor: Colors.white,
        // shape: RoundedRectangleBorder(
        //     side: BorderSide(
        //       color: Colors.white,
        //       width: 1,
        //     ),
        //     borderRadius: BorderRadius.circular(radius)),
      );
    }

    if (type == ButtonType.gost) {
      return OutlineButton(
        onPressed: disabled == true ? null : _log,
        child: Text(text),
        borderSide:
            new BorderSide(color: color ?? Theme.of(context).primaryColor),
        textColor: Theme.of(context).primaryColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      );
    }
  }

  _log() {
    if (onPress is Function) {
      onPress();
    }
  }
}
