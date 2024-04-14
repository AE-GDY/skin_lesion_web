import 'package:flutter/material.dart';
import '../constants.dart';
import '../functions/screen-dimensions.dart';
import 'database.dart';


class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

int currentDoctorIndex = 0;

class _RegisterState extends State<Register> {

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool parentSelected = true;
  bool isSignUp = false;
  bool wrongEmailOrPassword = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.white,
        elevation: 0,
        // centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20,),
            Text("Doctor's Account", style: TextStyle(
              fontSize: 30,
            ),),
            SizedBox(height: 30,),
            Text(isSignUp?"Sign up to continue":"Sign in to continue", style: TextStyle(
              fontSize: 25,
            ),),
            SizedBox(height: 20,),
            isSignUp?SizedBox(height: 20,):Container(),

            isSignUp? Container(
              width: screenWidth(context) / 2 ,
              height: 50,
              margin: EdgeInsets.all(10),
              child: TextFormField(
                controller: nameController,
                decoration:  InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.blue, // Change border color here
                      width: 2.0, // Change border width here
                    ),
                  ),

                ),
              ),
            ):Container(),

            isSignUp?Container():SizedBox(height: 30,),

            Container(
              width: screenWidth(context) / 2,
              height: 50,
              margin: EdgeInsets.all(10),
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.blue, // Change border color here
                      width: 2.0, // Change border width here
                    ),
                  ),

                ),
              ),
            ),



            Container(
              width: screenWidth(context) / 2,
              height: 50,
              margin: EdgeInsets.all(10),
              child: TextFormField(
                controller: passwordController,
                ///keyboardType: TextInputType.number,
                decoration:  InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Colors.blue, // Change border color here
                      width: 2.0, // Change border width here
                    ),
                  ),

                ),
              ),
            ),

            SizedBox(height: 10,),

            Container(
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  FutureBuilder(
                    future: Future.wait([doctorsData()]),
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if(snapshot.connectionState == ConnectionState.done){
                        if(snapshot.hasError){
                          return  Text("");
                        }
                        else if(snapshot.hasData){
                          return Container(
                            width: screenWidth(context) / 3,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
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


                                  int doctorAmount = snapshot.data[0]['doctor-amount'];

                                  if(isSignUp){
                                    userName = nameController.text;
                                    await Database().addDoctor(
                                      doctorAmount,
                                      nameController.text,
                                      emailController.text,
                                      passwordController.text,
                                    );
                                    setState(() {
                                      isSignUp = false;
                                    });
                                  }
                                  else{
                                    int doctorIndex = 0;
                                    while(doctorIndex < doctorAmount){
                                      if(emailController.text == snapshot.data[0]['$doctorIndex']['email']){
                                        if(passwordController.text == snapshot.data[0]['$doctorIndex']['password']){
                                          userName = snapshot.data[0]['$doctorIndex']['name'];
                                          userEmail = snapshot.data[0]['$doctorIndex']['email'];
                                          currentDoctorIndex = doctorIndex;
                                          break;
                                        }
                                      }
                                      doctorIndex++;
                                    }

                                    if(doctorIndex == doctorAmount){
                                      setState(() {
                                        wrongEmailOrPassword = true;
                                      });
                                    }
                                    else{
                                      Navigator.pushNamed(context, '/');
                                    }
                                  }
                                },
                                child: Text(isSignUp?'Create Account':'Sign in',style: TextStyle(
                                  color: Colors.white,
                                ),)
                            ),
                          );
                        }
                      }
                      return const CircularProgressIndicator();
                    },

                  ),

                  SizedBox(height: wrongEmailOrPassword?10:10,),
                  wrongEmailOrPassword?const Text("Wrong email or password", style: TextStyle(color: Colors.red),):Container(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(isSignUp?"Already have an account? ":"Don't have an account? ", style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16
                      ),),
                      TextButton(
                        onPressed: (){
                          //changeToSignUp();
                          setState(() {
                            isSignUp = !isSignUp;
                            wrongEmailOrPassword = false;
                          });
                        },
                        child: Text(isSignUp?"Sign in":"Sign up",style: const TextStyle(
                          //  decoration: TextDecoration.underline,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
