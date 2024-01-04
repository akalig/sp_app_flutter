import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sp_app/pages/authentication/authentication.dart';
import 'package:sp_app/pages/authentication/register/register_mpin.dart';
import 'scan/register_face_scan.dart';

class Register extends StatefulWidget {
  final TextEditingController mobileNumberController;
  final String residentSelection;

  const Register({
    super.key,
    required this.mobileNumberController,
    required this.residentSelection,
  });

  @override
  _RegisterState createState() => _RegisterState();
}

List<String> categoryOptions = ['Resident', 'Visitor'];

class _RegisterState extends State<Register> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController suffixNameController = TextEditingController();
  TextEditingController municipalityController = TextEditingController();
  TextEditingController barangayController = TextEditingController();
  TextEditingController streetController = TextEditingController();

  DateTime date = DateTime.now();
  bool isRegistrationSectionOneVisible = true;
  bool isRegistrationSectionTwoVisible = false;
  bool isNextButtonClicked = false;

  String buttonText = 'Select Birthdate';

  String selectedRegion = "0";
  String selectedProvince = "0";
  String selectedMunicipality = "0";
  String selectedBarangay = "0";

  late TextEditingController mobileNumberController;
  late String residentSelection;

  @override
  void initState() {
    // Initialize the instance variables in initState
    mobileNumberController = widget.mobileNumberController;
    residentSelection = widget.residentSelection;

    String defaultMunicipalityValue = "San Pedro";

    municipalityController.text =
        (residentSelection == "Resident") ? defaultMunicipalityValue : "";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        margin: const EdgeInsets.only(top: 25),
        decoration: const BoxDecoration(
          color: Colors.green,
        ),
        child: Column(
          children: [
            // Back Button
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
                        builder: (context) => const Authentication(),
                      ),
                    );
                  },
                  child: const Text(
                    '< Back',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.white, // Change the text color
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      visible: isRegistrationSectionOneVisible,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Section Title
                          const Text(
                            'Personal Information',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16, // Increase font size
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 25.0, left: 8.0, right: 8.0),
                            child: TextField(
                              controller: firstNameController,
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
                                hintText: "First Name",
                                hintStyle: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 25.0, left: 8.0, right: 8.0),
                            child: TextField(
                              controller: lastNameController,
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
                                hintText: "Last Name",
                                hintStyle: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 25.0, left: 8.0, right: 4.0),
                                  child: TextField(
                                    controller: middleNameController,
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
                                      hintText: "Middle Name",
                                      hintStyle: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 25.0, left: 4.0, right: 8.0),
                                  child: TextField(
                                    controller: suffixNameController,
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
                                      hintText: "Suffix Name",
                                      hintStyle: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.only(
                                top: 25.0, left: 8.0, right: 8.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                DateTime? newDate = await showDatePicker(
                                  context: context,
                                  initialDate: date,
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );

                                if (newDate == null) return;

                                // Update the 'date' variable with the selected date
                                setState(() {
                                  date = newDate;
                                  buttonText =
                                      '${date.year}-${date.month}-${date.day}';
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: Container(
                                padding:
                                    const EdgeInsets.only(top: 15, bottom: 15),
                                width: double.infinity,
                                child: Text(
                                  buttonText,
                                  // Use the buttonText variable here
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Visibility(
                        visible: isRegistrationSectionTwoVisible,
                        child: Wrap(
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
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('regions')
                                            .orderBy(FieldPath.documentId)
                                            .snapshots(),
                                        builder: (context, regionSnapshot) {
                                          if (regionSnapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          }

                                          if (regionSnapshot.hasError) {
                                            return Text(
                                                'Error: ${regionSnapshot.error}');
                                          }

                                          final regions = regionSnapshot
                                              .data!.docs.reversed
                                              .toList();
                                          List<DropdownMenuItem<String>>
                                              regionItems = [];

                                          if (residentSelection == 'Resident') {
                                            regionItems.add(
                                              const DropdownMenuItem(
                                                value: "0",
                                                child: Text('Region IV - A'),
                                              ),
                                            );
                                          } else {
                                            regionItems.add(
                                              const DropdownMenuItem(
                                                value: "0",
                                                child: Text('Select Region'),
                                              ),
                                            );

                                            for (var region in regions) {
                                              regionItems.add(
                                                DropdownMenuItem(
                                                  value: region['region_name']
                                                      .toString(),
                                                  child: Text(
                                                      region['region_name']
                                                          .toString()),
                                                ),
                                              );
                                            }
                                          }

                                          return Column(
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                margin: const EdgeInsets.only(
                                                    bottom: 10.0, top: 15.0),
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                                child: DropdownButton<String>(
                                                  items: regionItems,
                                                  onChanged: (regionValue) {
                                                    setState(() {
                                                      selectedRegion =
                                                          regionValue!;
                                                      selectedProvince =
                                                          "0"; // Reset selected province when changing the region.
                                                      selectedMunicipality =
                                                          "0"; // Reset selected municipality when changing the region.
                                                    });
                                                    print(regionValue);
                                                  },
                                                  value: selectedRegion,
                                                  isExpanded: true,
                                                ),
                                              ),
                                              StreamBuilder<QuerySnapshot>(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('regions')
                                                    .where("region_name",
                                                        isEqualTo:
                                                            selectedRegion)
                                                    .snapshots(),
                                                builder: (context,
                                                    provinceSnapshot) {
                                                  if (provinceSnapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const CircularProgressIndicator();
                                                  }

                                                  if (provinceSnapshot
                                                      .hasError) {
                                                    return Text(
                                                        'Error: ${provinceSnapshot.error}');
                                                  }

                                                  final provinces =
                                                      provinceSnapshot
                                                          .data!.docs.reversed
                                                          .toList();
                                                  List<DropdownMenuItem<String>>
                                                      provinceItems = [];

                                                  if (residentSelection ==
                                                      'Resident') {
                                                    provinceItems.add(
                                                      const DropdownMenuItem(
                                                        value: "0",
                                                        child: Text('Laguna'),
                                                      ),
                                                    );
                                                  } else {
                                                    provinceItems.add(
                                                      const DropdownMenuItem(
                                                        value: "0",
                                                        child: Text(
                                                            'Select Province'),
                                                      ),
                                                    );

                                                    for (var province
                                                        in provinces) {
                                                      // Assuming province['province_list'] is a map
                                                      Map<String, dynamic>
                                                          provinceList =
                                                          province[
                                                              'province_list'];
                                                      for (var provinceName in provinceList.keys) {
                                                        provinceItems.add(
                                                          DropdownMenuItem(
                                                            value: provinceName,
                                                            child: Text(
                                                                provinceName),
                                                          ),
                                                        );
                                                      }
                                                    }
                                                  }

                                                  return Container(
                                                    width: double.infinity,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.grey),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                    ),
                                                    child:
                                                        DropdownButton<String>(
                                                      items: provinceItems,
                                                      onChanged:
                                                          (provinceValue) {
                                                        setState(() {
                                                          selectedProvince =
                                                              provinceValue!;
                                                          selectedMunicipality =
                                                              "0"; // Reset selected municipality when changing the province.
                                                        });
                                                        print(provinceValue);
                                                      },
                                                      value: selectedProvince,
                                                      isExpanded: true,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, left: 8.0, right: 8.0),
                                  child: TextField(
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
                      ),
                    ),

                    // Next Button
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: Column(
                        children: [
                          Visibility(
                            visible: isRegistrationSectionTwoVisible,
                            child: Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: SizedBox(
                                width: 300,
                                child: GestureDetector(
                                  onTap: () {
                                    // Check if any of the text fields is empty
                                    if (residentSelection == 'Resident') {
                                      if (municipalityController.text.isEmpty ||
                                          barangayController.text.isEmpty ||
                                          streetController.text.isEmpty) {
                                        // If any field is empty, show a snackbar or toast message and return
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Please fill in all fields'),
                                            duration: Duration(seconds: 2),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                        return;
                                      }
                                    } else {
                                      if (selectedRegion == "0" ||
                                          selectedProvince == "0" ||
                                          municipalityController.text.isEmpty ||
                                          barangayController.text.isEmpty ||
                                          streetController.text.isEmpty) {
                                        // If any field is empty, show a snackbar or toast message and return
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Please fill in all fields'),
                                            duration: Duration(seconds: 2),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                        return;
                                      }
                                    }

                                    // Check the value of residentSelection and navigate accordingly
                                    if (residentSelection == "Resident") {
                                      // Navigate to RegisterScanFace
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              RegisterFaceScan(
                                            firstNameController:
                                                firstNameController,
                                            lastNameController:
                                                lastNameController,
                                            middleNameController:
                                                middleNameController,
                                            suffixNameController:
                                                suffixNameController,
                                            mobileNumberController:
                                                mobileNumberController,
                                            municipalityController:
                                                municipalityController,
                                            barangayController:
                                                barangayController,
                                            streetController: streetController,
                                            buttonText: buttonText,
                                            selectedRegion: selectedRegion,
                                            selectedProvince: selectedProvince,
                                            residentSelection:
                                                residentSelection,
                                          ),
                                        ),
                                      );
                                    } else if (residentSelection ==
                                        "Non-Resident") {
                                      // Navigate to RegisterMPIN
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RegisterMPIN(
                                            firstNameController:
                                                firstNameController,
                                            lastNameController:
                                                lastNameController,
                                            middleNameController:
                                                middleNameController,
                                            suffixNameController:
                                                suffixNameController,
                                            mobileNumberController:
                                                mobileNumberController,
                                            municipalityController:
                                                municipalityController,
                                            barangayController:
                                                barangayController,
                                            streetController: streetController,
                                            buttonText: buttonText,
                                            selectedRegion: selectedRegion,
                                            selectedProvince: selectedProvince,
                                            residentSelection:
                                                residentSelection,
                                            capturedFaceScan: null,
                                            capturedFaceScanLeft: null,
                                            capturedFaceScanRight: null,
                                            capturedIDScan: null,
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
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Check if any of the text fields is empty
                              if (firstNameController.text.isEmpty ||
                                  lastNameController.text.isEmpty ||
                                  buttonText == 'Select Birthdate') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please fill in all fields'),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Colors.red,
                                  ),
                                );

                                return;
                              }

                              // If all fields have values, toggle visibility
                              setState(() {
                                isRegistrationSectionOneVisible =
                                    !isRegistrationSectionOneVisible;
                                isRegistrationSectionTwoVisible =
                                    !isRegistrationSectionTwoVisible;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[900],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: Container(
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 15),
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  isRegistrationSectionOneVisible
                                      ? 'Next'
                                      : 'Previous',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
