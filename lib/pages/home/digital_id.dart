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
      body: Stack(
        children: [
          // Background image
          Image.asset(
            'lib/images/san_pedro_laguna.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          // Semi-transparent white layer
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.green[900]?.withOpacity(0.9) ?? Colors.green[900],
          ),

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
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 30.0),
                          child: Text(
                            'My Digital ID',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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
                                              text: 'Name:\n',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                          TextSpan(
                                              text:
                                                  '${userData['first_name']} ${userData['middle_name']} ${userData['last_name']} ${userData['suffix_name']}',
                                              style: const TextStyle(
                                                color: Colors.white,
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
                                              text: 'Address:\n',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              )),
                                          TextSpan(
                                              text:
                                                  '${userData['street']}, ${userData['barangay']},\n ${userData['municipality']}, ${userData['province']},\n ${userData['region']}',
                                              style: const TextStyle(
                                                color: Colors.white,
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
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                padding: const EdgeInsets.all(10.0),
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
