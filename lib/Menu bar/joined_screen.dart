import 'package:firebase_connection/myGlobals.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JoinedScreen extends StatefulWidget {
  @override
  _JoinedScreenState createState() => _JoinedScreenState();
}

class _JoinedScreenState extends State<JoinedScreen> {
  final String? userId = userID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Events for User',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card for "Events You Requested"
            Card(
              elevation: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 230, 246, 255),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Events You Requested',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('eventJoined')
                            .where('userID', arrayContains: userId)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          }

                          var events = snapshot.data!.docs;

                          return Container(
                            height:
                                265, // Set a fixed height or adjust accordingly
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: events.length,
                              itemBuilder: (context, index) {
                                var event = events[index];
                                var eventId = event.id;

                                return FutureBuilder(
                                  future: FirebaseFirestore.instance
                                      .collection('event')
                                      .doc(eventId)
                                      .get(),
                                  builder: (context, eventSnapshot) {
                                    if (!eventSnapshot.hasData) {
                                      return Container();
                                    }

                                    var eventData = eventSnapshot.data!.data();
                                    var eventTitle = eventData!['title'];

                                    return Card(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        child: ListTile(
                                          title: Text(eventTitle),
                                          // Add other details if needed
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Card for "Confirmed Events"
            Card(
              elevation: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 230, 246, 255),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Confirmed Events',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('confirmed_participants')
                            .where('userID', arrayContains: userId)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          }

                          var events = snapshot.data!.docs;

                          return Container(
                            height:
                                240, // Set a fixed height or adjust accordingly
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: events.length,
                              itemBuilder: (context, index) {
                                var event = events[index];
                                var eventId = event.id;

                                return FutureBuilder(
                                  future: FirebaseFirestore.instance
                                      .collection('event')
                                      .doc(eventId)
                                      .get(),
                                  builder: (context, eventSnapshot) {
                                    if (!eventSnapshot.hasData) {
                                      return Container();
                                    }

                                    var eventData = eventSnapshot.data!.data();
                                    var eventTitle = eventData!['title'];

                                    return Card(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        child: ListTile(
                                          title: Text(eventTitle),
                                          // Add other details if needed
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
