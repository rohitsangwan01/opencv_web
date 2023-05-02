// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';
import 'package:js/js.dart';
import 'package:js/js_util.dart';
import 'package:opencv_web/src/models/cv_contours.dart';

class OpenCvWeb {

  // get Contours from an Image
  static Future<List<CvContours>> getCvContours(
      {required Uint8List? image}) async {
    try {
      var data = await getContours(image);
      var result = await promiseToFuture(data);
      if (result == null) return <CvContours>[];
      var decodedResult = json.decode(result);
      var contoursList = decodedResult["contours"];
      return List<CvContours>.from(contoursList.map((e) {
        var jsonData = json.decode(e);
        return CvContours(
          x: jsonData['x'],
          y: jsonData['y'],
          w: jsonData['w'],
          h: jsonData['h'],
        );
      }).toList());
    } on Exception catch (e) {
      print(e.toString());
      return <CvContours>[];
    }
  }
}

@JS('initOpenCv')
external dynamic initOpenCv(onLoaded);

@JS('getContours')
external dynamic getContours(image);
