import 'package:firebase_messaging/firebase_messaging.dart';

class FirebasePushNotificationAPI {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<String?> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();

    String token = fCMToken.toString();
    print('Token: $token');

    return token;
  }
}