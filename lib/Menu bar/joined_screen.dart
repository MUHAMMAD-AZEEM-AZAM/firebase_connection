import 'package:firebase_connection/myGlobals.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JoinedScreen extends StatefulWidget {
  @override
  _JoinedScreenState createState() => _JoinedScreenState();
}

class _JoinedScreenState extends State<JoinedScreen> {
  final String? userId = userID;
  bool isLoading = true; // Track initial loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Events for User',style: TextStyle(color: Colors.white),),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('eventJoined')
            .where('userID', arrayContains: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // Show a single small CircularProgressIndicator only for the initial loading state
            if (isLoading) {
              isLoading = false; // Set isLoading to false after the first CircularProgressIndicator
              return Center(
                child: SizedBox(
                  height: 20.0,
                  width: 20.0,
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return Container(); // Return an empty container for subsequent loading states
            }
          }

          // Extract the list of events
          var events = snapshot.data!.docs;

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              var event = events[index];
              var eventId = event.id;

              // Use the event ID to fetch details from the 'event' collection
              return FutureBuilder(
                future: FirebaseFirestore.instance.collection('event').doc(eventId).get(),
                builder: (context, eventSnapshot) {
                  if (!eventSnapshot.hasData) {
                    // Return an empty container for loading states during event details retrieval
                    return Container();
                  }

                  var eventData = eventSnapshot.data!.data();
                  var eventTitle = eventData!['title'];
                  var eventUserId = eventData['userID'];

                  // Check if the event's userID does not match the userID in the 'eventJoined' collection
                  if (eventUserId != userId) {
                    // Display a card with the event title
                    return Card(
                      child: ListTile(
                        title: Text(eventTitle),
                        // Add other details if needed
                      ),
                    );
                  } else {
                    // Return an empty container if the event should be ignored
                    return Container();
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
