import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sp_app/pages/home/home_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class EmergencyStatus extends StatefulWidget {
  final String userId;

  const EmergencyStatus({
    super.key,
    required this.userId,
  });

  @override
  State<EmergencyStatus> createState() => _EmergencyStatusState();
}

class _EmergencyStatusState extends State<EmergencyStatus> {
  late String userId;
  late String emergencyStatus = "";
  late Timer timer;

  // @override
  // void initState() {
  //   userId = widget.userId;
  //
  //   sendUserIDToServer(userId);
  //   super.initState();
  // }

  @override
  void initState() {
    userId = widget.userId;

    // Call sendUserIDToServer once immediately
    sendUserIDToServer(userId);

    // Set up a timer to call sendUserIDToServer every 5 seconds
    timer = Timer.periodic(const Duration(seconds: 5), (Timer t) {
      sendUserIDToServer(userId);
    });

    super.initState();
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(userId: userId)),
        );
        return false; // Returning false prevents the screen from being popped automatically
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: [
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        Image.asset(
                          'lib/images/warning.png',
                          height: 300,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Emergency Services Activated',
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          'Status: $emergencyStatus',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green[900],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      const SizedBox(height: 40),

                      const Text(
                        'Command Center has been informed of your Location and information.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 40),

                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: SizedBox(
                          width: 300,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(userId: userId),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: const EdgeInsets.all(18),
                              child: const Center(
                                child: Text(
                                  'Confirm',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
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
      ),
    );
  }

  Future<void> sendUserIDToServer(String userID) async {
    const url = 'https://bmwaresd.com/spapp_conn_get_emergency_status.php';

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
            if (dataItem is Map<String, dynamic> && dataItem.containsKey('status')) {

              setState(() {
                // Update emergencyStatus and trigger a rebuild
                emergencyStatus = dataItem['status'];
              });

              print('Emergency Status: $emergencyStatus');

              // Update Firestore
              await updateFirestoreEmergencyStatus(userId, emergencyStatus);

              // Show a Snackbar with the user status
              // final snackBar = SnackBar(
              //   content: Text('Emergency Status: $emergencyStatus'),
              //   duration: Duration(seconds: 3), // Adjust the duration as needed
              // );
              //
              // // Find the Scaffold in the widget tree and show the Snackbar
              // ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else {
              print('Response item does not contain the expected status field.');
            }
          }
        } else {
          print('Response is empty or not in the expected format.');
        }
      } else {
        // If the server returns an error response
        print('Failed to send data to server. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exception that occurs during the HTTP request
      print('Error sending data to server: $e');
    }
  }

  Future<void> updateFirestoreEmergencyStatus(String userId, String emergencyStatus) async {
    try {
      CollectionReference users = FirebaseFirestore.instance.collection('emergency');

      // Update the document where userID is equal to userId
      await users.doc(userId).update({
        'status': emergencyStatus,
      });

      print('User status updated in Firestore successfully');
    } catch (e) {
      print('Error updating user status in Firestore: $e');
    }
  }

}
