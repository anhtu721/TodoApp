import 'package:flutter/material.dart';
import 'package:notes_application/page/sign_in/sign_in.dart';


void main() => runApp(
    const MaterialApp(
      home: MyApp (),
    )
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignInPage(),
    );
  }
}
