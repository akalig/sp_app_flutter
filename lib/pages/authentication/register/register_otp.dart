import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sp_app/pages/authentication/register/register.dart';
import 'package:sp_app/pages/authentication/register/register_mpin.dart';
import 'package:sp_app/pages/home/home_page.dart';

class RegisterOTP extends StatefulWidget {
  final TextEditingController mobileNumberController;
  final String residentSelection;

  const RegisterOTP({
    Key? key,
    required this.mobileNumberController,
    required this.residentSelection,
  }) : super(key: key);

  @override
  State<RegisterOTP> createState() => _RegisterOTPState();
}

class _RegisterOTPState extends State<RegisterOTP> {
  // Declare the parameters as instance variables
  late TextEditingController mobileNumberController;
  late String residentSelection;

  @override
  void initState() {
    // Initialize the instance variables in initState
    mobileNumberController = widget.mobileNumberController;
    residentSelection = widget.residentSelection;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Register(
                              mobileNumberController: mobileNumberController,
                              residentSelection: residentSelection,
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
