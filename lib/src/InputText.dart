import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../enums.dart';

class InputText extends StatelessWidget {
  final TextAlign textAlign; // 对齐方式
  final int maxLength; //最大长度
  final String type; //类型
  final bool disabled; // 是否禁用
  final Function onChange; //内容改变回调
  final Function onSubmit; //提交回调
  final bool autofocus; ////是否自动对焦
  final String placeholder;
  String label;
  final Widget icon;
  String defaultValue; //默认值
  final FormLayout layout;
  BoxDecoration decoration;
  final Function validator;

  InputText(
      {Key key,
      this.textAlign = TextAlign.left,
      this.disabled = false,
      this.type = "text",
      this.label,
      this.defaultValue,
      this.icon,
      this.placeholder,
      this.onChange,
      this.onSubmit,
      this.layout = FormLayout.horizontal,
      this.decoration,
      this.validator,
      this.autofocus = false,
      this.maxLength = 30})
      : super(key: key);

  Widget buildTextField(TextEditingController controller) {
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
        // padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
        decoration: decoration,
        // decoration: BoxDecoration(color: Color(0xFFe8e8e8)),
        child: TextFormField(
            controller: controller,
            maxLength: maxLength,
            maxLines: 1, //最大行数
            autocorrect: true, //是否自动更正
            keyboardType: TextInputType.number,
            autofocus: autofocus, //是否自动对焦
            obscureText: type == "password", //密码自动隐藏文本为*
            // textAlign: textAlign, //文本对齐方式
            // style: TextStyle(fontSize: 12.0, color: Colors.white), //输入文本的样式
            inputFormatters: [
              // WhitelistingTextInputFormatter.digitsOnly,
              // LengthLimitingTextInputFormatter(11),
              WhitelistingTextInputFormatter(RegExp("[0-9.]"))
            ], //允许的输入格式
            // onChanged: (text) {
            //   if (onChange is Function) {
            //     onChange(text);
            //   }
            // },
            // onSubmitted: (text) {
            //   if (onSubmit is Function) {
            //     onSubmit(text);
            //   }
            // },
            validator: (v) {
              if (validator is Function) {
                return validator();
              }
              return null;
            },
            enabled: !disabled, //是否禁用
            // onFieldSubmitted: (String value) {
            //   setState(() {
            //     _deskripsiController.text = value;
            //   });
            // },
            decoration: InputDecoration(
              // prefixText: layout == InputTextLayout.horizontal ? label : null,
              // prefixStyle: labelStyle,
              contentPadding: EdgeInsets.fromLTRB(0, 10, 10, 10),
              hintText: placeholder,
              prefixIcon: icon,
              counterText: "",
              border: InputBorder.none, //隐藏下划线
              // border: OutlineInputBorder(), //隐藏下划线
            )));

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
    final controller = TextEditingController();

    if (defaultValue != null) {
      controller.text = defaultValue;
    }

    controller.addListener(() {
      if (onChange is Function) {
        String text = controller.text;
        onChange(text);
      }
      print('input ${controller.text}');
    });

    // icon和label同时存在时，icon的优先级最高
    if (icon != null) {
      label = null;
    }

    print("decoration${decoration}");

    decoration = BoxDecoration(
      border: Border(bottom: BorderSide(color: Color(0xFFe8e8e8), width: 1)),
    );

    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      // padding: const EdgeInsets.all(8.0),
      // alignment: Alignment.center,
      // height: 40.0,
      child: buildTextField(controller),
    );
  }
}
