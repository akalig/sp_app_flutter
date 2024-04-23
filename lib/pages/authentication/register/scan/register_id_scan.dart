import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sp_app/pages/authentication/register/register_mpin.dart';

class RegisterIDScan extends StatefulWidget {
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

  const RegisterIDScan({
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
    required this.capturedFaceScanLeft,
    required this.capturedFaceScanRight,
  });

  @override
  State<RegisterIDScan> createState() => _RegisterIDScanState();
}

class _RegisterIDScanState extends State<RegisterIDScan> {
  late CameraController controller;

  File? capturedIDScan;

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
  late File? capturedFaceScanLeft;
  late File? capturedFaceScanRight;

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
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterMPIN(
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
                            capturedFaceScanLeft: capturedFaceScanLeft,
                            capturedFaceScanRight: capturedFaceScanRight,
                            capturedIDScan: capturedIDScan,
                          ),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green[900],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Center(
                          child: Text(
                            'Continue',
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
}

enum EnumCameraDescription { front, back }
