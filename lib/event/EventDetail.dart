import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventDetail extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;

  // Constructor to receive the DocumentSnapshot object
  EventDetail({required this.documentSnapshot});

  @override
  Widget build(BuildContext context) {
    String imageUrl = documentSnapshot["imageUrl"] ??
        "https://images.pexels.com/photos/3811021/pexels-photo-3811021.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1";
    String title = documentSnapshot["title"] ?? "";
    String location = documentSnapshot["location"] ?? "";
    String detail = documentSnapshot["detail"] ?? "";
    int fee = documentSnapshot["entryFee"] ?? "";

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
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.teal, width: 2.0),
                      ),
                      child: ClipOval(
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: 250,
                          height: 250,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "$title",
                      style: TextStyle(fontSize: 25, color: Colors.blue),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.blue[700],
                        ),
                        Text(
                          "$location",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "$detail",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.blue, // Set the background color to blue
                          foregroundColor: Colors
                              .white, // Set the text and icon color to white
                        ),
                        onPressed: () {},
                        child: Text(
                            fee == 0 ? 'Join Free' : 'Join with ${fee} Rs'))
                    // Add more widgets to display other data from the documentSnapshot
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
