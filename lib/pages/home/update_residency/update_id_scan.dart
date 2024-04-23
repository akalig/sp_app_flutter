import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sp_app/pages/home/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';

class UpdateIDScan extends StatefulWidget {

  final String userId;
  final String selectedRegion;
  final String selectedProvince;
  final TextEditingController municipalityController;
  final TextEditingController barangayController;
  final TextEditingController streetController;
  final File? capturedFaceScan;
  final File? capturedFaceScanLeft;
  final File? capturedFaceScanRight;

  const UpdateIDScan({
    super.key,
    required this.userId,
    required this.selectedRegion,
    required this.selectedProvince,
    required this.municipalityController,
    required this.barangayController,
    required this.streetController,
    required this.capturedFaceScan,
    required this.capturedFaceScanLeft,
    required this.capturedFaceScanRight,
  });

  @override
  State<UpdateIDScan> createState() => _UpdateIDScanState();
}

class _UpdateIDScanState extends State<UpdateIDScan> {
  late CameraController controller;

  File? capturedIDScan;

  late String userId;
  late String selectedRegion;
  late String selectedProvince;
  late TextEditingController municipalityController;
  late TextEditingController barangayController;
  late TextEditingController streetController;
  late File? capturedFaceScan;
  late File? capturedFaceScanLeft;
  late File? capturedFaceScanRight;

  String status = "pending";
  String residency = "Resident";

  @override
  void initState() {
    // Initialize the instance variables in initState
    userId = widget.userId;
    selectedRegion = widget.selectedRegion;
    selectedProvince = widget.selectedProvince;
    municipalityController = widget.municipalityController;
    barangayController = widget.barangayController;
    streetController = widget.streetController;
    capturedFaceScan = widget.capturedFaceScan;
    capturedFaceScanLeft = widget.capturedFaceScanLeft;
    capturedFaceScanRight = widget.capturedFaceScanRight;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: initializationCamera(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.only(top: 150.0),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  AspectRatio(
                    aspectRatio: 2 / 3,
                    child: CameraPreview(controller),
                  ),
                  AspectRatio(
                    aspectRatio: 2 / 3,
                    child: Image.asset(
                        'lib/images/camera-overlay-conceptcoder2.png',
                        fit: BoxFit.cover),
                  ),
                  InkWell(
                    onTap: () => onTakePicture(),
                    child: const CircleAvatar(
                      radius: 30.0,
                      backgroundColor: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
  Future<void> initializationCamera() async {
    var cameras = await availableCameras();
    controller = CameraController(
      cameras[EnumCameraDescription.front.index],
      ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );
    await controller.initialize();
  }

  void onTakePicture() async {
    await controller.takePicture().then((XFile xfile) {
      if (mounted) {

        setState(() {
          capturedIDScan = File(xfile.path);
        });

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Your ID'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AspectRatio(
                  aspectRatio: 2 / 3,
                  child: Image.file(
                    File(xfile.path),
                    fit:
                    BoxFit.fill, // Use "fill" to fill the available space
                  ),
                ),
                const SizedBox(height: 16.0),
                // Add some spacing between the image and buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle the "Retake" button press
                        Navigator.pop(context); // Close the dialog
                        // Add your logic for "Retake" here
                      },
                      child: const Text('Retake'),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (selectedRegion == "0") {
                          selectedRegion = 'Region IV - A';
                        }

                        if (selectedProvince == "0") {
                          selectedProvince = 'Laguna';
                        }

                        FirebaseFirestore firebaseInstance = FirebaseFirestore.instance;
                        CollectionReference usersCollection = firebaseInstance.collection('users');

                        try {
                          await usersCollection.doc(userId).update({
                            'region': selectedRegion,
                            'province': selectedProvince,
                            'municipality': municipalityController.text,
                            'barangay': barangayController.text,
                            'street': streetController.text,
                            'status': status,
                            'residency': residency,
                          });
                          print('Data updated successfully!');

                          await sendDataToServer(
                            userId,
                            selectedRegion,
                            selectedProvince,
                            municipalityController.text,
                            barangayController.text,
                            streetController.text,
                            status,
                            residency
                          );

                          if (capturedIDScan != null && capturedFaceScan != null) {
                            await sendImagesToFirebaseStorage(userId);
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(userId: userId),
                            ),
                          );

                        } catch (error) {
                          print('Error updating data: $error');
                        }
                      
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green[800],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Center(
                          child: Text(
                            'Submit',
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
                  ],
                ),
              ],
            ),
          ),
        );
      }
      return;
    });
  }

  Future<void> sendDataToServer(
      String userID,
      String region,
      String province,
      String municipality,
      String barangay,
      String street,
      String status,
      String residency) async {
    const url = 'https://bmwaresd.com/spapp_conn_update_residency.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'userID': userID,
          'region': region,
          'province': province,
          'municipality': municipality,
          'barangay': barangay,
          'street': street,
          'status': status,
          'residency': residency,
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

}

enum EnumCameraDescription { front, back }
