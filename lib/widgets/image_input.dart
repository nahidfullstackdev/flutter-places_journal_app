import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickImage});

  final void Function(File image) onPickImage;

  @override
  State<StatefulWidget> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;
  void _takePicture() async {
    final imagePicker = ImagePicker();

    final pickedImage = await imagePicker.pickImage(source: ImageSource.camera);

    if (pickedImage == null) {
      return;
    }

    setState(
      () {
        _selectedImage = File(pickedImage.path);
      },
    );

    widget.onPickImage(_selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = TextButton.icon(
      onPressed: _takePicture,
      icon: const Icon(Icons.camera),
      label: const Text('Take Picture'),
    );

    if (_selectedImage != null) {
      previewContent = Image.file(
        _selectedImage!,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      );  
    }

    return Container(
      decoration:
          BoxDecoration(border: Border.all(width: 1, color: Colors.black54)),
      height: 250,
      width: double.infinity,
      child: Center(
        child: previewContent,
      ),
    );
  }
}
