import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_app/pages/home/update_residency/update_residency.dart';
import '../../FirebaseMessagingAPI/firebase_push_notification_api.dart';
import '../authentication/login/login.dart';
import 'home_screens/notifications.dart';
import 'home_screens/home.dart';
import 'home_screens/news.dart';
import 'home_screens/profile.dart';
import 'digital_id.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final String userId;

  const HomePage({
    Key? key, // Correct usage of Key
    required this.userId,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String userId;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebasePushNotificationAPI _firebasePushNotificationAPI =
  FirebasePushNotificationAPI();

  @override
  void initState() {
    userId = widget.userId;
    saveNotificationInfoInFirestore(userId);
    super.initState();
  }

  int currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      Home(userId: userId),
      const News(),
      const Notifications(),
      const Profile(),
    ];

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async {
          await checkResidency(userId, context);
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.assignment_ind_outlined,
            color: Colors.black54, size: 30),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,
                color: currentIndex == 0 ? Colors.green : Colors.grey),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_rounded,
                color: currentIndex == 1 ? Colors.green : Colors.grey),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications,
                color: currentIndex == 2 ? Colors.green : Colors.grey),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard,
                color: currentIndex == 3 ? Colors.green : Colors.grey),
            label: 'Profile',
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Logout or Exit'),
              content: const Text('Do you want to logout or exit the app?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove('userID');
                    prefs.setBool('isLoggedIn', false);

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  },
                  child: const Text('Logout'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    SystemNavigator.pop();
                  },
                  child: const Text('Exit'),
                ),
              ],
            ),
          );
        },
        child: screens[currentIndex], // Wrap this line with WillPopScope
      ),
    );
  }

  Future<void> checkResidency(String userID, BuildContext context) async {
    try {
      // Reference to the Firestore collection
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');

      // Query the user's document based on userID
      DocumentSnapshot userSnapshot = await usersCollection.doc(userID).get();

      // Check if the document exists
      if (userSnapshot.exists) {
        // Get the residency field
        String residency = userSnapshot.get('residency');

        if (residency == 'Resident') {

          await checkApproval(userID);

        } else {
          // Show an AlertDialog if the user is a Non-Resident
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Access Denied'),
                content: Text('Digital ID is exclusive for Residents Only.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Close'),
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => UpdateResidency(userId: userId)),
                      );
                    },
                    child: Text('Update to Resident Account'),
                  ),
                ],
              );
            },
          );
        }

      } else {
        // Handle the case when the user document doesn't exist
        print('User document does not exist');
      }
    } catch (e) {
      // Handle errors, e.g., network issues
      print('Error checking approval: $e');
    }
  }

  Future<void> checkApproval(String userID) async {
    try {
      // Reference to the Firestore collection
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');

      // Query the user's document based on userID
      DocumentSnapshot userSnapshot = await usersCollection.doc(userID).get();

      // Check if the document exists
      if (userSnapshot.exists) {
        // Get the residency field
        String status = userSnapshot.get('status');

        if (status == 'Approved') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DigitalID(
                userId: userId,
              ),
            ),
          );
        } else {
          // Show an AlertDialog if the user is a Non-Resident
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Access Denied'),
                content: Text('Account must be approved first.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Close'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        // Handle the case when the user document doesn't exist
        print('User document does not exist');
      }
    } catch (e) {
      // Handle errors, e.g., network issues
      print('Error checking approval: $e');
    }
  }

  void saveNotificationInfoInFirestore(String userID) async {
    try {
      // Reference to the collection 'push_notification_token'
      CollectionReference tokenCollection = _firestore.collection('push_notification_token');

      // Create a document with the user ID
      DocumentReference userDocument = tokenCollection.doc(userID);

      String? fcm = await _firebasePushNotificationAPI.initNotifications();

      // Set the data in the document
      await userDocument.set({
        'userID': userID,
        'fcm_token': fcm,
        'timestamp': FieldValue.serverTimestamp(),
      });

      await saveNotificationInfoInServer(userId);

      print('Notification info saved successfully');
    } catch (error) {
      print('Error saving notification info: $error');
      // Handle the error as needed
    }
  }

  Future<void> saveNotificationInfoInServer(String userID) async {
    const url = 'https://bmwaresd.com/spapp_conn_send_push_notification_info.php';
    String? fcm = await _firebasePushNotificationAPI.initNotifications();
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'userID': userID,
          'region': fcm,
          'created_at': FieldValue.serverTimestamp(),
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
}
