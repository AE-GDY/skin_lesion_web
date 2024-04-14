import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

double screenWidth(BuildContext context){
  return MediaQuery.of(context).size.width;
}

double screenHeight(BuildContext context){
  return MediaQuery.of(context).size.height;
}

Future<void> uploadFile(int userIndex, dynamic pickedFile) async {
  final path = 'Patients/patient_$userIndex/picture_0.jpg';
  Reference storageReference = FirebaseStorage.instance.ref().child(path);

  UploadTask uploadTask = storageReference.putFile(pickedFile);

  await uploadTask.whenComplete(() async {
    print('Image uploaded to Firebase Storage');
    String downloadURL = await storageReference.getDownloadURL();
    print('Download URL: $downloadURL');
  });
}