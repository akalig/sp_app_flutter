import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DigitalID extends StatefulWidget {
  final String userId;

  const DigitalID({
    required this.userId,
    Key? key,
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
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green[900]?.withOpacity(0.9) ?? Colors.green[900],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Image.asset(
                              'lib/images/city_of_sanpedro_logo.png',
                              height: 70,
                              width: 70,
                            ),

                            const Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text(
                                'Republic of the Philippine\nProvince of Laguna\nCity of San Pedro',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                          ],
                        ),

                        Image.asset(
                          'lib/images/sp_logo_mini.png',
                          height: 100,
                          width: 100,
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: FutureBuilder(
                          future: faceScanRef.getDownloadURL(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return const Text('Error loading image');
                            } else {
                              return Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black38, // Choose your border color here
                                    width: 1, // Choose the border width here
                                  ),
                                  borderRadius: BorderRadius.circular(10), // Choose border radius
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8), // Adjust the same radius here
                                  child: Image.network(
                                    snapshot.data.toString(),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Accessing userData within the FutureBuilder
                                  FutureBuilder<DocumentSnapshot>(
                                    future: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(userId)
                                        .get(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return const Text('Error loading user data',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ));
                                      } else {
                                        // Extract userData from snapshot
                                        Map<String, dynamic> userData =
                                        snapshot.data?.data()
                                        as Map<String, dynamic>;
                                        // Display Name
                                        return RichText(
                                          text: TextSpan(
                                            // Note: Styles for TextSpans must be explicitly defined.
                                            // Child text spans will inherit styles from parent
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black,
                                            ),
                                            children: <TextSpan>[
                                              const TextSpan(
                                                  text: 'Last Name, First Name, M.I.\n',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w200,
                                                      color: Colors.black54,
                                                      fontSize: 10)),
                                              TextSpan(
                                                  text:
                                                  '${userData['last_name']} ${userData['suffix_name']}, ${userData['first_name']} ${userData['middle_name']}',
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                  )),
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 20),
                                  // Accessing userData within the FutureBuilder
                                  FutureBuilder<DocumentSnapshot>(
                                    future: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(userId)
                                        .get(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return const Text(
                                            'Error loading user data');
                                      } else {
                                        // Extract userData from snapshot
                                        Map<String, dynamic> userData =
                                        snapshot.data?.data()
                                        as Map<String, dynamic>;
                                        // Display Address
                                        return RichText(
                                          text: TextSpan(
                                            // Note: Styles for TextSpans must be explicitly defined.
                                            // Child text spans will inherit styles from parent
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black,
                                            ),
                                            children: <TextSpan>[
                                              const TextSpan(
                                                  text: 'Address\n',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w200,
                                                      color: Colors.black54,
                                                      fontSize: 10)),
                                              TextSpan(
                                                  text:
                                                  '${userData['street']}, ${userData['barangay']},\n${userData['municipality']}, ${userData['province']}',
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                  )),
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return const Text('Error loading user data');
                        } else {
                          Map<String, dynamic> userData =
                          snapshot.data?.data() as Map<String, dynamic>;
                          String userInformation =
                          buildUserInformation(userData);
                          return Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10.0),
                                child: QrImageView(
                                  data: userInformation,
                                  version: QrVersions.auto,
                                  size: 150.0,
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),

                ],
              ),
            ],
          ),
        ],
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
