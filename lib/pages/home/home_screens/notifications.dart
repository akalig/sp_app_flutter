import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Notifications extends StatefulWidget {
  final String userId;

  const Notifications({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  late Stream<QuerySnapshot> _notificationsStream;
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    _startDate = _endDate = DateTime.now();
    _fetchNotifications();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.initState();
  }

  void _fetchNotifications() {
    _notificationsStream = FirebaseFirestore.instance
        .collection('notifications')
        .where('userID', isEqualTo: widget.userId)
        .where('timestamp', isGreaterThanOrEqualTo: _startDate)
        .where('timestamp', isLessThanOrEqualTo: _endDate)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
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
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 2.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _startDate,
                        firstDate: DateTime(2015, 8),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != _startDate)
                        setState(() {
                          _startDate = picked;
                          _fetchNotifications();
                        });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: Text('Start Date: ${DateFormat.yMMMd().format(_startDate)}', style: const TextStyle(color: Colors.black),),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _endDate,
                        firstDate: DateTime(2015, 8),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != _endDate)
                        setState(() {
                          _endDate = picked;
                          _fetchNotifications();
                        });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: Text('End Date: ${DateFormat.yMMMd().format(_endDate)}', style: const TextStyle(color: Colors.black),),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              // Fetch the user's creation date from Firestore
              DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.userId)
                  .get();

              // Get the 'created_at' field from the user document
              Timestamp userCreationTimestamp = userSnapshot['created_at'];
              DateTime userCreationDate = userCreationTimestamp.toDate();

              setState(() {
                _startDate = userCreationDate; // Set _startDate to user's creation date
                _endDate = DateTime.now(); // Set _endDate to current date
                _fetchNotifications();
              });
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              minimumSize: const Size(double.infinity, 0),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('See All', style: TextStyle(color: Colors.black),),
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
                  padding: const EdgeInsets.all(0.0),
                  child: ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      var notification = notifications[index];
                      var body = notification['body'];
                      var timestamp = notification['timestamp'];

                      // Format the timestamp into a readable string
                      var formattedTimestamp =
                      DateFormat.yMMMd().add_jm().format(timestamp.toDate());

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    // Determine the title based on the body content
                                    body.contains('Account') || body.contains('account')
                                        ? 'Account Status Update'
                                        : body.contains('Emergency') || body.contains('emergency')
                                        ? 'Emergency Status Update'
                                        : 'Notification',
                                    style: const TextStyle(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  Text(
                                    body,
                                    style: const TextStyle(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),

                                  const SizedBox(height: 10),
                                ],
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
