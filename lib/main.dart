import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:user_dashboard/Auth_Services/homepage.dart';
import 'package:user_dashboard/Auth_Services/login_page.dart';
import 'package:user_dashboard/Auth_Services/signin_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Dashboard',
      theme: ThemeData(

        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(

      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key,
  }) : super(key: key);





  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {

    return const Scaffold(

      body: LoginPage(),
    );
  }
}
