import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.dispose();
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
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue[500]?.withOpacity(0.9) ??
                        Colors.blue[500],
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
                              'lib/images/bocaue_logo.png',
                              height: 50,
                              width: 50,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Text(
                                'Republic of the Philippine\nBocaue, Bulacan',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Image.asset(
                        //   'lib/images/sp_logo_mini.png',
                        //   height: 70,
                        //   width: 70,
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              FutureBuilder(
                                future: faceScanRef.getDownloadURL(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return const Text('Error loading image');
                                  } else {
                                    return Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black38,
                                          width: 1,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        child: Image.network(
                                          snapshot.data.toString(),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                              const SizedBox(height: 10),
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
                                    Map<String, dynamic> userData =
                                        snapshot.data?.data()
                                            as Map<String, dynamic>;
                                    return Text(
                                      '${userData['residency']}',
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
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
                                                'Error loading user data',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ));
                                          } else {
                                            Map<String, dynamic> userData =
                                                snapshot.data?.data()
                                                    as Map<String, dynamic>;
                                            return RichText(
                                              text: TextSpan(
                                                style: const TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.black,
                                                ),
                                                children: <TextSpan>[
                                                  const TextSpan(
                                                      text:
                                                          'Last Name, First Name, M.I.\n',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w200,
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
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          RichText(
                                            text: const TextSpan(
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black,
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: 'Gender\n',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w200,
                                                        color: Colors.black54,
                                                        fontSize: 10)),
                                                TextSpan(
                                                    text: 'M',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    )),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 20),
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
                                                Map<String, dynamic> userData =
                                                    snapshot.data?.data()
                                                        as Map<String, dynamic>;
                                                return RichText(
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.black,
                                                    ),
                                                    children: <TextSpan>[
                                                      const TextSpan(
                                                          text: 'Birthdate\n',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w200,
                                                              color: Colors
                                                                  .black54,
                                                              fontSize: 10)),
                                                      TextSpan(
                                                          text:
                                                              '${userData['birthdate']}',
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                          )),
                                                    ],
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                          const SizedBox(width: 20),
                                          RichText(
                                            text: const TextSpan(
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black,
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: 'Civil Status\n',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w200,
                                                        color: Colors.black54,
                                                        fontSize: 10)),
                                                TextSpan(
                                                    text: 'Single',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
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
                                            Map<String, dynamic> userData =
                                                snapshot.data?.data()
                                                    as Map<String, dynamic>;
                                            return RichText(
                                              text: TextSpan(
                                                style: const TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.black,
                                                ),
                                                children: <TextSpan>[
                                                  const TextSpan(
                                                      text: 'Address\n',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w200,
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
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
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
                                                Map<String, dynamic> userData =
                                                    snapshot.data?.data()
                                                        as Map<String, dynamic>;
                                                DateTime createdAt = userData[
                                                        'created_at']
                                                    .toDate(); // Convert Firestore timestamp to DateTime
                                                String formattedDate = DateFormat(
                                                        'yyyy-MM-dd')
                                                    .format(
                                                        createdAt); // Format the DateTime
                                                return RichText(
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.black,
                                                    ),
                                                    children: <TextSpan>[
                                                      const TextSpan(
                                                        text: 'Date Issued\n',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w200,
                                                          color: Colors.black54,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: formattedDate,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
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
                                            Map<String, dynamic> userData =
                                                snapshot.data?.data()
                                                    as Map<String, dynamic>;
                                            return Text(
                                              '${userData['userID']}',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
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
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return const Text('Error loading user data');
                    } else {
                      Map<String, dynamic> userData =
                          snapshot.data?.data() as Map<String, dynamic>;
                      String userInformation = buildUserInformation(userData);
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
    );
  }

  String buildUserInformation(Map<String, dynamic> userData) {
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
