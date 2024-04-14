import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';


Future<Uint8List> getData(int patientIndex, Uint8List imageBytes, String imageDownloadURL, Function setState) async {
  try{
    imageDownloadURL = await FirebaseStorage.instance.ref().child("gs://myskin-f6d54.appspot.com/Patients/patient_$patientIndex/picture_0.jpg").getDownloadURL();
    var response = await http.get(Uri.parse(imageDownloadURL));
    if (response.statusCode == 200) {
      setState(() {
        imageBytes = response.bodyBytes;
      });

    } else {
      throw Exception('Failed to load image');
    }
    debugPrint(imageDownloadURL.toString());
    return imageBytes;
  }
  catch (e) {
    debugPrint("Error - $e");
    return Uint8List(0);
  }
}

Future<Map<String, dynamic>> getDataMap(int imageIndex, Uint8List imageBytes, String imagePath, String imageDownloadURL, Function setState) async {
  try{
    imageDownloadURL = await FirebaseStorage.instance.ref().child("gs://athletefactory-c575a.appspot.com/$imagePath").getDownloadURL();
    var response = await http.get(Uri.parse(imageDownloadURL));
    if (response.statusCode == 200) {
      setState(() {
        imageBytes = response.bodyBytes;
      });

    } else {
      throw Exception('Failed to load image');
    }
    debugPrint(imageDownloadURL.toString());
    return {
      'imageBytes': imageBytes,
      'imageIndex': imageIndex,
    };
  }
  catch (e) {
    debugPrint("Error - $e");
    return {};
  }
}