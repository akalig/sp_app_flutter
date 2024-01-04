import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:sp_app/pages/authentication/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

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
  final File? capturedFaceScan;
  final File? capturedFaceScanLeft;
  final File? capturedFaceScanRight;
  final File? capturedIDScan;
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
    required this.capturedFaceScan,
    required this.capturedFaceScanLeft,
    required this.capturedFaceScanRight,
    required this.capturedIDScan,
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
  late File? capturedFaceScan;
  late File? capturedFaceScanLeft;
  late File? capturedFaceScanRight;
  late File? capturedIDScan;
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
    capturedFaceScan = widget.capturedFaceScan;
    capturedFaceScanLeft = widget.capturedFaceScanLeft;
    capturedFaceScanRight = widget.capturedFaceScanRight;
    capturedIDScan = widget.capturedIDScan;
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
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    OtpTextField(
                      numberOfFields: 6,
                      borderColor: const Color(0xFFFFFFFF),
                      textStyle: const TextStyle(color: Color(0xFFFFFFFF)),
                      showFieldAsBox: true,
                      onCodeChanged: (String code) {
                        // Handle validation or checks here
                      },
                      onSubmit: (String pinPassword) async {
                        if (desiredPin != pinPassword) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Desired MPIN is not matched'),
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        String hasGreenCard = "false";
                        String status = "pending";

                        if (selectedRegion == "0") {
                          selectedRegion = 'Region IV - A';
                        }

                        if (selectedProvince == "0") {
                          selectedProvince = 'Laguna';
                        }

                        String randomString = generateRandomString(20);
                        FirebaseFirestore firestore =
                            FirebaseFirestore.instance;
                        Timestamp createdAtTimestamp = Timestamp.now();

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
                          'residency': residentSelection,
                          'region': selectedRegion,
                          'province': selectedProvince,
                          'pin_password': pinPassword,
                          'userID': randomString,
                          'has_greencard': hasGreenCard,
                          'status': status,
                          'created_at': createdAtTimestamp,
                        });

                        await sendDataToServer(
                          firstNameController.text,
                          lastNameController.text,
                          middleNameController.text,
                          suffixNameController.text,
                          mobileNumberController.text,
                          buttonText,
                          residentSelection,
                          selectedRegion,
                          selectedProvince,
                          municipalityController.text,
                          barangayController.text,
                          streetController.text,
                          pinPassword,
                          hasGreenCard,
                          randomString,
                          status,
                          createdAtTimestamp.toDate().toString(),
                        );

                        if (residentSelection == 'Resident' && capturedIDScan != null && capturedFaceScan != null) {
                          await sendImagesToFirebaseStorage(randomString);
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Authentication()),
                        );
                      },
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

  Future<void> sendDataToServer(
      String firstname,
      String lastname,
      String middleName,
      String suffixName,
      String mobileNumber,
      String birthdate,
      String residency,
      String region,
      String province,
      String municipality,
      String barangay,
      String street,
      String pinPassword,
      String hasGreenCard,
      String userID,
      String status,
      String createdAt) async {
    const url = 'https://bmwaresd.com/spapp_conn_send_user.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'first_name': firstname,
          'last_name': lastname,
          'middle_name': middleName,
          'suffix_name': suffixName,
          'mobile_number': mobileNumber,
          'birthdate': birthdate,
          'residency': residency,
          'region': region,
          'province': province,
          'municipality': municipality,
          'barangay': barangay,
          'street': street,
          'pin_password': pinPassword,
          'has_greencard': hasGreenCard,
          'userID': userID,
          'status': status,
          'created_at': createdAt,
        },
      );

      if (response.statusCode == 200) {
        print('Data sent to server successfully');
      } else {
        print('Failed to send data to server. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending data to server: $e');
    }
  }

  Future<void> sendImagesToFirebaseStorage(String userID) async {
    final storage = FirebaseStorage.instance;
    String idScanURL = '';
    String faceScanURL = '';
    String faceScanLeftURL = '';
    String faceScanRightURL = '';

    // Upload capturedIDScan to user_id_scan/userID/
    if (capturedIDScan != null) {
      final Reference idScanRef = storage.ref().child('user_id_scan/$userID/capturedIDScan.jpg');
      await idScanRef.putFile(capturedIDScan!);

      // Retrieve download URL
      idScanURL = await idScanRef.getDownloadURL();
      print('ID Scan Download URL: $idScanURL');
    }

    // Upload capturedFaceScan to user_face_scan/userID/
    if (capturedFaceScan != null) {
      final Reference faceScanRef = storage.ref().child('user_face_scan/$userID/capturedFaceScan.jpg');
      await faceScanRef.putFile(capturedFaceScan!);

      // Retrieve download URL
      faceScanURL = await faceScanRef.getDownloadURL();
      print('Face Scan Download URL: $faceScanURL');
    }

    // Upload capturedFaceScanLeft to user_face_scan_left/userID/
    if (capturedFaceScanLeft != null) {
      final Reference faceScanLeftRef = storage.ref().child('user_face_scan_left/$userID/capturedFaceScanLeft.jpg');
      await faceScanLeftRef.putFile(capturedFaceScanLeft!);

      // Retrieve download URL
      faceScanLeftURL = await faceScanLeftRef.getDownloadURL();
      print('Face Scan Left Download URL: $faceScanLeftURL');
    }

    // Upload capturedFaceScanRight to user_face_scan_right/userID/
    if (capturedFaceScanRight != null) {
      final Reference faceScanRightRef = storage.ref().child('user_face_scan_right/$userID/capturedFaceScanRight.jpg');
      await faceScanRightRef.putFile(capturedFaceScanRight!);

      // Retrieve download URL
      faceScanRightURL = await faceScanRightRef.getDownloadURL();
      print('Face Scan Left Download URL: $faceScanRightURL');
    }

    await saveImageLinksToServer(userID, idScanURL, faceScanURL, faceScanLeftURL, faceScanRightURL);
  }

  Future<void> saveImageLinksToServer(String userID, String idScanURL, String faceScanURL, String faceScanLeftURL, String faceScanRightURL) async {
    const url = 'https://bmwaresd.com/spapp_conn_send_images_links.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'userID': userID,
          'idScanURL': idScanURL,
          'faceScanURL': faceScanURL,
          'faceScanLeftURL': faceScanLeftURL,
          'faceScanRightURL': faceScanRightURL,
        },
      );

      if (response.statusCode == 200) {
        print('Data sent to server successfully');
      } else {
        print('Failed to send data to server. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending data to server: $e');
    }

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
