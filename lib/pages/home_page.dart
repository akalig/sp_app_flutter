import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String uid = "0";

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Welcome User'),
      ),
    );
  }
}