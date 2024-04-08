import 'dart:convert';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../emergencies.dart';
import 'package:http/http.dart' as http;
import '../emergency_status.dart';

class Home extends StatefulWidget {
  final String userId;

  const Home({
    super.key,
    required this.userId,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String userId;

  String userName = "";
  String userResidency = "";
  String userMobileNumber = "";

  late Reference faceScanRef;

  @override
  void initState() {
    userId = widget.userId;
    _fetchUserData();
    sendUserIDToServer(userId);

    faceScanRef = FirebaseStorage.instance
        .ref()
        .child('user_face_scan/$userId/capturedFaceScan.jpg');

    super.initState();
  }

  Future<void> _fetchUserData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .where('userID', isEqualTo: userId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var userData = snapshot.docs[0].data();

        String firstName = userData['first_name'] ?? '';
        String middleName = userData['middle_name'] ?? '';
        String lastName = userData['last_name'] ?? '';
        String suffixName = userData['suffix_name'] ?? '';

        userName = '$firstName $middleName $lastName $suffixName';

        userResidency = userData['residency'] ?? '';
        userMobileNumber = userData['mobile_number'] ?? '';

        setState(() {});
      } else {
        print('User not found');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      child: Column(
        children: [
          Container(
            child: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green[900],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 0),
                child: Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 8.0, right: 25.0),
                        child: FutureBuilder(
                          future: faceScanRef.getDownloadURL(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return ClipOval(
                                child: Image.asset(
                                  'lib/images/app_icon.png',
                                  height: 70,
                                  width: 70,
                                ),
                              );
                            } else {
                              return ClipOval(
                                child: Image.network(
                                  snapshot.data.toString(),
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                ),
                              );
                            }
                          },
                        )),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            'Hello, $userName', // Use the userName variable
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            userResidency, // Use the userResidency variable
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            '+63$userMobileNumber',
                            // Use the userMobileNumber variable
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            // Retrieve data from Firestore
                            DocumentSnapshot snapshot = await FirebaseFirestore
                                .instance
                                .collection('emergency')
                                .doc(userId)
                                .get();
                            if (snapshot.exists) {
                              // Check the status field
                              String status = snapshot['status'];
                              if (status == 'Completed' ||
                                  status == 'Deferred') {
                                // Navigate to Emergencies()
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Emergencies(userId: userId),
                                  ),
                                );
                              } else {
                                // Navigate to EmergencyStatus()
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EmergencyStatus(userId: userId),
                                  ),
                                );
                              }
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Emergencies(userId: userId),
                                ),
                              );
                            }
                          },
                          child: AvatarGlow(
                            startDelay: const Duration(milliseconds: 1000),
                            glowColor: Colors.redAccent,
                            glowShape: BoxShape.circle,
                            curve: Curves.fastOutSlowIn,
                            child: const Material(
                              elevation: 5.0,
                              shape: CircleBorder(),
                              color: Colors.transparent,
                              child: CircleAvatar(
                                backgroundImage: AssetImage(
                                    'lib/images/emergency_button.png'),
                                radius: 135.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Tap in case of emergency',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 70, // Set your desired width
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.green[800],
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.waving_hand,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            'Coming Soon',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 8),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 70, // Set your desired width
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.green[800],
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.waving_hand,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            'Coming Soon',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 8),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 70, // Set your desired width
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.green[800],
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.waving_hand,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            'Coming Soon',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 8),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 70, // Set your desired width
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.green[800],
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.waving_hand,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            'Coming Soon',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 8),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 70, // Set your desired width
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.green[800],
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.waving_hand,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            'Coming Soon',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 8),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 70, // Set your desired width
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.green[800],
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.waving_hand,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            'Coming Soon',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 8),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 70, // Set your desired width
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.green[800],
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.waving_hand,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            'Coming Soon',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 8),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 70, // Set your desired width
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.green[800],
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.waving_hand,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            'Coming Soon',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 8),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> sendUserIDToServer(String userID) async {
    const url = 'https://bmwaresd.com/spapp_conn_get_user_status.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'userID': userID,
        },
      );

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response
        print('Data sent to server successfully');

        // Parse the JSON response
        final List<dynamic> dataList = json.decode(response.body);

        // Check if the response is a list and is not empty
        if (dataList.isNotEmpty) {
          // Assuming that each item in the list has a 'status' field
          for (var dataItem in dataList) {
            if (dataItem is Map<String, dynamic> &&
                dataItem.containsKey('status')) {
              String userStatus = dataItem['status'];
              print('User Status: $userStatus');

              // Update Firestore
              await updateFirestoreUserStatus(userId, userStatus);

              // Show a Snackbar with the user status
              // final snackBar = SnackBar(
              //   content: Text('User Status: $userStatus'),
              //   duration: const Duration(seconds: 3), // Adjust the duration as needed
              // );
              //
              // // Find the Scaffold in the widget tree and show the Snackbar
              // ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else {
              print(
                  'Response item does not contain the expected status field.');
            }
          }
        } else {
          print('Response is empty or not in the expected format.');
        }
      } else {
        // If the server returns an error response
        print(
            'Failed to send data to server. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exception that occurs during the HTTP request
      print('Error sending data to server: $e');
    }
  }

  Future<void> updateFirestoreUserStatus(
      String userId, String userStatus) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      // Update the document where userID is equal to userId
      await users.doc(userId).update({
        'status': userStatus,
      });

      print('User status updated in Firestore successfully');
    } catch (e) {
      print('Error updating user status in Firestore: $e');
    }
  }
}
