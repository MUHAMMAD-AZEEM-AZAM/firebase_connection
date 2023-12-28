import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
    String date = DateFormat('dd-MM-yyyy At HH:mm').format(documentSnapshot['date'].toDate());

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
                          style: TextStyle(fontSize: 18,),
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
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {},
                          child: Text(
                              fee == 0 ? 'Join Free' : 'Join with ${fee} Rs'),
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
