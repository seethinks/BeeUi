import 'package:beeui/src/icon.dart';
import 'package:flutter/material.dart';

class Eye extends StatefulWidget {
  final Function onChange;
  final bool defaultOpen;
  final Color color;
  const Eye({Key key, this.onChange, this.color, this.defaultOpen = true})
      : super(key: key);
  @override
  _EyeState createState() => _EyeState();
}

class _EyeState extends State<Eye> {
  bool _status;

  @override
  void initState() {
    _status = widget.defaultOpen;
  }

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      borderRadius: BorderRadius.circular(2),
      onTap: () {
        if (!mounted) return;
        setState(() {
          _status = !_status;
        });
        if (widget.onChange is Function) {
          widget.onChange(_status);
        }
      },
      child: Icon(
        _status ? BeeIcon.eyeOpen : BeeIcon.eyeClose,
        color: widget.color ?? Colors.white,
      ),
      // child: Text("2121"),
    );
  }
}
