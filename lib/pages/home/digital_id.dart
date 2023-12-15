import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DigitalID extends StatefulWidget {
  final String userId;

  const DigitalID({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<DigitalID> createState() => _DigitalIDState();
}

class _DigitalIDState extends State<DigitalID> {
  late String userId;
  late Reference faceScanRef;

  @override
  void initState() {
    userId = widget.userId;
    faceScanRef = FirebaseStorage.instance
        .ref()
        .child('user_face_scan/$userId/capturedFaceScan.jpg');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'MY DIGITAL ID',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(25),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: FutureBuilder(
                            future: faceScanRef.getDownloadURL(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return const Text('Error loading image');
                              } else {
                                return ClipOval(
                                  child: Image.network(
                                    snapshot.data.toString(),
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              }
                            },
                          )),

                      const SizedBox(height: 20),

                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return const Text('Error loading user data');
                            } else {
                              Map<String, dynamic> userData = snapshot.data?.data() as Map<String, dynamic>;
                              String userInformation = buildUserInformation(userData);
                              return Column(
                                children: [
                                  Container(
                                    child: QrImageView(
                                      data: userInformation,
                                      version: QrVersions.auto,
                                      size: 200.0,
                                    ),
                                  ),
                                  // Other widgets or content as needed
                                ],
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String buildUserInformation(Map<String, dynamic> userData) {
    // Customize this method based on your data structure
    return '''
      First Name: ${userData['first_name']}
      Middle Name: ${userData['middle_name']}
      Last Name: ${userData['last_name']}
      Suffix Name: ${userData['suffix_name']}
      Birthdate: ${userData['birthdate']}
      Mobile Number: ${userData['mobile_number']}
      Residency: ${userData['residency']}      
      Region: ${userData['region']}
      Province: ${userData['province']}
      City/Municipality: ${userData['municipality']}
      Barangay: ${userData['barangay']}
      Building No./House No./Unit No./Street: ${userData['street']}
    ''';
  }

}
