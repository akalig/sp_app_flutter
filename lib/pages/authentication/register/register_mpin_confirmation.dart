import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:sp_app/pages/authentication/authentication.dart';
import 'package:sp_app/pages/home/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import '../login/login.dart';

class ConfirmMPIN extends StatefulWidget {

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController middleNameController;
  final TextEditingController suffixNameController;
  final TextEditingController mobileNumberController;
  final TextEditingController municipalityController;
  final TextEditingController barangayController;
  final TextEditingController streetController;
  final String buttonText;
  final String selectedRegion;
  final String selectedProvince;
  final String residentSelection;
  final String desiredPin;

  const ConfirmMPIN({
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
    required this.selectedRegion,
    required this.selectedProvince,
    required this.residentSelection,
    required this.desiredPin,
  }) : super(key: key);

  @override
  State<ConfirmMPIN> createState() => _ConfirmMPINState();
}

class _ConfirmMPINState extends State<ConfirmMPIN> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController middleNameController;
  late TextEditingController suffixNameController;
  late TextEditingController mobileNumberController;
  late TextEditingController municipalityController;
  late TextEditingController barangayController;
  late TextEditingController streetController;
  late String buttonText;
  late String selectedRegion;
  late String selectedProvince;
  late String residentSelection;
  late String desiredPin;

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
    selectedRegion = widget.selectedRegion;
    selectedProvince = widget.selectedProvince;
    residentSelection = widget.residentSelection;
    desiredPin = widget.desiredPin;

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
                      'Confirm your MPIN Number',
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

                        if (desiredPin != pinPassword) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content:
                              Text('Desired MPIN is not matched'),
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        // Get a Firestore instance
                        String randomString = generateRandomString(20);
                        FirebaseFirestore firestore =
                            FirebaseFirestore.instance;
                        Timestamp createdAtTimestamp = Timestamp.now();

                        // Save data to "users" collection
                        await firestore
                            .collection('users')
                            .doc(randomString)
                            .set({
                          'first_name': firstNameController.text,
                          'last_name': lastNameController.text,
                          'middle_name': middleNameController.text,
                          'suffix_name': suffixNameController.text,
                          'mobile_number': mobileNumberController.text,
                          'municipality': municipalityController.text,
                          'barangay': barangayController.text,
                          'street': streetController.text,
                          'birthdate': buttonText,
                          'residency': residentSelection,
                          'region': selectedRegion,
                          'province': selectedProvince,
                          'pin_password': pinPassword,
                          'userID': randomString,
                          'has_greencard': 'false',
                          'created_at': createdAtTimestamp,
                        });

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Authentication()),
                        );

                      }, // end onSubmit
                    ),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'San Pedro App',
                          style: TextStyle(
                            color: Colors.white,
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
