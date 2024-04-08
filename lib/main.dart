import 'package:flutter/material.dart';
import 'package:sp_app/pages/home/home_page.dart';
import 'package:sp_app/pages/home/home_screens/home.dart';
import 'package:sp_app/pages/intro_page.dart';
import 'package:sp_app/pages/authentication/authentication.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: _checkFirstTime(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            bool isFirstTime = snapshot.data ?? true;
            if (isFirstTime) {
              return const MaterialApp(
                debugShowCheckedModeBanner: false,
                home: IntroPage(),
              );
            } else {
              return FutureBuilder<bool>(
                future: _checkLoggedIn(),
                builder: (context, snapshot) {
                  bool isLoggedIn = snapshot.data ?? false;
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (isLoggedIn) {
                      return FutureBuilder<String?>(
                        future: _getUserID(),
                        builder: (context, snapshot) {
                          String? userID = snapshot.data;
                          if (snapshot.connectionState == ConnectionState.done) {
                            return MaterialApp(
                              debugShowCheckedModeBanner: false,
                              home: userID != null ? HomePage(userId: userID) : const Authentication(),
                            );
                          }
                          return const CircularProgressIndicator();
                        },
                      );
                    } else {
                      return const Authentication();
                    }
                  }
                  return const CircularProgressIndicator();
                },
              );
            }
          }
          // Handle loading state here if needed
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  Future<bool> _checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
    if (isFirstTime) {
      await prefs.setBool('isFirstTime', false);
    }
    return isFirstTime;
  }

  Future<bool> _checkLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false; // Change to false
    return isLoggedIn;
  }

  Future<String?> _getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userID = prefs.getString('userID');
    return userID;
  }
}
