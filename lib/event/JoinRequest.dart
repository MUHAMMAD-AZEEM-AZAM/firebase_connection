import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Import necessary packages and files

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
    userIds = [];
    fetchEventJoinedDocument();
  }

  Future<void> fetchEventJoinedDocument() async {
    try {
      DocumentSnapshot eventJoinedSnapshot = await FirebaseFirestore.instance
          .collection("eventJoined")
          .doc(widget.eventId)
          .get();

      if (eventJoinedSnapshot.exists && eventJoinedSnapshot.data() != null) {
        List<String> allUserIds =
            List<String>.from(eventJoinedSnapshot["userID"]);

        DocumentSnapshot eventSnapshot = await FirebaseFirestore.instance
            .collection("event")
            .doc(widget.eventId)
            .get();
        String? eventCreatorUserId = eventSnapshot["userID"];

        userIds = allUserIds
            .where((userId) => userId != eventCreatorUserId)
            .toList();
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
      body: userIds.isEmpty
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
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ListTile(
                        title: Text("Loading..."),
                        trailing: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return ListTile(
                        title: Text("Error: ${snapshot.error}"),
                      );
                    }

                    if (snapshot.hasData) {
                      Map<String, dynamic>? userData =
                          snapshot.data?.data() as Map<String, dynamic>?;

                      if (userData != null &&
                          userData.containsKey("name") &&
                          userData.containsKey("phoneNumber")) {
                        String userName = userData["name"] ?? "N/A";
                        String userPhoneNumber =
                            userData["phoneNumber"] ?? "N/A";

                        return Card(
                          child: Column(
                            children: [
                              Text("Name: $userName"),
                              Text("Phone Number: $userPhoneNumber"),
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      // Add your reject logic here
                                    },
                                    child: Text('Reject'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      String? newUserId = userIds[index];

                                      if (newUserId != null) {
                                        DocumentSnapshot documentSnapshot =
                                            await FirebaseFirestore.instance
                                                .collection(
                                                    "confirmed_participants")
                                                .doc(widget.eventId)
                                                .get();

                                        if (documentSnapshot.exists) {
                                          await FirebaseFirestore.instance
                                              .collection(
                                                  "confirmed_participants")
                                              .doc(widget.eventId)
                                              .update({
                                            "userID": FieldValue.arrayUnion(
                                                [newUserId])
                                          });
                                        } else {
                                          await FirebaseFirestore.instance
                                              .collection(
                                                  "confirmed_participants")
                                              .doc(widget.eventId)
                                              .set({
                                            "userID": [newUserId]
                                          });
                                        }

                                        await FirebaseFirestore.instance
                                            .collection("eventJoined")
                                            .doc(widget.eventId)
                                            .update({
                                          "userID": FieldValue.arrayRemove(
                                              [newUserId])
                                        });
                                      }
                                    },
                                    child: Text('Accept'),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        Colors.blue,
                                      ),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                    }

                    return ListTile(
                      title: Center(child: Text("No user Joined the Event")),
                    );
                  },
                );
              },
            ),
    );
  }
}
