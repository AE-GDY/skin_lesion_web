import 'dart:typed_data';

import 'package:flutter/material.dart';

Container imageContainer(Uint8List imageBytes, double width, double height){
  return Container(
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20.0), // Adjust the radius as needed
      child: Image.memory(
        imageBytes,
        height: height,
        width: width,
        fit: BoxFit.cover,
      ),
    ),
  );
}