import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:sp_app/pages/home/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class RegisterMPIN extends StatefulWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController middleNameController;
  final TextEditingController suffixNameController;
  final TextEditingController mobileNumberController;
  final TextEditingController municipalityController;
  final TextEditingController barangayController;
  final TextEditingController streetController;
  final String buttonText;
  final String currentOption;
  final String selectedRegion;
  final String selectedProvince;

  const RegisterMPIN({
    Key? key,
    required this.firstNameController,
    required this.lastNameController,
    required this.middleNameController,
    required this.suffixNameController,
    required this.mobileNumberController,
    required this.municipalityController,
    required this.barangayController,
    required this.streetController,
    required this.buttonText,
    required this.currentOption,
    required this.selectedRegion,
    required this.selectedProvince,
  }) : super(key: key);

  @override
  State<RegisterMPIN> createState() => _RegisterMPINState();
}

class _RegisterMPINState extends State<RegisterMPIN> {
  // Declare the parameters as instance variables
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController middleNameController;
  late TextEditingController suffixNameController;
  late TextEditingController mobileNumberController;
  late TextEditingController municipalityController;
  late TextEditingController barangayController;
  late TextEditingController streetController;
  late String buttonText;
  late String currentOption;
  late String selectedRegion;
  late String selectedProvince;

  @override
  void initState() {
    // Initialize the instance variables in initState
    firstNameController = widget.firstNameController;
    lastNameController = widget.lastNameController;
    middleNameController = widget.middleNameController;
    suffixNameController = widget.suffixNameController;
    mobileNumberController = widget.mobileNumberController;
    municipalityController = widget.municipalityController;
    barangayController = widget.barangayController;
    streetController = widget.streetController;
    buttonText = widget.buttonText;
    currentOption = widget.currentOption;
    selectedRegion = widget.selectedRegion;
    selectedProvince = widget.selectedProvince;

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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Enter your Enter your MPIN',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
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
                      onSubmit: (String pinPassword) async {
                        // showDialog(
                        //     context: context,
                        //     builder: (context){
                        //       return AlertDialog(
                        //         title: const Text("Verification Code"),
                        //         content: Text('Code entered is $verificationCode'),
                        //       );
                        //     }
                        // );

                        try {
                          // Get a Firestore instance
                          String randomString = generateRandomString(20);
                          FirebaseFirestore firestore = FirebaseFirestore.instance;
                          Timestamp createdAtTimestamp = Timestamp.now();

                          // Save data to "users" collection
                          await firestore.collection('users').doc(randomString).set({
                            'first_name': firstNameController.text,
                            'last_name': lastNameController.text,
                            'middle_name': middleNameController.text,
                            'suffix_name': suffixNameController.text,
                            'mobile_number': mobileNumberController.text,
                            'municipality': municipalityController.text,
                            'barangay': barangayController.text,
                            'street': streetController.text,
                            'birthdate': buttonText,
                            'category': currentOption,
                            'region': selectedRegion,
                            'province': selectedProvince,
                            'pin_password': pinPassword,
                            'userID': randomString,
                            'has_greencard': 'false',
                            'created_at': createdAtTimestamp,
                          });

                          // Navigate to the home page
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HomePage()),
                          );
                        } catch (e) {
                          print('Error saving data: $e');
                          // Handle error
                        }
                      }, // end onSubmit
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

  String generateRandomString(int length) {
    const String characterSet =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    Random random = Random();

    StringBuffer buffer = StringBuffer();

    for (int i = 0; i < length; i++) {
      int randomIndex = random.nextInt(characterSet.length);
      buffer.write(characterSet[randomIndex]);
    }

    return buffer.toString();
  }

}
