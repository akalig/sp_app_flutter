import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'authentication/authentication.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    _prefs = await SharedPreferences.getInstance();
    bool isFirstTime = _prefs.getBool('isFirstTime') ?? true;
    if (isFirstTime) {
      // Mark that the intro has been shown
      await _prefs.setBool('isFirstTime', false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Authentication()),
      );
    }
  }

  void showPrivacyPolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("PRIVACY POLICY"),
          content: const SingleChildScrollView(
            child: Column(
              children: [
                Text('PRIVACY POLICY', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  'We recognize the importance of data privacy and are committed to protecting the user’s personal data. In line with this, we ensure that we comply with the Data Privacy Act of 2012 (RA 10173), along with its Implementing Rules and Regulations as well as any other relevant data privacy-related laws and issuances by the National Privacy Commission. Furthermore, we only collect and process information that is necessary to fulfill the purpose of our platform. This Privacy Policy explains what information we collect, process, and share. It also informs the user why we do so, and their data privacy rights regarding their information.',
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 10),
                Text(
                  'We may update this Privacy Policy to reflect needed changes in our policy to comply with the law. In such cases, we encourage the user to check for updates on our Privacy Policy, if notified. This is available on our website or app for further information and reference.',
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 20),
                Text('WHAT DATA DO WE COLLECT', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  'The information we collect from the User may either be Personal Information (PI) and/or Sensitive Personal Information (SPI), as defined in the Data Privacy Act of 2012:',
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 10),
                Text(
                  'Personal Information (PI) is any information from which the identity of an individual can be reasonably and directly ascertained, or when put together with other information would directly and certainly identify an individual, such as name, date and place of birth, specimen signature or biometrics (fingerprint, face recognition, palm print, etc.), photo, present and permanent address, source of fund or income, name of employer or the nature or self-employment or business, contact details such as personal telephone number, personal mobile number and personal email address, mother’s maiden name, cookie information, user credentials (i.e. username and password, PIN/MPIN, etc.), contacts list, geolocation, and information about the device they use to interact with us.',
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 10),
                Text(
                  'Sensitive Personal Information (SPI) is any information that falls under the category of personal information with higher security impact as described in applicable privacy law. This information includes but is not limited to marital status, cardholder data (CVV/CVC, Expiry Date), tax returns, government-issued numbers peculiar to an individual (ex. SSS, GSIS, UMID, etc.) information on IDs issued by private companies that are duly registered with the Securities and Exchange Commission, and student IDs for those who are not yet of voting age (below 18 years old). ',
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 20),
                Text(
                  'The information we collect from our subscribers for the various functions of the platform is as follows:',
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 10),
                Text(
                  'Registration',
                  textAlign: TextAlign.justify,
                ),
                Text(
                  'Mobile Number - In order to register an account, users will only have to provide their mobile number. However, in order to access the full features of the application, users must update their profile and provide additional information.',
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'KYC for Users',
                    ),
                    Text(
                      'Level 1:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Full Name',
                    ),
                    Text(
                      'Date of Birth',
                    ),
                    Text(
                      'Address',
                    ),
                    Text(
                      'Level 2:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Face Scan',
                    ),
                    Text(
                      'Government Issued ID',
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'In addition to the information provided above, there are certain features within the application that require users to share additional relevant information. When utilizing these features, users may be prompted to provide supplementary details directly associated with the particular feature they wish to access. These features are designed to enhance the functionality and effectiveness of the app by gathering specific details related to their respective functionalities. By updating their account, users can have full access to the application.',
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 20),
                Text('HOW YOUR PERSONAL DATA IS COLLECTED', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      textAlign: TextAlign.justify,
                      'We collect the user’s Personal Data when they:',
                    ),
                    SizedBox(height: 10),
                    Text(
                      textAlign: TextAlign.justify,
                      'register in the App;',
                    ),
                    SizedBox(height: 10),
                    Text(
                      textAlign: TextAlign.justify,
                      'provide us with supporting documents to validate their identity;',
                    ),
                    SizedBox(height: 10),
                    Text(
                      textAlign: TextAlign.justify,
                      'disclose their information through phone calls, emails, SMS, or verbal communication with our authorized representatives; and visit and contact us through our official contact and/or address.',
                    ),
                    SizedBox(height: 10),
                    Text(
                      textAlign: TextAlign.justify,
                      'No information from users will be collected until they have given their express consent. During the initial registration process, clicking the checkbox will signify that the user has read and agrees to the Terms and Conditions and Privacy Policy of the application.',
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text('HOW WE USE YOUR PERSONAL DATA', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text(
                  textAlign: TextAlign.justify,
                  'We will only use the user’s Personal Data when needed for the various features of the Application. We may not process or use their information without their express consent.',
                ),
                SizedBox(height: 10),
                Text(
                  textAlign: TextAlign.justify,
                  'Data will be used for the purpose of registering an account within the application and updating their profile accordingly for the KYC procedure. Doing this grants them full access to the various features of Application.',
                ),
                SizedBox(height: 10),
                Text(
                  textAlign: TextAlign.justify,
                  'Upon collection of the required information, the user may generate their Digital ID, a unique QR code - which will serve as their personal digital ID, through application.',
                ),
                SizedBox(height: 10),
                Text(
                  textAlign: TextAlign.justify,
                  'When required by our Privacy Policy and the law and before we use or process the user’s Personal Data for any other purpose, we will ask for their consent.',
                ),
                SizedBox(height: 20),
                Text('WHO WE SHARE YOUR DATA WITH', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text(
                  textAlign: TextAlign.justify,
                  'The personal data the user provides will only be shared with the City Government of San Pedro within the San Pedro App. No information will be shared or disclosed to any other third parties or advertisers. All information shall be kept by and held with the utmost confidentiality.',
                ),
                SizedBox(height: 20),
                Text('YOUR RIGHTS AS A DATA SUBJECT', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      textAlign: TextAlign.justify,
                      'As a subscriber of the application, the users are entitled to the following data privacy rights:',
                    ),
                    SizedBox(height: 10),
                    Text(
                      textAlign: TextAlign.justify,
                      'To be informed whether their Personal Information shall be, is being, or has been processed;',
                    ),
                    SizedBox(height: 10),
                    Text(
                      textAlign: TextAlign.justify,
                      'To reasonably access any Personal Information collected and processed in the duration of usage of the application;',
                    ),
                    SizedBox(height: 10),
                    Text(
                      textAlign: TextAlign.justify,
                      'To object or withhold consent with regard to the collection and processing of their Personal Data;',
                    ),
                    SizedBox(height: 10),
                    Text(
                      textAlign: TextAlign.justify,
                      'To suspend, withdraw, or order the blocking, removal, or destruction of Personal Data from the relevant company’s filing system;',
                    ),
                    SizedBox(height: 10),
                    Text(
                      textAlign: TextAlign.justify,
                      'To dispute the inaccuracy or error in Personal Data, and the relevant company shall correct it immediately and accordingly, upon the request unless the request is vexatious or otherwise unreasonable;',
                    ),
                    SizedBox(height: 10),
                    Text(
                      textAlign: TextAlign.justify,
                      'To obtain a copy of the data in an electronic or structured format that is commonly used and allows for further use by the Data Subject;',
                    ),
                    SizedBox(height: 10),
                    Text(
                      textAlign: TextAlign.justify,
                      'To be indemnified for any damages sustained pursuant to the provisions of the Data Privacy Act or Other Privacy Laws.',
                    ),
                    SizedBox(height: 10),
                    Text(
                      textAlign: TextAlign.justify,
                      'If the user wishes to exercise any of the rights set out above or require further information, they may contact us.',
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text('CONTACT US', textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text(
                  textAlign: TextAlign.justify,
                  'If you have any questions pertaining to San Pedro App or any of the privacy policy contained herein, please get in touch with the App Owner at New City Hall Bldg., Brgy. Poblacion, City of San Pedro, Laguna, or contact us at .',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Background image
            Image.asset(
              'lib/images/phil_arena.png',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            // White layer with opacity
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white.withOpacity(0.8),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 100),
                  child: Image.asset('lib/images/sp-logo.png'),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 200),
                  child: const Text(
                    'San Pedro Laguna Smart City Application',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: SizedBox(
                    width: 300,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const Authentication()),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue[500],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.all(18),
                        child: const Center(
                          child: Text(
                            'GET STARTED',
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
                GestureDetector(
                  onTap: () {
                    showPrivacyPolicyDialog(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      'Privacy Policy',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
