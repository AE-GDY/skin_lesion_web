import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:skin_lesion_web/functions/screen-dimensions.dart';
import 'package:skin_lesion_web/services/database.dart';
import '../constants.dart';
import '../functions/image-functions.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

Uint8List imageBytes = Uint8List(0);
int currentIndex = 0;
String patientName = "";
dynamic patientSymptoms = [];
List<dynamic> classifications = [];
List<dynamic> probabilities = [];
class _HomeState extends State<Home> {

  void scheduleAppointment(BuildContext context, dynamic data, int index, AsyncSnapshot<dynamic> snapshot) async {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    ).then((selectedDate) {
      if (selectedDate != null) {
        showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        ).then((selectedTime) {
          if (selectedTime != null) {
            final DateTime appointmentDateTime = DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
              selectedTime.hour,
              selectedTime.minute,
            );
            List<dynamic> appointments = snapshot.data[0]['$index']['doctor-appointments'];
            appointments.add({
              'doctor-name': userName,
              'booking-confirmed': false,
              'booking-day': appointmentDateTime.day,
              'booking-month': appointmentDateTime.month,
              'booking-year': appointmentDateTime.year,
              'booking-hour': appointmentDateTime.hour,
              'booking-minute': appointmentDateTime.minute,
            });
            Database().addAppointment(index, appointments);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("DermaScreen", style: TextStyle(color: Colors.white70, fontSize: 24, fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 4.0, color: Colors.black26, offset: Offset(2, 2))],)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF10217D), Color(0xFF0063D9)],
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white,),
            onPressed: () {
              // Implement logout functionality here (backend)
              // go back to register
              Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => false);
            },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.grey[200]!, Colors.grey[300]!], // Soft grey gradient
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: ScrollPhysics(),
          child: FutureBuilder(
            future: Future.wait([patientsData()]),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return const Text("Error fetching data.");
                } else if (snapshot.hasData) {
                  return Center(
                    child: Container(
                      width: screenWidth(context),
                      height: screenHeight(context),
                      margin: EdgeInsets.all(20),
                      child: ListView.builder(
                          itemCount: snapshot.data[0]['patient-amount'],
                          itemBuilder: (context, index) {
                            if(snapshot.data[0]['$index']['classification'] == ""){
                              return Container();
                            }
                            else{
                              return Card(
                                elevation: 4,
                                surfaceTintColor: Colors.white,
                                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                child: ListTile(
                                  leading: Icon(Icons.person, color: Color(0xFF10217D)),
                                  title: Text("${snapshot.data[0]['$index']['patient-name']}"),
                                  subtitle: Text("${snapshot.data[0]['$index']['patient-email']}"),
                                  trailing: Wrap(
                                    spacing: 12,
                                    children: <Widget>[
                                      ElevatedButton(
                                        onPressed: () async {

                                          showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) => Center(
                                                child: CircularProgressIndicator(
                                                  color: mainColor,
                                                ),
                                              )
                                          );

                                          currentIndex = index;
                                          refresh = false;
                                          await getData(index, imageBytes, '', setState).then((result) {
                                            setState(() {
                                              imageBytes = result;
                                            });
                                          }).catchError((error) {
                                            debugPrint("Error - $error");
                                          });

                                          patientName = snapshot.data[0]['$index']['patient-name'];
                                          patientSymptoms = snapshot.data[0]['$index']['symptoms'];
                                          classifications = snapshot.data[0]['$index']['classification'];
                                          probabilities = snapshot.data[0]['$index']['probabilities'];

                                          /*
                                          await getData(currentIndex, imageBytes, '', setState).then((result) {
                                            setState(() {
                                              imageBytes = result;
                                            });
                                          }).catchError((error) {
                                            debugPrint("Error - $error");
                                          });
                                          */
                                          Navigator.of(context, rootNavigator: true).pop();
                                          Navigator.pushNamed(context, '/image-view');
                                        },
                                        child: Text("View Image"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF10217D), // Button background
                                          foregroundColor: Colors.white, // Text color
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.calendar_today, color: Color(0xFF10217D)),
                                        onPressed:  ()async  =>  scheduleAppointment(context, snapshot.data, index, snapshot),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                          }),
                    ),
                  );
                }
              }
              return CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10217D)),
              );
            },
          ),
        ),
      ),
    );
  }
}
