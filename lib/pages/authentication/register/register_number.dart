import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sp_app/pages/authentication/register/register_otp.dart';

class RegisterNumber extends StatefulWidget {
  final String residentSelection;

  const RegisterNumber({
    Key? key,
    required this.residentSelection,
  }) : super(key: key);

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

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegisterOTP(
          mobileNumberController: mobileNumberController,
          residentSelection: residentSelection,
        )),
      );

    } catch (e) {
      // Handle any errors that might occur during the Firestore query
      print('Error checking mobile number: $e');
      // You can show an error snackbar or handle it as appropriate for your app
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
                          decoration: const InputDecoration(
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
}
