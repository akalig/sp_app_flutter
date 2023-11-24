import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_mpin.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController mobileNumberController = TextEditingController();

  Future<void> checkMobileNumber(BuildContext context, String mobileNumber) async {
    try {
      // Make a query to Firestore to retrieve the user with the provided mobile number
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('mobile_number', isEqualTo: mobileNumber)
          .get();

      // Check if there's a user with the provided mobile number
      if (querySnapshot.docs.isEmpty) {
        // Mobile number not registered, show snackbar and return
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mobile Number not registered'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Mobile number is registered
      // Retrieve the mobile number and pin_password from the first document (assuming there's only one)
      String retrievedMobileNumber = querySnapshot.docs[0]['mobile_number'];
      String retrievedPinPassword = querySnapshot.docs[0]['pin_password'];

      // Navigate to the next screen (LoginMPIN) and pass the values
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginMPIN(
            mobileNumber: retrievedMobileNumber,
            pinPassword: retrievedPinPassword,
          ),
        ),
      );
    } catch (e) {
      // Handle any errors that might occur during the Firestore query
      print('Error checking mobile number: $e');
      // You can show an error snackbar or handle it as appropriate for your app
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            Image.asset(
              'lib/images/sp-logo.png',
              height: 300,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.green[900],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Enter your mobile number',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      children: [
                        TextField(
                          controller: mobileNumberController,
                          maxLength: 10,
                          style: const TextStyle(color: Colors.black),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            border: OutlineInputBorder(),
                            hintText: "🇵🇭 +63",
                            hintStyle: TextStyle(
                              fontSize: 20.0,
                              color: Colors.grey,
                            ),
                            hoverColor: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 25.0),
                          child: SizedBox(
                            width: 300,
                            child: GestureDetector(
                              onTap: () {
                                if (mobileNumberController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please fill in all fields'),
                                      duration: Duration(seconds: 2),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                // Call the function to check if the mobile number is registered
                                checkMobileNumber(context, mobileNumberController.text);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                padding: const EdgeInsets.all(18),
                                child: const Center(
                                  child: Text(
                                    'LOGIN',
                                    style: TextStyle(
                                      color: Colors.black,
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
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Forgot Password? ',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Click here',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
