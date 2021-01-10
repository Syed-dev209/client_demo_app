import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/home_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Client Demo Social App',
      home: HomePage(),
    );
  }
}
