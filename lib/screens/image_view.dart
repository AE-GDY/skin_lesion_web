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
    getData(currentIndex, imageBytes, '', setState).then((result) {
      setState(() {
        imageBytes = result;
      });
    }).catchError((error) {
      debugPrint("Error - $error");
    });
  }

  TextEditingController replyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("MySkin",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
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
                            Text("$patientSymptoms",style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                            )),
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
                                              Colors.indigo,
                                              Colors.blue,
                                              Colors.lightBlue,
                                              Colors.lightBlueAccent,
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
                                            await Database().updatePatientDoctorResponses(currentIndex, doctorResponses);
                                            Navigator.popAndPushNamed(context, '/');
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
