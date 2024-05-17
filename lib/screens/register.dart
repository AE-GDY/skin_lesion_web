import 'package:flutter/material.dart';
import '../constants.dart';
import '../functions/screen-dimensions.dart';
import '../services/database.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

int currentDoctorIndex = 0;

class _RegisterState extends State<Register> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isSignUp = false;
  bool wrongEmailOrPassword = false;
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "DermaScreen",
          style: TextStyle(fontFamily: "Montserrat", fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color(0xFF10217D),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(isSignUp ? "Sign up to continue" : "Sign in to continue", style: TextStyle(fontSize: 25, color: Color(0xFF10217D))),
                const SizedBox(height: 20),
                if (isSignUp) buildNameField(),
                buildEmailField(),
                buildPasswordField(),
                const SizedBox(height: 20),
                buildActionContainer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNameField() {
    return buildTextField(nameController, 'Full Name');
  }

  Widget buildEmailField() {
    return buildTextField(emailController, 'Email');
  }

  Widget buildPasswordField() {
    return Container(
      width: screenWidth(context) / 2,
      height: 50,
      margin: const EdgeInsets.all(10),
      child: TextFormField(
        controller: passwordController,
        obscureText: !isPasswordVisible,
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: TextStyle(color: Color(0xFF0063D9)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Color(0xFF0063D9), width: 2.0),
          ),
          suffixIcon: IconButton(
            icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Color(0xFF0063D9)),
            onPressed: () {
              setState(() {
                isPasswordVisible = !isPasswordVisible;
              });
            },
          ),
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label) {
    return Container(
      width: screenWidth(context) / 2,
      height: 50,
      margin: const EdgeInsets.all(10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Color(0xFF0063D9)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Color(0xFF0063D9), width: 2.0),
          ),
        ),
      ),
    );
  }

  Widget buildActionContainer() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          FutureBuilder(
            future: Future.wait([doctorsData()]),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return const Text("Error loading data");
                } else if (snapshot.hasData) {
                  return buildSubmitButton(snapshot);
                }
              }
              return const CircularProgressIndicator();
            },
          ),
          if (wrongEmailOrPassword)
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text("Wrong email or password", style: TextStyle(color: Colors.red)),
            ),
          buildSignUpSignInToggle(),
        ],
      ),
    );
  }

  Widget buildSubmitButton(AsyncSnapshot<dynamic> snapshot) {
    return Container(
      width: screenWidth(context) / 3,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(colors: [
          Color(0xFF10217D),
          Color(0xFF0063D9),
        ]),
      ),
      child: TextButton(
        onPressed: () async {
          int doctorAmount = snapshot.data[0]['doctor-amount'];
          if (isSignUp) {
            await Database().addDoctor(
              doctorAmount,
              nameController.text,
              emailController.text,
              passwordController.text,
            );
            setState(() {
              isSignUp = false;
              wrongEmailOrPassword = false; // Reset error state upon successful registration
            });
          } else {
            bool found = false;
            for (int i = 0; i < doctorAmount; i++) {
              var doctor = snapshot.data[0]['$i'];
              if (emailController.text == doctor['email'] && passwordController.text == doctor['password']) {
                setState(() {
                  currentDoctorIndex = i;
                  wrongEmailOrPassword = false;
                  Navigator.pushNamed(context, '/'); // Assuming this is the dashboard route
                });
                found = true;
                break;
              }
            }
            if (!found) {
              setState(() {
                wrongEmailOrPassword = true;
              });
            }
          }
        },
        child: Text(isSignUp ? 'Create Account' : 'Sign in', style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget buildSignUpSignInToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(isSignUp ? "Already have an account? " : "Don't have an account? ", style: const TextStyle(color: Color(0xFF0063D9), fontSize: 16)),
        TextButton(
          onPressed: () {
            setState(() {
              isSignUp = !isSignUp;
              wrongEmailOrPassword = false; // Reset error state when toggling between sign in and sign up
            });
          },
          child: Text(isSignUp ? "Sign in" : "Sign up", style: const TextStyle(color: Color(0xFF10217D), fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ],
    );
  }
}
