import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JoinedRequest extends StatefulWidget {
  final String eventId;

  JoinedRequest({required this.eventId});

  @override
  _JoinedRequestState createState() => _JoinedRequestState();
}

class _JoinedRequestState extends State<JoinedRequest> {
  late List<String> userIds;

  @override
  void initState() {
    super.initState();
    // Initialize userIds as an empty list
    userIds = [];
    // Fetch the document from "eventJoined" using the provided eventId
    fetchEventJoinedDocument();
  }

  Future<void> fetchEventJoinedDocument() async {
    try {
      // Retrieve the document from "eventJoined" collection
      DocumentSnapshot eventJoinedSnapshot = await FirebaseFirestore.instance
          .collection("eventJoined")
          .doc(widget.eventId)
          .get();

      // Check if the "userID" field exists in the DocumentSnapshot
      if (eventJoinedSnapshot.exists && eventJoinedSnapshot.data() != null) {
        // Extract the user IDs from the "userID" array field
        List<String> allUserIds =
            List<String>.from(eventJoinedSnapshot["userID"]);

        // Get the user ID of the event creator
        DocumentSnapshot eventSnapshot = await FirebaseFirestore.instance
            .collection("event")
            .doc(widget.eventId)
            .get();
        String? eventCreatorUserId = eventSnapshot["userID"];

        // Exclude the event creator's user ID from the list
        userIds = eventCreatorUserId != null
            ? allUserIds
                .where((userId) => userId != eventCreatorUserId)
                .toList()
            : allUserIds;
      } else {
        // Handle the case where the "userID" field is not present
        print("Error: 'userID' field not found in the DocumentSnapshot");
      }

      setState(() {});
    } catch (e) {
      print("Error fetching eventJoined document: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Details"),
      ),
      body: userIds == null
          ? Center(child: CircularProgressIndicator())
          : userIds.isEmpty
              ? Center(child: Text("No users joined the event"))
              : ListView.builder(
                  itemCount: userIds.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection("profile")
                          .doc(userIds[index])
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else if(snapshot.hasData){
                          // Explicitly cast userData to Map<String, dynamic>
                          Map<String, dynamic> userData =
                              snapshot.data!.data() as Map<String, dynamic>;

                          // Extract user information from profiles collection
                          String userName = userData["name"] ?? "N/A";
                          String userPhoneNumber =
                              userData["phoneNumber"] ?? "N/A";

                          return Card(
                            child: ListTile(
                              title: Text("Name: $userName"),
                              subtitle: Text("Phone Number: $userPhoneNumber"),
                              // Additional information can be displayed here
                            ),
                          );
                        }
                        else {
                          return Text("User not found");
                        } 
                      },
                    );
                  },
                ),
    );
  }
}
