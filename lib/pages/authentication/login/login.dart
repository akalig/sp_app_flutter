import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sp_app/pages/authentication/authentication.dart';
import 'package:sp_app/pages/authentication/login/login_otp.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text('GENERAL', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold)),
                    const Text(
                      'The Terms and Conditions contained herein on this mobile application called San Pedro App shall govern the use of this App, including all pages to which the user may be redirected. These terms apply in full force and effect to the use of this App. The user’s personal data, whenever provided within the App shall be processed and shall be governed by the provisions of the Republic Act (RA) No 10173 or the Data Privacy Act of 2012, and all other applicable laws. Whenever used herein, “App Owner” shall mean City Government of San Pedro.',
                      textAlign: TextAlign.justify,
                    ),

                    const SizedBox(height: 20),

                    const Text('BASIC TERMS', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold),),
                    const Text(
                      'Only the user who is fifteen (15) years old and above may access the full features of the San Pedro App.',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'If the user is below fifteen (15) years old, parental consent or legal guardian consent will be required from them for their use of San Pedro App. It shall be the parent, legal guardian, or other person exercising parental authority over the user who is below 15 years of age who allows, authorizes, and consents to the opening of the San Pedro app who shall be principally responsible over the account and responsible for ensuring that the latter read and understand and deemed to accept these Terms and explain the use of the San Pedro app features and services. App Owner assumes no responsibility or liability for any misrepresentation of the user’s age.',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20),
                    const Text('AUTHORITY', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold)),
                    const Text(
                      'By registering in the App, the user warrants that they are duly authorized to register, request access, and supply information on their behalf. The App Owner may, at its sole discretion, request additional or supporting documents to prove such authority.',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'By providing the requested information for verification of the user’s account, they consent that their information provided - which will serve as their digital ID, may be generated through the App. These personal data needed are specified in the Privacy Policy of San Pedro App.',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'The user also warrants that all information supplied is verified, true, and correct to the best of their knowledge.',
                      textAlign: TextAlign.justify,
                    ),

                    const SizedBox(height: 20),

                    const Text('USE', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold),),
                    const Text(
                      'Through registration and by having access to the App, the user hereby warrants that the App shall only be used for the following purposes:',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Registration for e-government services',
                      textAlign: TextAlign.justify,
                    ),

                    const SizedBox(height: 20),

                    const Text('RESTRICTIONS', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold),),
                    const Text(
                      'The user is expressly and emphatically restricted from all of the following:',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Selling, sub-licensing, and/or otherwise commercializing the App;',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Using the App or any of the information in illegal or unlawful activities;',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Publicly performing and/or showing any App material;',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Using this App in any way that is, or may be, damaging to this App;',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Using this App in any way that impacts user access to this App;',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Using this App contrary to applicable laws and regulations, or in a way that causes, or may cause, harm to the App, or to the App Owner or any person or organization;',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Engaging in any data mining, data harvesting, data extracting or any other similar activity in relation to this App, or while using this App; and',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Using this App to engage in any advertising or marketing.',
                      textAlign: TextAlign.justify,
                    ),

                    const SizedBox(height: 20),

                    const Text('PROFILE', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold),),
                    const Text(
                      'All information gathered by the App shall be treated as confidential. This App uses personal information - whether considered sensitive or not, as defined under Section 3 of the Data Privacy Act of 2012, and non-personal information to the extent necessary to comply with the requirements of the laws and legal processes, including orders of governmental agencies, courts, and tribunals; to comply with a legal obligation; or to prevent imminent harm to public security, safety, or order.',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'When required by the App’s Data Privacy Policy and the laws, and before the App uses or processes User’s data for any other purpose, the App will secure the User’s consent. The App Owner shall use the information provided by the User in accordance with the processes in Sections 12 and 13 of the Data Privacy Act of 2012.',
                      textAlign: TextAlign.justify,
                    ),

                    const SizedBox(height: 20),

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
                          content: Text(
                              'You must agree to the terms and conditions'),
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

  Future<void> checkMobileNumber(
      BuildContext context, String mobileNumber) async {
    try {
      // Make a query to Firestore to retrieve the user with the provided mobile number
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
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
      sendMessage(randomDigits);

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

  void sendMessage(String randomDigits) async {

    var apiUrl = 'https://semaphore.co/api/v4/messages';
    var apiKey = '39ec15e9be8f5f92843681f3d84e4ba8';
    var number = mobileNumberController.text;
    var senderName = 'SEMAPHORE';
    var message = 'Your One-time-Password is $randomDigits';

    var parameters = {
      'apikey': apiKey,
      'number': number,
      'message': message,
      'sendername': senderName,
    };

    // Make the POST request
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
                              prefixText: '+63 ', // Prefix text
                              prefixStyle: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black54,
                              ),
                              hintText: "Mobile Number",
                              hintStyle: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey,
                                fontWeight: FontWeight.w600
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
                                  if (mobileNumberController.text.isEmpty ||
                                      isLoading) {
                                    return;
                                  }

                                  setState(() {
                                    isLoading = true;
                                  });

                                  // Call the function to check if the mobile number is registered
                                  checkMobileNumber(
                                          context, mobileNumberController.text)
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
    const String characterSet = '1234567890';
    Random random = Random();

    StringBuffer buffer = StringBuffer();

    for (int i = 0; i < length; i++) {
      int randomIndex = random.nextInt(characterSet.length);
      buffer.write(characterSet[randomIndex]);
    }

    return buffer.toString();
  }
}
