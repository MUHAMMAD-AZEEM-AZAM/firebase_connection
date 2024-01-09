import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JoinedRequest extends StatefulWidget {
  final String eventId;

  JoinedRequest({required this.eventId});

  @override
  _JoinedRequestState createState() => _JoinedRequestState();
}

class _JoinedRequestState extends State<JoinedRequest> {
  late List<String> userIds;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    userIds = [];
    // Initialize real-time listeners
    initListeners();
  }

  // Initialize real-time listeners
  void initListeners() {
    FirebaseFirestore.instance
        .collection("eventJoined")
        .doc(widget.eventId)
        .snapshots()
        .listen((eventJoinedSnapshot) async {
      if (eventJoinedSnapshot.exists && eventJoinedSnapshot.data() != null) {
        List<String> allUserIds =
            List<String>.from(eventJoinedSnapshot["userID"]);

        DocumentSnapshot eventSnapshot = await FirebaseFirestore.instance
            .collection("event")
            .doc(widget.eventId)
            .get();
        String? eventCreatorUserId = eventSnapshot["userID"];

        userIds =
            allUserIds.where((userId) => userId != eventCreatorUserId).toList();
      }

      setState(() {
        isLoading = false;
      });
    });

    // Add listener for the "confirmed_participants" collection
    FirebaseFirestore.instance
        .collection("confirmed_participants")
        .doc(widget.eventId)
        .snapshots()
        .listen((documentSnapshot) {
      // Handle changes to the confirmed_participants collection if needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Details",style: TextStyle(color: Colors.white),),
      ),
      body: isLoading
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
                        // if (snapshot.connectionState ==
                        //     ConnectionState.waiting) {
                        //   return ListTile(
                        //     title: Text("Loading..."),
                        //     trailing: CircularProgressIndicator(),
                        //   );
                        // }

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
                            String location = userData["location"] ?? "N/A";

                            return Card(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        "${userName.toUpperCase()}",
                                        style: TextStyle(
                                          color: Colors.amberAccent[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text("Phone Number: $userPhoneNumber"),
                                      Text("Location: $location"),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              String? newUserId =
                                                  userIds[index];
                                              if (newUserId != null) {
                                                await FirebaseFirestore.instance
                                                    .collection("eventJoined")
                                                    .doc(widget.eventId)
                                                    .update({
                                                  "userID":
                                                      FieldValue.arrayRemove(
                                                          [newUserId])
                                                });

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'Request Rejected'),
                                                    duration:
                                                        Duration(seconds: 2),
                                                  ),
                                                );
                                              }
                                            },
                                            child: Text('Reject'),
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                Colors.white,
                                              ),
                                              foregroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                Colors.black54,
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              String? newUserId =
                                                  userIds[index];

                                              if (newUserId != null) {
                                                DocumentSnapshot
                                                    documentSnapshot =
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            "confirmed_participants")
                                                        .doc(widget.eventId)
                                                        .get();

                                                if (documentSnapshot.exists) {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection(
                                                          "confirmed_participants")
                                                      .doc(widget.eventId)
                                                      .update({
                                                    "userID":
                                                        FieldValue.arrayUnion(
                                                            [newUserId])
                                                  });
                                                } else {
                                                  await FirebaseFirestore
                                                      .instance
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
                                                  "userID":
                                                      FieldValue.arrayRemove(
                                                          [newUserId])
                                                });

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Request Accepted'),
                                                    duration:
                                                        Duration(seconds: 2),
                                                  ),
                                                );
                                              }
                                            },
                                            child: Text('Accept'),
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                Colors.blue,
                                              ),
                                              foregroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(
                                                Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        }
                        return SizedBox();
                      },
                    );
                  },
                ),
    );
  }
}
