import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sp_app/pages/home/home_page.dart';
import 'package:sp_app/pages/home/update_residency/update_face_scan.dart';

class UpdateResidency extends StatefulWidget {
  final String userId;

  const UpdateResidency({
    super.key,
    required this.userId,
  });

  @override
  State<UpdateResidency> createState() => _UpdateResidencyState();
}

class _UpdateResidencyState extends State<UpdateResidency> {
  late String userId;

  String selectedRegion = "0";
  String selectedProvince = "0";
  String selectedMunicipality = "0";
  String selectedBarangay = "0";

  TextEditingController municipalityController = TextEditingController();
  TextEditingController barangayController = TextEditingController();
  TextEditingController streetController = TextEditingController();

  @override
  void initState() {
    userId = widget.userId;

    String defaultMunicipalityValue = "San Pedro";

    municipalityController.text = defaultMunicipalityValue;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.green,
          ),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    // Navigate back to the homepage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(userId: userId),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text(
                      '< Back to Homepage',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white, // Change the text color
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  Wrap(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Section Title
                          const Text(
                            'Address',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16, // Increase font size
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, left: 8.0, right: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(
                                          bottom: 10.0, top: 15.0),
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: DropdownButton<String>(
                                        items: const [
                                          DropdownMenuItem(
                                            value: "0",
                                            child: Text('Region IV - A'),
                                          ),
                                        ],
                                        onChanged: (regionValue) {
                                          setState(() {
                                            selectedRegion = regionValue!;
                                          });
                                          print(regionValue);
                                        },
                                        value: selectedRegion,
                                        isExpanded: true,
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: DropdownButton<String>(
                                        items: const [
                                          DropdownMenuItem(
                                            value: "0",
                                            child: Text('Laguna'),
                                          ),
                                        ],
                                        onChanged: (provinceValue) {
                                          setState(() {
                                            selectedProvince = provinceValue!;
                                          });
                                          print(provinceValue);
                                        },
                                        value: selectedProvince,
                                        isExpanded: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, left: 8.0, right: 8.0),
                            child: TextField(
                              enabled: false,
                              controller: municipalityController,
                              style: const TextStyle(color: Colors.black),
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                border: OutlineInputBorder(),
                                hintText: "Municipality",
                                hintStyle: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, left: 8.0, right: 8.0),
                            child: TextField(
                              controller: barangayController,
                              style: const TextStyle(color: Colors.black),
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                border: OutlineInputBorder(),
                                hintText: "Barangay",
                                hintStyle: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, left: 8.0, right: 8.0),
                            child: TextField(
                              controller: streetController,
                              style: const TextStyle(color: Colors.black),
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                border: OutlineInputBorder(),
                                hintText:
                                    "Building No./House No./Unit No./Street",
                                hintStyle: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: SizedBox(
                      width: 300,
                      child: GestureDetector(
                        onTap: () {
                          if (barangayController.text.isEmpty ||
                              streetController.text.isEmpty) {
                            // If any field is empty, show a snackbar or toast message and return
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please fill in all fields'),
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateFaceScan(
                                  userId: userId,
                                  selectedRegion: selectedRegion,
                                  selectedProvince: selectedProvince,
                                  municipalityController:
                                      municipalityController,
                                  barangayController: barangayController,
                                  streetController: streetController,
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green[800],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.all(18),
                          child: const Center(
                            child: Text(
                              'Continue',
                              style: TextStyle(
                                color: Colors.white,
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
          ]),
        ),
      ),
    );
  }
}
