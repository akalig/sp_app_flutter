import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sp_app/pages/authentication/register/scan/register_face_scan_left.dart';

class RegisterFaceScan extends StatefulWidget {
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

  const RegisterFaceScan({
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
  });

  @override
  State<RegisterFaceScan> createState() => _RegisterFaceScanState();
}

class _RegisterFaceScanState extends State<RegisterFaceScan> {
  late CameraController controller;

  File? capturedFaceScan;

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
                      'lib/images/camera-overlay-conceptcoder-front-face.png',
                      fit: BoxFit.cover,
                    ),
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
      cameras[EnumCameraDescription.back.index],
      ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );
    await controller.initialize();
  }

  void onTakePicture() async {
    await controller.takePicture().then((XFile xfile) {
      if (mounted) {

        setState(() {
          capturedFaceScan = File(xfile.path);
        });

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Your Front Face Scan'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 180.0,
                  height: 180.0,
                  child: CircleAvatar(
                    backgroundImage: Image.file(
                      File(xfile.path),
                    ).image,
                  ),
                ),
                const SizedBox(height: 16.0),
                // Add some spacing between the image and buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Retake'),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterFaceScanLeft(
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
