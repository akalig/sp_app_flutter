import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sp_app/pages/authentication/register/resident_selection.dart';
import 'login/login.dart';

class Authentication extends StatelessWidget {
  const Authentication({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
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
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25.0),
                      child: SizedBox(
                        width: 300,
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Login()),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.all(18),
                            child: const Center(
                              child: Text(
                                'LOGIN',
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

                    Padding(
                      padding: const EdgeInsets.only(bottom: 25.0),
                      child: SizedBox(
                        width: 300,
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ResidentSelection()),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green[900],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.all(18),
                            child: const Center(
                              child: Text(
                                'REGISTER',
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
          ],
        ),
      ),
    );
  }
}
