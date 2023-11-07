import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sp_app/json/location_data.dart';

import 'face_scan.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

List<String> categoryOptions = ['Resident', 'Visitor'];

class _RegisterState extends State<Register> {
  DateTime date = DateTime.now();
  bool isRegistrationSectionOneVisible = true;
  bool isRegistrationSectionTwoVisible = false;
  bool isNextButtonClicked = false;

  String buttonText = 'Select Birthdate';

  String currentOption = categoryOptions[0];

  String selectedRegion = "0";
  String selectedProvince = "0";
  String selectedMunicipality = "0";
  String selectedBarangay = "0";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    Navigator.pop(context);
                  },
                  child: const Text(
                    '< Back to Homepage',
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
                              fontSize: 20, // Increase font size
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(
                                top: 25.0, left: 8.0, right: 8.0),
                            child: TextField(
                              style: TextStyle(color: Colors.black),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
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
                          const Padding(
                            padding: EdgeInsets.only(
                                top: 25.0, left: 8.0, right: 8.0),
                            child: TextField(
                              style: TextStyle(color: Colors.black),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
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
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 25.0, left: 8.0, right: 4.0),
                                  child: TextField(
                                    style: TextStyle(color: Colors.black),
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
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
                                  padding: EdgeInsets.only(
                                      top: 25.0, left: 4.0, right: 8.0),
                                  child: TextField(
                                    style: TextStyle(color: Colors.black),
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
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
                                      '${date.year}/${date.month}/${date.day}';
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

                          const Padding(
                            padding: EdgeInsets.only(
                                top: 25.0, left: 8.0, right: 8.0),
                            child: TextField(
                              maxLength: 11,
                              style: TextStyle(color: Colors.black),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
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
                                    fontSize: 20, // Increase font size
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 25.0, left: 8.0, right: 8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Choose Category",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Column(
                                        children: [
                                          ListTile(
                                            title: const Text('Resident'),
                                            contentPadding: EdgeInsets.zero,
                                            // Set contentPadding to control horizontal alignment
                                            leading: Radio(
                                              value: categoryOptions[0],
                                              groupValue: currentOption,
                                              onChanged: (value) {
                                                setState(() {
                                                  currentOption = value.toString();
                                                });
                                              },
                                            ),
                                          ),
                                          ListTile(
                                            title: const Text('Visitor'),
                                            contentPadding: EdgeInsets.zero,
                                            // Set contentPadding to control horizontal alignment
                                            leading: Radio(
                                              value: categoryOptions[1],
                                              groupValue: currentOption,
                                              onChanged: (value) {
                                                setState(() {
                                                  currentOption = value.toString();
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 25.0, left: 8.0, right: 8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('regions')
                                            .orderBy(FieldPath.documentId)
                                            .snapshots(),
                                        builder: (context, regionSnapshot) {
                                          if (regionSnapshot.connectionState == ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          }

                                          if (regionSnapshot.hasError) {
                                            return Text('Error: ${regionSnapshot.error}');
                                          }

                                          final regions = regionSnapshot.data!.docs.reversed.toList();
                                          List<DropdownMenuItem<String>> regionItems = [];
                                          regionItems.add(
                                            const DropdownMenuItem(
                                              value: "0",
                                              child: Text('Select Region'),
                                            ),
                                          );

                                          for (var region in regions) {
                                            regionItems.add(
                                              DropdownMenuItem(
                                                value: region['region_name'].toString(),
                                                child: Text(region['region_name'].toString()),
                                              ),
                                            );
                                          }

                                          return Column(
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                margin: const EdgeInsets.all(10.0),
                                                padding: const EdgeInsets.all(10.0),
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.grey),
                                                  borderRadius: BorderRadius.circular(5.0),
                                                ),
                                                child: DropdownButton<String>(
                                                  items: regionItems,
                                                  onChanged: (regionValue) {
                                                    setState(() {
                                                      selectedRegion = regionValue!;
                                                      selectedProvince = "0"; // Reset selected province when changing the region.
                                                      selectedMunicipality = "0"; // Reset selected municipality when changing the region.
                                                    });
                                                    print(regionValue);
                                                  },
                                                  value: selectedRegion,
                                                  isExpanded: true,
                                                ),
                                              ),
                                              StreamBuilder<QuerySnapshot>(
                                                stream: FirebaseFirestore.instance
                                                    .collection('regions')
                                                    .where("region_name", isEqualTo: selectedRegion)
                                                    .snapshots(),
                                                builder: (context, provinceSnapshot) {
                                                  if (provinceSnapshot.connectionState == ConnectionState.waiting) {
                                                    return const CircularProgressIndicator();
                                                  }

                                                  if (provinceSnapshot.hasError) {
                                                    return Text('Error: ${provinceSnapshot.error}');
                                                  }

                                                  final provinces = provinceSnapshot.data!.docs.reversed.toList();
                                                  List<DropdownMenuItem<String>> provinceItems = [];
                                                  provinceItems.add(
                                                    const DropdownMenuItem(
                                                      value: "0",
                                                      child: Text('Select Province'),
                                                    ),
                                                  );

                                                  for (var province in provinces) {
                                                    // Assuming province['province_list'] is a map
                                                    Map<String, dynamic> provinceList = province['province_list'];
                                                    provinceList.keys.forEach((provinceName) {
                                                      provinceItems.add(
                                                        DropdownMenuItem(
                                                          value: provinceName,
                                                          child: Text(provinceName),
                                                        ),
                                                      );
                                                    });
                                                  }

                                                  return Container(
                                                    width: double.infinity,
                                                    margin: const EdgeInsets.all(10.0),
                                                    padding: const EdgeInsets.all(10.0),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(color: Colors.grey),
                                                      borderRadius: BorderRadius.circular(5.0),
                                                    ),
                                                    child: DropdownButton<String>(
                                                      items: provinceItems,
                                                      onChanged: (provinceValue) {
                                                        setState(() {
                                                          selectedProvince = provinceValue!;
                                                          selectedMunicipality = "0"; // Reset selected municipality when changing the province.
                                                        });
                                                        print(provinceValue);
                                                      },
                                                      value: selectedProvince,
                                                      isExpanded: true,
                                                    ),
                                                  );
                                                },
                                              ),

                                              // StreamBuilder<QuerySnapshot>(
                                              //   stream: FirebaseFirestore.instance
                                              //       .collection('regions')
                                              //       .where("region_name", isEqualTo: selectedRegion)
                                              //       .snapshots(),
                                              //   builder: (context, municipalitySnapshot) {
                                              //     if (municipalitySnapshot.connectionState == ConnectionState.waiting) {
                                              //       return const CircularProgressIndicator();
                                              //     }
                                              //
                                              //     if (municipalitySnapshot.hasError) {
                                              //       return Text('Error: ${municipalitySnapshot.error}');
                                              //     }
                                              //
                                              //     final municipalities = municipalitySnapshot.data!.docs.reversed.toList();
                                              //     List<DropdownMenuItem<String>> municipalityItems = [];
                                              //     municipalityItems.add(
                                              //       const DropdownMenuItem(
                                              //         value: "0",
                                              //         child: Text('Select Municipality'),
                                              //       ),
                                              //     );
                                              //
                                              //     for (var municipality in municipalities) {
                                              //       // Assuming province['province_list'] is a map
                                              //       Map<String, dynamic> municipalityList = municipality['province_list'][selectedProvince]['municipality_list'];
                                              //
                                              //       municipalityList.keys.forEach((municipalityName) {
                                              //         municipalityItems.add(
                                              //           DropdownMenuItem(
                                              //             value: municipalityName,
                                              //             child: Text(municipalityName),
                                              //           ),
                                              //         );
                                              //       });
                                              //     }
                                              //
                                              //     return Container(
                                              //       width: double.infinity,
                                              //       margin: const EdgeInsets.all(10.0),
                                              //       padding: const EdgeInsets.all(10.0),
                                              //       decoration: BoxDecoration(
                                              //         border: Border.all(color: Colors.grey),
                                              //         borderRadius: BorderRadius.circular(5.0),
                                              //       ),
                                              //       child: DropdownButton<String>(
                                              //         items: municipalityItems,
                                              //         onChanged: (municipalityValue) {
                                              //           setState(() {
                                              //             selectedMunicipality = municipalityValue!;
                                              //             selectedBarangay = "0"; // Reset selected municipality when changing the province.
                                              //           });
                                              //           print(municipalityValue);
                                              //         },
                                              //         value: selectedProvince,
                                              //         isExpanded: true,
                                              //       ),
                                              //     );
                                              //   },
                                              // ),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),

                                const Padding(
                                  padding: EdgeInsets.only(
                                      top: 10.0, left: 8.0, right: 8.0),
                                  child: TextField(
                                    style: TextStyle(color: Colors.black),
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                      border: OutlineInputBorder(),
                                      hintText:
                                      "Municipality",
                                      hintStyle: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),

                                const Padding(
                                  padding: EdgeInsets.only(
                                      top: 10.0, left: 8.0, right: 8.0),
                                  child: TextField(
                                    style: TextStyle(color: Colors.black),
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                      border: OutlineInputBorder(),
                                      hintText:
                                      "Barangay",
                                      hintStyle: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),

                                const Padding(
                                  padding: EdgeInsets.only(
                                      top: 10.0, left: 8.0, right: 8.0),
                                  child: TextField(
                                    style: TextStyle(color: Colors.black),
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
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
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const FaceScan()),
                                  ),
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
                              child: const Center(
                                child: Text(
                                  'Next',
                                  style: TextStyle(
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
