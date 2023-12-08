import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'authentication/authentication.dart';
import 'home/home_page.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // User is logged in, get userID and navigate to HomePage
      String userId = prefs.getString('userID') ?? ""; // Provide a default value if userID is not found
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(userId: userId)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(true);
        SystemNavigator.pop();
        return false; // Returning false prevents the screen from being popped automatically
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Background image
            Image.asset(
              'lib/images/san_pedro_laguna.png',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            // White layer with opacity
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white.withOpacity(0.8),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 100),
                  child: Image.asset('lib/images/sp-logo.png'),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 200),
                  child: const Text(
                    'San Pedro Laguna Smart City Application',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: SizedBox(
                    width: 300,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Authentication(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green[800],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.all(18),
                        child: const Center(
                          child: Text(
                            'GET STARTED',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}