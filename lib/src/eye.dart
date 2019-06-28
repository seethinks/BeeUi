import 'package:beeui/src/icon.dart';
import 'package:flutter/material.dart';

class Eye extends StatefulWidget {
  final Function onPress;
  final Color color;
  const Eye({Key key, this.onPress, this.color}) : super(key: key);
  @override
  _EyeState createState() => _EyeState();
}

class _EyeState extends State<Eye> {
  bool status = true;
  @override
  Widget build(BuildContext context) {
    return InkResponse(
      borderRadius: BorderRadius.circular(2),
      onTap: () {
        setState(() {
          status = !status;
          widget.onPress ?? widget.onPress();
        });
      },
      child: Icon(
        status ? BeeIcon.eyeOpen : BeeIcon.eyeClose,
        color: widget.color ?? Colors.white,
      ),
      // child: Text("2121"),
    );
  }
}
