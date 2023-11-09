import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sp_app/pages/authentication/id_scan_front.dart';

class FaceScan extends StatefulWidget {
  const FaceScan({super.key});

  @override
  State<FaceScan> createState() => _FaceScanState();
}

class _FaceScanState extends State<FaceScan> {
  late CameraController controller;

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
                      'lib/images/camera-overlay-conceptcoder.png',
                      fit: BoxFit.cover
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
    await controller.takePicture().then((XFile xfile){
      if (mounted) {
        if (xfile != null) {
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
                  const SizedBox(height: 16.0), // Add some spacing between the image and buttons
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
                          MaterialPageRoute(builder: (context) => const IDScanFront()),
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
      }
      return;
    });
  }
}

enum EnumCameraDescription { front, back }
