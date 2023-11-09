import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class IDScanFront extends StatefulWidget {
  const IDScanFront({super.key});

  @override
  State<IDScanFront> createState() => _IDScanFrontState();
}

class _IDScanFrontState extends State<IDScanFront> {
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
                        'lib/images/camera-overlay-conceptcoder2.png',
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
      cameras[EnumCameraDescription.front.index],
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
              title: const Text('Your ID'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AspectRatio(
                    aspectRatio: 2 / 3,
                    child: Image.file(
                      File(xfile.path),
                      fit: BoxFit.fill, // Use "fill" to fill the available space
                    ),
                  ),
                  SizedBox(height: 16.0), // Add some spacing between the image and buttons
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
                      ElevatedButton(
                        onPressed: () {
                          // Handle the "Continue" button press
                          Navigator.pop(context); // Close the dialog
                          // Add your logic for "Continue" here
                        },
                        child: const Text('Continue'),
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
