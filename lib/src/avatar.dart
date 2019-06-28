import 'package:flutter/material.dart';

enum AvatarShape {
  circle,
  square,
}

class Avatar extends StatelessWidget {
  final Icon icon;
  final String src;
  final AvatarShape shape;
  final double size;

  Avatar(
      {Key key,
      this.icon,
      this.shape = AvatarShape.circle,
      this.src,
      this.size = 50})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Image _img;
    Icon _icon;

    if (icon != null) {
      _icon = icon;
    }

    final bool isLocal = isLocalAsset(src);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape:
            shape == AvatarShape.circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: shape == AvatarShape.square
            ? BorderRadius.circular(6.0)
            : null, // 圆形不能设置borderRadius
        image: DecorationImage(
          image: isLocal == true ? AssetImage(src) : NetworkImage(src),
        ),
        color: Colors.grey[300],
      ),
      // child: _img,
    );
    // );
  }

  bool isLocalAsset(String path) {
    return path.indexOf("http") == -1;
  }
}
