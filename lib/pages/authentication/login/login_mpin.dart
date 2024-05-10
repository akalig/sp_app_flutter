import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../home/home_page.dart';

class LoginMPIN extends StatefulWidget {
  final String pinPassword;
  final String userID;

  const LoginMPIN({
    super.key,
    required this.pinPassword,
    required this.userID,
  });

  @override
  State<LoginMPIN> createState() => _LoginMPINState();
}

class _LoginMPINState extends State<LoginMPIN> {
  late String pinPassword;
  late String userID;

  @override
  void initState() {
    // Initialize the instance variables in initState
    pinPassword = widget.pinPassword;
    userID = widget.userID;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            Image.asset(
              'lib/images/sp-logo.png',
              height: 300,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.green[900],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Enter your MPIN',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    OtpTextField(
                      numberOfFields: 6,
                      borderColor: const Color(0xFFFFFFFF),
                      textStyle: const TextStyle(color: Color(0xFFFFFFFF)),
                      showFieldAsBox: true,
                      onCodeChanged: (String code) {
                        // Handle validation or checks here
                      },
                      onSubmit: (String verificationCode) async  {
                        // Check if the entered MPIN matches the pinPassword
                        if (verificationCode != pinPassword) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Invalid MPIN'),
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        // MPIN is valid, navigate to the home page
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setString('userID', userID);
                        prefs.setBool('isLoggedIn', true);

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage(userId: userID)),
                        );

                      },
                    ),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Forgot Password? ',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Click here',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
