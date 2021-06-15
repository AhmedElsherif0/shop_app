import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File imagFile) getImage;

  UserImagePicker({this.getImage});

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _imageStored;

  void _getImage() async {
    final pickedFile = await ImagePicker().getImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 150,
        maxHeight: 150);

    if (pickedFile == null) {
      return;
    }
    setState(() {
      _imageStored = File(pickedFile.path);
    });
    widget.getImage(File(pickedFile.path));
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 100,
          width: 100,
          margin: const EdgeInsets.only(top: 8, right: 10),
          decoration:
              BoxDecoration(border: Border.all(width: 1.0, color: Colors.grey)),
          child: Semantics(
            child: _imageStored != null
                ? Image.file(
                    _imageStored,
                    fit: BoxFit.cover,
                  )
                : null,
            label: 'Image dos\'nt picked yet',
          ),
        ),
        TextButton.icon(
          style: ElevatedButton.styleFrom(
              textStyle: TextStyle(color: primaryColor)),
          onPressed: _getImage,
          icon: Icon(Icons.image),
          label: Text('Add Image'),
        )
      ],
    );
  }
}
