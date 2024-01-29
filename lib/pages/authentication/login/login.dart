import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sp_app/pages/authentication/authentication.dart';
import 'package:sp_app/pages/authentication/login/login_otp.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController mobileNumberController = TextEditingController();
  bool acceptedTerms = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    checkTermsAndConditions();
  }

  Future<void> checkTermsAndConditions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasAccepted = prefs.getBool('acceptedTerms') ?? false;

    if (!hasAccepted) {
      showTermsAndConditionsDialog();
    }
  }

  Future<void> showTermsAndConditionsDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Terms and Conditions'),
              content: Column(
                children: [
                  const Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit.'),
                  Row(
                    children: [
                      Checkbox(
                        value: acceptedTerms,
                        onChanged: (bool? value) {
                          setState(() {
                            acceptedTerms = value!;
                          });
                        },
                      ),
                      const Text('I accept the terms and conditions'),
                    ],
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    declineTermsAndConditions();
                  },
                  child: const Text('Decline'),
                ),
                TextButton(
                  onPressed: () {
                    if (acceptedTerms) {
                      Navigator.of(context).pop(); // Close the dialog
                      acceptTermsAndConditions();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('You must agree to the terms and conditions'),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text('Accept'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> acceptTermsAndConditions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('acceptedTerms', true);
  }

  Future<void> declineTermsAndConditions() async {
    // Handle decline action if needed
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Authentication()),
    );
  }

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
      String retrievedUserID = querySnapshot.docs[0]['userID'];

      String randomDigits = generateRandomString(6);
      // sendMessage(randomDigits);

      // Navigate to the next screen (LoginMPIN) and pass the values
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginOTP(
            mobileNumber: retrievedMobileNumber,
            pinPassword: retrievedPinPassword,
            userID: retrievedUserID,
            otp: randomDigits,
          ),
        ),
      );
    } catch (e) {
      // Handle any errors that might occur during the Firestore query
      print('Error checking mobile number: $e');
      // You can show an error snackbar or handle it as appropriate for your app
    }
  }

  // void sendMessage(String randomDigits) async {
  //
  //   var apiUrl = 'https://semaphore.co/api/v4/messages';
  //   var apiKey = 'c2ccfae1d1ab68804ff30ea669c47581';
  //   var number = mobileNumberController.text;
  //   var senderName = 'SEMAPHORE';
  //   var message = 'Your One-time-Password is $randomDigits';
  //
  //   var parameters = {
  //     'apikey': apiKey,
  //     'number': number,
  //     'message': message,
  //     'sendername': senderName,
  //   };
  //
  //   // Make the POST request
  //   var response = await http.post(
  //     Uri.parse(apiUrl),
  //     body: parameters,
  //   );
  //
  //   // Check if the request was successful (status code 200)
  //   if (response.statusCode == 200) {
  //     // Print the server response
  //     print(response.body);
  //   } else {
  //     // Print an error message if the request was not successful
  //     print('Request failed with status: ${response.statusCode}');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Authentication()),
        );
        return false; // Returning false prevents the screen from being popped automatically
      },
      child: Scaffold(
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
                                  if (mobileNumberController.text.isEmpty || isLoading) {
                                    return;
                                  }

                                  setState(() {
                                    isLoading = true;
                                  });

                                  // Call the function to check if the mobile number is registered
                                  checkMobileNumber(context, mobileNumberController.text)
                                      .then((_) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  padding: const EdgeInsets.all(18),
                                  child: Center(
                                    child: isLoading
                                        ? CircularProgressIndicator(
                                      color: Colors.green,
                                      backgroundColor: Colors.green[200],
                                    )
                                        : const Text(
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
      ),
    );
  }

  String generateRandomString(int length) {
    const String characterSet =
        '1234567890';
    Random random = Random();

    StringBuffer buffer = StringBuffer();

    for (int i = 0; i < length; i++) {
      int randomIndex = random.nextInt(characterSet.length);
      buffer.write(characterSet[randomIndex]);
    }

    return buffer.toString();
  }

}
