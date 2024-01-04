import 'package:flutter/material.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:sp_app/pages/home/update_residency/update_id_scan.dart';

class UpdateFaceScanRight extends StatefulWidget {

  final String userId;
  final String selectedRegion;
  final String selectedProvince;
  final TextEditingController municipalityController;
  final TextEditingController barangayController;
  final TextEditingController streetController;
  final File? capturedFaceScan;
  final File? capturedFaceScanLeft;

  const UpdateFaceScanRight({
    super.key,
    required this.userId,
    required this.selectedRegion,
    required this.selectedProvince,
    required this.municipalityController,
    required this.barangayController,
    required this.streetController,
    required this.capturedFaceScan,
    required this.capturedFaceScanLeft,
  });

  @override
  State<UpdateFaceScanRight> createState() => _UpdateFaceScanRightState();
}

class _UpdateFaceScanRightState extends State<UpdateFaceScanRight> {
  late CameraController controller;

  File? capturedFaceScanRight;

  late String userId;
  late String selectedRegion;
  late String selectedProvince;
  late TextEditingController municipalityController;
  late TextEditingController barangayController;
  late TextEditingController streetController;
  late File? capturedFaceScan;
  late File? capturedFaceScanLeft;

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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                      'lib/images/camera-overlay-conceptcoder-right-face.png',
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
          capturedFaceScanRight = File(xfile.path);
        });

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Your Face'),
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
                          builder: (context) => UpdateIDScan(
                            userId: userId,
                            selectedRegion: selectedRegion,
                            selectedProvince: selectedProvince,
                            municipalityController: municipalityController,
                            barangayController: barangayController,
                            streetController: streetController,
                            capturedFaceScan: capturedFaceScan,
                            capturedFaceScanLeft: capturedFaceScanLeft,
                            capturedFaceScanRight: capturedFaceScanRight,
                          ),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green[800],
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