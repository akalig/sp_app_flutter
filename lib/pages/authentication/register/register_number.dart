import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:sp_app/pages/authentication/register/register_otp.dart';
import 'dart:math';
import 'package:http/http.dart' as http;

class RegisterNumber extends StatefulWidget {
  final String residentSelection;

  const RegisterNumber({
    super.key,
    required this.residentSelection,
  });

  @override
  State<RegisterNumber> createState() => _RegisterNumberState();
}

class _RegisterNumberState extends State<RegisterNumber> {
  TextEditingController mobileNumberController = TextEditingController();
  late String residentSelection;


  Future<void> checkMobileNumber(BuildContext context, String mobileNumber) async {
    try {
      // Make a query to Firestore to retrieve the user with the provided mobile number
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('mobile_number', isEqualTo: mobileNumber)
          .get();

      // Check if there's a user with the provided mobile number
      if (querySnapshot.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mobile Number already registered'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Generate a random string of 6 digits
      String randomDigits = generateRandomString(6);

      // Send the generated OTP via SMS
      sendMessage(randomDigits);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegisterOTP(
          mobileNumberController: mobileNumberController,
          residentSelection: residentSelection,
          otp: randomDigits,
        )),
      );

    } catch (e) {
      // Handle any errors that might occur during the Firestore query
      print('Error checking mobile number: $e');
      // You can show an error snackbar or handle it as appropriate for your app
    }
  }

  void sendMessage(String randomDigits) async {

    // Semaphore API URL
    var apiUrl = 'https://semaphore.co/api/v4/messages';

    // API key for Semaphore
    var apiKey = '39ec15e9be8f5f92843681f3d84e4ba8';

    // Mobile number to send the OTP to (retrieved from a text controller)
    var number = mobileNumberController.text;

    // Sender name for the message
    var senderName = 'SanPedroApp';

    // Message to be sent, including the OTP
    var message = 'Your One-Time-Password is $randomDigits';

    // Parameters to be sent in the POST request
    var parameters = {
      'apikey': apiKey,
      'number': number,
      'message': message,
      'sender_name': senderName,
    };

    // Make the POST request to the Semaphore API
    var response = await http.post(
      Uri.parse(apiUrl),
      body: parameters,
    );

    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      // Print the server response
      print(response.body);
    } else {
      // Print an error message if the request was not successful
      print('Request failed with status: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    // Initialize the instance variables in initState
    residentSelection = widget.residentSelection;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
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
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),
                    ),
                    Column(
                      children: [
                        TextField(
                          controller: mobileNumberController,
                          maxLength: 10,
                          style: const TextStyle(color: Colors.black),
                          keyboardType: TextInputType.number,
                          decoration:  const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            border: OutlineInputBorder(),
                            hintText: "Mobile Number",
                            hintStyle: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey,
                            ),
                            prefixText: "+63 ", // Fixed text with space
                            prefixStyle: TextStyle(color: Colors.black, fontSize: 16.0), // Style for the fixed text
                            contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Adjust spacing if needed
                          ),
                        ),


                        Padding(
                          padding: const EdgeInsets.only(bottom: 25.0),
                          child: SizedBox(
                            width: 300,
                            child: GestureDetector(
                              onTap: () async {

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
                                    'REGISTER',
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
                          'San Pedro App',
                          style: TextStyle(
                            color: Colors.white,
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
