import 'dart:io';

import 'package:beeui/bee.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ImgUpload extends StatefulWidget {
  final Widget placeholder;
  final double width;
  final double height;
  final value;
  final Function onCrop;
  const ImgUpload(
      {this.placeholder,
      this.width,
      this.value,
      this.height,
      this.onCrop,
      Key key})
      : super(key: key);
  @override
  _ImgUploadState createState() => _ImgUploadState();
}

class _ImgUploadState extends State<ImgUpload> {
  File imageFile;
  File _sample;
  BuildContext ctx;

  // final cropKey = GlobalKey<CropState>();
  @override
  Widget build(BuildContext context) {
    ctx = context;
    return new InkWell(
        onTap: _onTap,
        child: Container(
            child: widget.value == null ? defaultImage() : ovalImage()));
  }

  Widget defaultImage() {
    return SizedBox(
        width: widget.width, height: widget.height, child: widget.placeholder);
  }

  Widget ovalImage() {
    print("收到${widget.value}");
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(widget.value),
          fit: BoxFit.cover,
        ),
        color: Colors.grey[300],
      ),
      // child: _img,
    );
    // return Align(
    // 默认头像图片放在左上方。
    // alignment: Alignment.topLeft,
    // child: NetworkImage(widget.value)
    // Image.network(widget.value,
    //     fit: BoxFit.cover, width: widget.width, height: widget.height)
    // child: Image.file(
    //   widget.value,
    //   fit: BoxFit.cover,
    //   width: widget.width,
    //   height: widget.height,
    // ),
    // );
  }

  void _onTap() {
    showModal();
  }

  Future showModal() {
    BeeUi.showBottomButtonsModal(context: ctx, buttons: [
      ListTile(
        title: Text("拍摄照片",
            style: TextStyle(color: Theme.of(context).textTheme.body1.color),
            textAlign: TextAlign.center),
        contentPadding: EdgeInsets.symmetric(vertical: 0.0),
        onTap: fromCamera,
      ),
      ListTile(
        title: Text("从手机相册选择",
            style: TextStyle(color: Theme.of(context).textTheme.body1.color),
            textAlign: TextAlign.center),
        onTap: fromGallery,
      )
    ]);
    // BeeUi.showBottomModal(
    //     context: ctx,
    //     title: null,
    //     builder: (BuildContext context) {
    //       return Column(
    //           children: ListTile.divideTiles(
    //         context: context,
    //         tiles: [
    //           ListTile(
    //             title: Text("拍摄照片", textAlign: TextAlign.center),
    //             contentPadding: EdgeInsets.symmetric(vertical: 0.0),
    //             onTap: fromCamera,
    //           ),
    //           ListTile(
    //             title: Text("从手机相册选择", textAlign: TextAlign.center),
    //             onTap: fromGallery,
    //           ),
    //         ],
    //       ).toList());
    //     });
  }

  //从相机
  fromCamera() async {
    Navigator.of(context).pop();
    try {
      var image = await ImagePicker.pickImage(source: ImageSource.camera);

      setImgPath(image);
    } catch (e) {
      print(e);
    }
  }

  //从相册
  fromGallery() async {
    Navigator.of(context).pop();
    try {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setImgPath(image);
    } catch (e) {
      print(e);
    }
  }

  setImgPath(File file) async {
    print("image====${file}");
    setState(() {
      // _sample = sample;
      imageFile = file;
    });
    _cropImage(file);
    // showCropModal();
  }

  Future<Null> _cropImage(File imageFile) async {
    assert(imageFile != null);
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      ratioX: 1.0,
      ratioY: 1.0,
      maxWidth: 512,
      maxHeight: 512,
    );
    if (widget.onCrop != null) {
      widget.onCrop(croppedFile);
    }
  }
}
