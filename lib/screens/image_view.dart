import 'package:flutter/material.dart';
import 'package:skin_lesion_web/functions/screen-dimensions.dart';
import 'package:skin_lesion_web/widgets/image_container.dart';

import '../constants.dart';
import '../functions/image-functions.dart';
import '../services/database.dart';
import 'home.dart';


class ImageView extends StatefulWidget {
  const ImageView({Key? key}) : super(key: key);

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {


  @override
  void initState() {
    super.initState();
    /*
    getData(currentIndex, imageBytes, '', setState).then((result) {
      setState(() {
        imageBytes = result;
      });
    }).catchError((error) {
      debugPrint("Error - $error");
    });
    */
  }

  TextEditingController replyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text("MySkin",style: TextStyle(color: Colors.white),),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF10217D), Color(0xFF0063D9)],
            ),
          ),
        ),

      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: ScrollPhysics(),
        child: FutureBuilder(
          future: Future.wait([patientsData()]),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if(snapshot.connectionState == ConnectionState.done){
              if(snapshot.hasError){
                return const Text("");
              }
              else if(snapshot.hasData){
                return Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                       // margin: EdgeInsets.only(top: 50),
                        child: imageContainer(imageBytes, 400, 400),
                      ),
                      Container(
                        width: screenWidth(context) / 2,
                        height: screenHeight(context),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Text("Patient Name", style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),),
                            Text("$patientName",style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                            )),
                            Text("Symptoms",style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),),
                            Center(
                              child: Container(
                                height: 300,
                                child: ListView.builder(
                                    itemCount: symptomTitles.length,
                                    itemBuilder: (context, index){
                                      return ListTile(
                                        title: Text(symptomTitlesMapping[symptomTitles[index]]!, style: TextStyle(
                                          fontSize: 17,
                                        ),),
                                        subtitle: Text(patientSymptoms[symptomTitles[index]]!, style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey,
                                        ),),
                                      );
                                    }),
                              ),
                            ),
                            Text("Classification",style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),),
                            Text("$classification",style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                            )),
                            SizedBox(height: 30,),
                            Text("Reply",style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),),
                            SizedBox(height: 20,),
                            Container(
                              width: screenWidth(context) / 2.5,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                              ),
                              child: TextField(
                                minLines: 4,
                                maxLines: 10,
                                controller: replyController,
                                decoration: InputDecoration(
                                  hintText: "Reply",
                                ),
                              ),
                            ),
                            SizedBox(height: 20,),
                            FutureBuilder(
                              future: patientsData(),
                              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                if(snapshot.connectionState == ConnectionState.done){
                                  if(snapshot.hasError){
                                    return const Text("");
                                  }
                                  else if(snapshot.hasData){
                                    return Container(
                                      width: screenWidth(context) / 3,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: LinearGradient(
                                            colors: [
                                              Color(0xFF10217D), Color(0xFF0063D9)
                                            ]
                                        ),
                                      ),
                                      child: TextButton(
                                        onPressed: () async {
                                          if(replyController.text.isNotEmpty){
                                            List<dynamic> doctorResponses = snapshot.data['$currentIndex']['doctor-responses'];
                                            doctorResponses.add({
                                              'doctor-name': userName,
                                              'doctor-response':replyController.text,
                                            });
                                            try {
                                              await Database().updatePatientDoctorResponses(currentIndex, doctorResponses);
                                              // Clear the replyController's text
                                              replyController.clear();

                                              Navigator.popAndPushNamed(context, '/');

                                              // Show confirmation SnackBar
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text("Reply sent successfully."),
                                                  duration: Duration(seconds: 2),
                                                ),
                                              );
                                            }
                                            catch (error) {
                                              debugPrint("Error - $error");
                                              // Show error message if the database update fails
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text("Failed to send reply. Please try again."),
                                                  duration: Duration(seconds: 2),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                        child: Text("Send", style: TextStyle(
                                          color: Colors.white,
                                        ),),
                                      ),
                                    );
                                  }
                                }
                                return const CircularProgressIndicator();
                              },

                            ),
                          ],
                        ),
                      ),
                    ],
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
