import 'package:firebase_connection/myGlobals.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventDetail extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

  // Constructor to receive the DocumentSnapshot object
  EventDetail({required this.documentSnapshot});

  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  bool joined = false;

  @override
  void initState() {
    super.initState();
    checkIfUserJoined();
  }

  // Check if the user has already joined the event
  Future<void> checkIfUserJoined() async {
    String? newUserId = await getUserId();

    if (newUserId != null) {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("eventJoined")
          .doc(widget.documentSnapshot.id);

      DocumentSnapshot documentSnapshot = await documentReference.get();

      List<dynamic>? userIds = (documentSnapshot.data()
          as Map<String, dynamic>?)?["userID"] as List<dynamic>?;

      if (userIds != null && userIds.contains(newUserId)) {
        setState(() {
          joined = true;
        });
      }
    }
  }

  // Get userId from SharedPreferences
  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid');
  }

  @override
  Widget build(BuildContext context) {
    String id = widget.documentSnapshot.id;
    String imageUrl = widget.documentSnapshot["imageUrl"] ??
        "https://images.pexels.com/photos/3811021/pexels-photo-3811021.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1";
    String title = widget.documentSnapshot["title"] ?? "";
    String location = widget.documentSnapshot["location"] ?? "";
    String detail = widget.documentSnapshot["detail"] ?? "";
    int fee = widget.documentSnapshot["entryFee"] ?? 0;
    String date = DateFormat('dd-MM-yyyy At HH:mm')
        .format(widget.documentSnapshot['date'].toDate());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          '${title.toUpperCase()}',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            width: 300,
            child: Card(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              width: 250,
                              height: 250,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "$title",
                          style: TextStyle(fontSize: 25, color: Colors.blue),
                        ),
                        SizedBox(height: 10),
                        Icon(
                          Icons.location_on,
                          color: Colors.blue[700],
                        ),
                        Text(
                          "$location",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_month,
                              color: Colors.blue[700],
                            ),
                            Text(
                              "   $date",
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          "$detail",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                joined ? Colors.white : Colors.blue,
                            foregroundColor:
                                joined ? Colors.black : Colors.white,
                          ),
                          onPressed: () async {
                            // Check if already joined
                            if (joined) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "You have already joined this event."),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              return;
                            }

                            // Get userId from SharedPreferences
                            String? newUserId = await getUserId();

                            // Check if newUserId is not null before proceeding
                            if (newUserId != null) {
                              DocumentReference documentReference =
                                  FirebaseFirestore.instance
                                      .collection("eventJoined")
                                      .doc(id);

                              // Check if the document already exists
                              DocumentSnapshot documentSnapshot =
                                  await documentReference.get();

                              if (documentSnapshot.exists) {
                                // If the document exists, update the array
                                await documentReference.update({
                                  "userID": FieldValue.arrayUnion([newUserId]),
                                });
                              } else {
                                // If the document doesn't exist, create a new one
                                await documentReference.set({
                                  "userID": [newUserId],
                                });
                              }

                              setState(() {
                                joined = true;
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("You have joined the event."),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              print("Value added to the array in Firestore");
                              // Increment joinCount in the user's profile document
                              DocumentReference profileReference =
                                  FirebaseFirestore.instance
                                      .collection("profile")
                                      .doc(newUserId);

                              profileReference.update({
                                "joinCount": FieldValue.increment(1),
                              });
                            } else {
                              print("Error: User ID is null");
                            }
                          },
                          child: Text(
                            joined
                                ? 'Joined'
                                : (fee == 0
                                    ? 'Join Free'
                                    : 'Join with ${fee} Rs'),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
