import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../authentication/authentication.dart';
import '../authentication/login/login.dart';
import 'home_screens/notifications.dart';
import 'home_screens/home.dart';
import 'home_screens/news.dart';
import 'home_screens/profile.dart';
import 'digital_id.dart';

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

  @override
  void initState() {
    userId = widget.userId;
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
          await checkApproval(userId, context);
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

  Future<void> checkApproval(String userID, BuildContext context) async {
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
          await checkResidency(userID);

          // Show a SnackBar if the user is a Resident
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You are a Approved!'),
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
                    child: Text('OK'),
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

  Future<void> checkResidency(String userID) async {
    try {
      // Reference to the Firestore collection
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');

      // Query the user's document based on userID
      DocumentSnapshot userSnapshot = await usersCollection.doc(userID).get();

      // Check if the document exists
      if (userSnapshot.exists) {
        // Get the residency field
        String status = userSnapshot.get('residency');

        if (status == 'Resident') {
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
                content: Text('Digital ID is exclusive for Residents Only.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
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
}
