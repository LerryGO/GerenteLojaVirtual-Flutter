import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  final Function(File)? onImageSelected;

  const ImageSourceSheet({this.onImageSelected, Key? key}) : super(key: key);

  void imageSelected(File image) async {
    File? croppedImage = await ImageCropper.cropImage(
        sourcePath: image.path, maxWidth: 512, maxHeight: 512);
    onImageSelected!(croppedImage as File);
  }

  @override
  Widget build(BuildContext context) {
    final ImagePicker _picker = ImagePicker();
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                  elevation: MaterialStateProperty.all(0)),
              onPressed: () async {
                final image =
                    await _picker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  File photo = File(image.path);
                  imageSelected(photo);
                  Navigator.of(context).pop();
                }
              },
              child: const Text(
                "Câmera",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.transparent),
                  elevation: MaterialStateProperty.all(0)),
              onPressed: () async {
                final image =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  File photo = File(image.path);
                  imageSelected(photo);
                  Navigator.of(context).pop();
                }
              },
              child:
                  const Text("Galeria", style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }
}
