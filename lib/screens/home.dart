import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:skin_lesion_web/functions/screen-dimensions.dart';
import 'package:skin_lesion_web/services/database.dart';

import '../functions/image-functions.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

Uint8List imageBytes = Uint8List(0);
int currentIndex = 0;
String patientName = "";
String patientSymptoms = "";
String classification = "";

class _HomeState extends State<Home> {

  void scheduleAppointment(BuildContext context, dynamic data, int index) {
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
            // day/month/year variable
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
        title: Text("MySkin", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: ScrollPhysics(),
        child: FutureBuilder(
          future: Future.wait([patientsData()]),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Text("");
              }
              else if (snapshot.hasData) {
                return Center(
                  child: Container(
                    width: screenWidth(context),
                    height: screenHeight(context),
                    margin: EdgeInsets.all(20),
                    child: ListView.builder(
                        itemCount: snapshot.data[0]['patient-amount'],
                        itemBuilder: (context, index) {
                          return Container(
                            width: screenWidth(context),
                            margin: EdgeInsets.all(10),
                            child: ListTile(
                              leading: VerticalDivider(
                                color: Colors.blue, width: 2,),
                              title: Text("${snapshot
                                  .data[0]['$index']['patient-name']} "
                                  "| Classification: ${snapshot
                                  .data[0]['$index']['classification']} "
                                  "| Symptoms: ${snapshot
                                  .data[0]['$index']['symptoms']}"),
                              subtitle: Text("${snapshot
                                  .data[0]['$index']['patient-email']}"),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min, // Ensures the row only takes up needed space
                                children: <Widget>[
                                  Container(
                                    width: 150,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        currentIndex = index;
                                        getData(index, imageBytes, '', setState).then((result) {
                                          setState(() {
                                            imageBytes = result;
                                          });
                                        }).catchError((error) {
                                          debugPrint("Error - $error");
                                        });
                                        patientName = snapshot.data[0]['$index']['patient-name'];
                                        patientSymptoms = snapshot.data[0]['$index']['symptoms'];
                                        classification = snapshot.data[0]['$index']['classification'];
                                        Navigator.pushNamed(context, '/image-view');
                                      },
                                      child: Text("View Image", style: TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                  SizedBox(width: 10), // Spacing between buttons
                                  IconButton(
                                    icon: Icon(Icons.calendar_today, color: Colors.blue),
                                    onPressed: () => scheduleAppointment(context, snapshot.data, index),
                                  ),
                                ],
                              ),

                            ),
                          );
                        }),
                  ),
                );
              }
            }
            return const CircularProgressIndicator();
          },

        ),
      ),
    );
  }


}