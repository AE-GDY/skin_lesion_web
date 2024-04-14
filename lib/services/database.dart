import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference database = FirebaseFirestore.instance.collection('Database');

Future<Map<String, dynamic>?> patientsData() async {
  return (await FirebaseFirestore.instance.collection('Database').doc('Patient Data').get()).data();
}

Future<Map<String, dynamic>?> doctorsData() async {
  return (await FirebaseFirestore.instance.collection('Database').doc('Doctors').get()).data();
}

Future<Map<String, dynamic>?> patientsAccountData() async {
  return (await FirebaseFirestore.instance.collection('Database').doc('Patients').get()).data();
}

class Database{

  Future addDoctor(int doctorIndex, String name, String email, String password) async {
    return await database.doc('Doctors').set({
      '$doctorIndex' : {
        'name': name,
        'email': email,
        'password': password,
      },
      'doctor-amount': doctorIndex+1,
    },
      SetOptions(merge: true),
    );
  }

  Future updatePatientDoctorResponses(int patientIndex, dynamic doctorResponses) async {
    return await database.doc('Patient Data').set({
      '$patientIndex' : {
        'doctor-responses': doctorResponses,
      },
    },
      SetOptions(merge: true),
    );
  }

}