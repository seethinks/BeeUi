import 'package:flutter/material.dart';

class CheckBox extends StatefulWidget {
  final Function onChange;
  final Widget label;
  const CheckBox({Key key, this.onChange, this.label}) : super(key: key);
  @override
  _CheckBoxState createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  bool _checkboxSelected = true; //维护复选框状态
  @override
  Widget build(BuildContext context) {
    List<Widget> arr = [
      Transform.scale(
          scale: 0.8,
          child: Checkbox(
            tristate: true,
            value: _checkboxSelected,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            activeColor: Theme.of(context).primaryColor, //选中时的颜色
            onChanged: (value) {
              // setState(() {
              //   _checkboxSelected = value;
              // });
              if (widget.onChange is Function) {
                widget.onChange(_checkboxSelected);
              }
            },
          ))
    ];

    if (widget.label != null) {
      arr.add(widget.label);
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          _checkboxSelected = !_checkboxSelected;
        });
      },
      child: Row(
        children: arr,
      ),
    );
  }
}
