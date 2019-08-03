import 'package:flutter/material.dart';

class Dialog {
  alert(BuildContext context, Text title, Text content, List<Widget> actions) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: title,
              content: content,
              actions: actions,
            ));
  }
}
