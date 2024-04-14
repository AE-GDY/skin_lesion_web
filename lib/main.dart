import 'package:flutter/material.dart';
import 'package:skin_lesion_web/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:skin_lesion_web/screens/image_view.dart';
import 'package:skin_lesion_web/services/register.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyAr5RwCgN7VKD01LQidtuRIjbQeZ-FJkm4",
        authDomain: "myskin-f6d54.firebaseapp.com",
        projectId: "myskin-f6d54",
        storageBucket: "myskin-f6d54.appspot.com",
        messagingSenderId: "343364258811",
        appId: "1:343364258811:web:1ba3eaef35c441f1bb995e"
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/register',
      routes: {
        '/register':(context) => const Register(),
        '/':(context) => const Home(),
        '/image-view':(context) => const ImageView(),
      },
    );
  }
}

