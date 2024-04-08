import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Notifications extends StatefulWidget {
  final String userId;

  const Notifications({
    super.key,
    required this.userId,
  });

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  late Stream<QuerySnapshot> _notificationsStream;

  late String userId;

  @override
  void initState() {
    userId = widget.userId;

    _notificationsStream = FirebaseFirestore.instance
        .collection('notifications')
        .where('userID', isEqualTo: userId)
        .snapshots();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      child: Column(
        children: [
          Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green[900],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Text(
                        'Notifications',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _notificationsStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                var notifications = snapshot.data!.docs;

                if (notifications.isEmpty) {
                  return const Center(child: Text('No notifications available.'));
                }

                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      var notification = notifications[index];
                      var body = notification['body'];
                      var timestamp = notification['timestamp'];

                      // Format the timestamp into a readable string
                      var formattedTimestamp = DateFormat.yMMMd().add_jm().format(timestamp.toDate());

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 1.0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green),
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              body,
                              style: const TextStyle(
                                fontSize: 10.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              formattedTimestamp, // Display the formatted timestamp
                              style: const TextStyle(
                                fontSize: 10.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            // You can add more details or customization here
                          ],
                        ),
                      );
                    },
                  ),
                );

              },
            ),
          ),
        ],
      ),
    );
  }
}
