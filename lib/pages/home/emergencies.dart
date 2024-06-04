import 'dart:async';
import 'package:flutter/material.dart';
import 'package:action_slider/action_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:sp_app/pages/home/emergency_status.dart';
import 'package:sp_app/pages/home/home_page.dart';
import '../location/location_service.dart';
import 'package:http/http.dart' as http;

class Emergencies extends StatefulWidget {
  final String userId;

  const Emergencies({
    super.key,
    required this.userId,
  });

  @override
  State<Emergencies> createState() => _EmergenciesState();
}

class _EmergenciesState extends State<Emergencies> {
  late String userId;
  bool isClickedEmergency = true;
  int countdown = 5;
  late Timer countdownTimer;

  final LocationService locationService = LocationService();

  @override
  void initState() {
    userId = widget.userId;
    startCountdown();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white, // Set the background color of the scaffold to white
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 100),

            const Text('Select Emergency Service',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              textAlign: TextAlign.start,
            ),

            const SizedBox(height: 20),

            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10),
                  child: GestureDetector(
                    onTap: () {
                      // setState(() {
                      //   isClickedEmergency = !isClickedEmergency;
                      // });

                      String emergency = "Emergency Medical Service";
                      stopCountdown();
                      sendEmergency(emergency);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.blue[500],
                        borderRadius: BorderRadius.circular(10.0),
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset(
                            'lib/images/ambulance.png',
                            height: 70,
                          ),

                          const Text('Emergency Medical\n Services',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10),
                  child: GestureDetector(
                    onTap: () {
                      // setState(() {
                      //   isClickedEmergency = !isClickedEmergency;
                      // });

                      String emergency = "Police Department";
                      stopCountdown();
                      sendEmergency(emergency);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.blue[600],
                        borderRadius: BorderRadius.circular(10.0),
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset(
                            'lib/images/police.png',
                            height: 70,
                          ),

                          const Text('Police Department',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10),
                  child: GestureDetector(
                    onTap: () {
                      // setState(() {
                      //   isClickedEmergency = !isClickedEmergency;
                      // });

                      String emergency = "Fire Department";
                      stopCountdown();
                      sendEmergency(emergency);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.blue[600],
                        borderRadius: BorderRadius.circular(10.0),
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset(
                            'lib/images/firetruck.png',
                            height: 70,
                          ),

                          const Text('Fire Department',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            Container(
              child: isClickedEmergency ? Text('Please choose Emergency Services in $countdown') : Container(),
            ),

            const SizedBox(height: 20),

            Container(
              child: isClickedEmergency ? ActionSlider.standard(
                rolling: true,
                width: 300.0,
                backgroundColor: Colors.white,
                reverseSlideAnimationCurve: Curves.easeInOut,
                reverseSlideAnimationDuration: const Duration(milliseconds: 500),
                toggleColor: Colors.blue[600],
                icon: Icon(Icons.cancel_rounded, color: Colors.white,),
                action: (controller) async {
                  stopCountdown();
                  controller.loading(); //starts loading animation
                  await Future.delayed(const Duration(seconds: 1));
                  controller.success(); //starts success animation
                  await Future.delayed(const Duration(seconds: 2));
                  controller.reset(); //resets the slider

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage(userId: userId)),
                  );
                },
                child: const Text('Slide to Cancel',
                    style: TextStyle(color: Colors.black)),
              ) : Container(),
            ),
          ],
        ),
      ),
    );
  }

  void startCountdown() {
    setState(() {
      isClickedEmergency = true;
    });

    const oneSecond = Duration(seconds: 1);
    countdownTimer = Timer.periodic(oneSecond, (Timer timer) {
      if (countdown == 1) {
        timer.cancel();
        setState(() {
          isClickedEmergency = false;
          countdown = 5; // Reset countdown for the next tap
        });
        sendNonIndicateEmergency();
      } else {
        setState(() {
          countdown--;
        });
      }
    });
  }

  void stopCountdown() {
    if (countdownTimer.isActive) {
      countdownTimer.cancel();
      setState(() {
        // isClickedEmergency = false;
        countdown = 0; // Reset countdown
      });
    }
  }

  void sendNonIndicateEmergency() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('userID', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {

        String emergency = 'Non Indicate Emergency';
        String status = 'Pending';

        Map<String, dynamic> userData = querySnapshot.docs[0].data();

        Map<String, double> location = await locationService.getLocation();
        print('Latitude: ${location['latitude']}, Longitude: ${location['longitude']}');

        CollectionReference emergencyCollection = FirebaseFirestore.instance.collection('emergency');
        DocumentReference documentReference = emergencyCollection.doc(userId);

        await documentReference.set({
          'userID': userData['userID'],
          'first_name': userData['first_name'],
          'last_name': userData['last_name'],
          'middle_name': userData['middle_name'],
          'suffix_name': userData['suffix_name'],
          'mobile_number': userData['mobile_number'],
          'residency': userData['residency'],
          'latitude': location['latitude'],
          'longitude': location['longitude'],
          'status': status,
          'emergency': emergency,
          'created_at': FieldValue.serverTimestamp(),
          'modified_at': FieldValue.serverTimestamp(),
        });

        // Send data to PHP server
        await sendDataToServer(documentReference.id, userData, location, emergency, status);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Request Sent'),
          ),
        );
      } else {
        showErrorSnackBar('Error retrieving user data. Please try again.');
      }
    } catch (e) {
      print('Error: $e');
      showErrorSnackBar('Error sending emergency request. Please try again.');
    }
  }

  void sendEmergency(String emergency) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('userID', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {

        String status = 'Pending';

        Map<String, dynamic> userData = querySnapshot.docs[0].data();

        Map<String, double> location = await locationService.getLocation();
        print('Latitude: ${location['latitude']}, Longitude: ${location['longitude']}');

        CollectionReference emergencyCollection = FirebaseFirestore.instance.collection('emergency');
        DocumentReference documentReference = emergencyCollection.doc(userId);

        await documentReference.set({
          'userID': userData['userID'],
          'first_name': userData['first_name'],
          'last_name': userData['last_name'],
          'middle_name': userData['middle_name'],
          'suffix_name': userData['suffix_name'],
          'mobile_number': userData['mobile_number'],
          'residency': userData['residency'],
          'latitude': location['latitude'],
          'longitude': location['longitude'],
          'status': status,
          'emergency': emergency,
          'created_at': FieldValue.serverTimestamp(),
          'modified_at': FieldValue.serverTimestamp(),
        });

        // Send data to PHP server
        await sendDataToServer(documentReference.id, userData, location, emergency, status);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Request Sent'),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EmergencyStatus(userId: userId)),
        );

      } else {
        showErrorSnackBar('Error retrieving user data. Please try again.');
      }
    } catch (e) {
      print('Error: $e');
      showErrorSnackBar('Error sending emergency request. Please try again.');
    }
  }

  Future<void> sendDataToServer(String documentId, Map<String, dynamic> userData, Map<String, double> location, String emergency, String status) async {
    const url = 'https://bmwaresd.com/spapp_conn_send_emergency.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'documentId': documentId,
          'userID': userData['userID'],
          'first_name': userData['first_name'],
          'last_name': userData['last_name'],
          'middle_name': userData['middle_name'],
          'suffix_name': userData['suffix_name'],
          'mobile_number': userData['mobile_number'],
          'residency': userData['residency'],
          'latitude': location['latitude'].toString(),
          'longitude': location['longitude'].toString(),
          'status': status,
          'emergency': emergency,
          'created_at': DateTime.now().toLocal().toString(),
          'modified_at': DateTime.now().toLocal().toString(),
        },
      );

      if (response.statusCode == 200) {
        print('Data sent to server successfully');
      } else {
        print('Failed to send data to server. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending data to server: $e');
    }
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
