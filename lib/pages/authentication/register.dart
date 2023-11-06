import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sp_app/json/location_data.dart';

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

  // String selectedRegion = "0";
  // String selectedProvince = "0";
  // String selectedMunicipality = "0";
  // String selectedBarangay = "0";

  String selectedRegion = '';
  String selectedProvince = '';
  String selectedMunicipality = '';
  String selectedBarangay = '';

  List<String> regions = [];
  List<String> provinces = [];
  List<String> municipalities = [];
  List<String> barangays = [];

  @override
  void initState() {
    super.initState();
    regions = jsonData.keys.toList();
  }

  void updateProvinces(String region) {
    provinces = jsonData['region_name'][region].keys.toList();
    selectedProvince = '';
    selectedMunicipality = '';
    selectedBarangay = '';
    municipalities = [];
    barangays = [];
  }

  void updateMunicipalities(String province) {
    municipalities = jsonData[selectedRegion]['province_list'][province]['municipality_list'].keys.toList();
    selectedMunicipality = '';
    selectedBarangay = '';
    barangays = [];
  }

  void updateBarangays(String municipality) {
    barangays = jsonData[selectedRegion]['province_list'][selectedProvince]['municipality_list'][municipality]['barangay_list'];
    selectedBarangay = '';
  }

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
                                      DropdownButtonFormField<String>(
                                        value: selectedRegion,
                                        onChanged: (region) {
                                          setState(() {
                                            selectedRegion = region!;
                                            updateProvinces(region);
                                          });
                                        },
                                        items: regions.map((region) {
                                          return DropdownMenuItem(
                                            value: region,
                                            child: Text(region),
                                          );
                                        }).toList(),
                                        hint: const Text('Select Region'),
                                      ),
                                      DropdownButtonFormField<String>(
                                        value: selectedProvince,
                                        onChanged: (province) {
                                          setState(() {
                                            selectedProvince = province!;
                                            updateMunicipalities(province);
                                          });
                                        },
                                        items: provinces.map((province) {
                                          return DropdownMenuItem(
                                            value: province,
                                            child: Text(province),
                                          );
                                        }).toList(),
                                        hint: const Text('Select Province'),
                                      ),
                                      DropdownButtonFormField<String>(
                                        value: selectedMunicipality,
                                        onChanged: (municipality) {
                                          setState(() {
                                            selectedMunicipality = municipality!;
                                            updateBarangays(municipality);
                                          });
                                        },
                                        items: municipalities.map((municipality) {
                                          return DropdownMenuItem(
                                            value: municipality,
                                            child: Text(municipality),
                                          );
                                        }).toList(),
                                        hint: const Text('Select Municipality'),
                                      ),
                                      DropdownButtonFormField<String>(
                                        value: selectedBarangay,
                                        onChanged: (barangay) {
                                          setState(() {
                                            selectedBarangay = barangay!;
                                          });
                                        },
                                        items: barangays.map((barangay) {
                                          return DropdownMenuItem(
                                            value: barangay,
                                            child: Text(barangay),
                                          );
                                        }).toList(),
                                        hint: const Text('Select Barangay'),
                                      ),
                                    ],
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
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: ElevatedButton(
                                onPressed: null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green[900],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 15, bottom: 15),
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
