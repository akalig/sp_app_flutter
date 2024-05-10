import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:sp_app/pages/authentication/login/login_mpin.dart';

class LoginOTP extends StatefulWidget {
  final String mobileNumber;
  final String pinPassword;
  final String userID;
  final String otp;

  const LoginOTP({
    super.key,
    required this.mobileNumber,
    required this.pinPassword,
    required this.userID,
    required this.otp,
  });

  @override
  State<LoginOTP> createState() => _LoginOTPState();
}

class _LoginOTPState extends State<LoginOTP> {
  late String mobileNumber;
  late String pinPassword;
  late String userID;
  late String otp;

  @override
  void initState() {
    // Initialize the instance variables in initState
    mobileNumber = widget.mobileNumber;
    pinPassword = widget.pinPassword;
    userID = widget.userID;
    otp = widget.otp;

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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Enter OTP request.',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 50.0), //
                    OtpTextField(
                      numberOfFields: 6,
                      borderColor: const Color(0xFFFFFFFF),
                      textStyle: const TextStyle(color: Color(0xFFFFFFFF)),
                      //set to true to show as box or false to show as dash
                      showFieldAsBox: true,
                      //runs when a code is typed in
                      onCodeChanged: (String code) {
                        //handle validation or checks here
                      },
                      //runs when every textfield is filled
                      onSubmit: (String verificationCode) async {
                        if (otp != verificationCode) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('OTP is not Matched'),
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginMPIN(
                              pinPassword: pinPassword,
                              userID: userID,
                            ),
                          ),
                        );
                      }, // end onSubmit
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
