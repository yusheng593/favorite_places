import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickImage});

  final void Function(File image) onPickImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _seleceteImage;

  void _takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _seleceteImage = File(pickedImage.path);
    });

    widget.onPickImage(_seleceteImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = _seleceteImage == null
        ? TextButton.icon(
            onPressed: _takePicture,
            label: const Text('Take Picture'),
            icon: const Icon(Icons.camera),
          )
        : GestureDetector(
            onTap: _takePicture,
            child: Image.file(
              _seleceteImage!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          );

    return Container(
      decoration: BoxDecoration(
          color: Colors.blueGrey,
          border: Border.all(width: 2, color: Colors.amber)),
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      child: content,
    );
  }
}
