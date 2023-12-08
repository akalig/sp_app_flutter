import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:sp_app/pages/authentication/register/register_mpin_confirmation.dart';
import 'dart:io';


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
  final String selectedRegion;
  final String selectedProvince;
  final String residentSelection;
  final File? capturedFaceScan;
  final File? capturedIDScan;

  const RegisterMPIN({
    super.key,
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
    required this.capturedFaceScan,
    required this.capturedIDScan,
  });

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
  late String selectedRegion;
  late String selectedProvince;
  late String residentSelection;
  late File? capturedFaceScan;
  late File? capturedIDScan;

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
    capturedFaceScan = widget.capturedFaceScan;
    capturedIDScan = widget.capturedIDScan;

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
                      'Enter your Desired MPIN Number',
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
                        // Get a Firestore instance
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConfirmMPIN(
                              firstNameController: firstNameController,
                              lastNameController: lastNameController,
                              middleNameController: middleNameController,
                              suffixNameController: suffixNameController,
                              mobileNumberController: mobileNumberController,
                              municipalityController: municipalityController,
                              barangayController: barangayController,
                              streetController: streetController,
                              buttonText: buttonText,
                              selectedRegion: selectedRegion,
                              selectedProvince: selectedProvince,
                              residentSelection: residentSelection,
                              capturedFaceScan: capturedFaceScan,
                              capturedIDScan: capturedIDScan,
                              desiredPin: pinPassword,
                            ),
                          ),
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
}
