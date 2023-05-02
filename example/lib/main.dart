// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:opencv_web/opencv_web.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<CvContours> contoursList = [];
  Uint8List? imageBytes;

  ///Pick image and pass to Opencv
  Future<void> getImageFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    Uint8List? uint8list = result?.files.single.bytes;
    String? name = result?.files.single.name;
    if (uint8list != null && name != null) {
      var contours = await OpenCvWeb.getCvContours(image: uint8list);
      setState(() {
        contoursList = contours;
        imageBytes = uint8list;
      });
    }
  }

  final controller = CropController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('OpenCv Web'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            const Divider(),
            ElevatedButton(
              onPressed: () => getImageFile(),
              child: const Text('Pick image'),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: imageBytes == null
                        ? const SizedBox()
                        : CropImage(
                            controller: controller,
                            image: Image.memory(imageBytes!),
                          ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: contoursList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            var rect = contoursList[index];
                            // var rectData = Rect.fromLTWH(
                            //   rect.x.toDouble(),
                            //   rect.y.toDouble(),
                            //   rect.w.toDouble(),
                            //   rect.h.toDouble(),
                            // );
                            var rectData = Rect.fromLTWH(0.35, 0.05, 1, 1);
                            controller.crop = rectData;
                            setState(() {});
                          },
                          child: Column(
                            children: [
                              Text(contoursList[index].toString()),
                              const Divider()
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
