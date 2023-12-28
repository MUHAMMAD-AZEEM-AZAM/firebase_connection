import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_connection/home/HomeCategory.dart';
import 'package:firebase_connection/home/Slider.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  String? userName = "Muhammad Azeem";
  int? attendEvents = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0), // Adjust the preferred height
        child: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          backgroundColor: Colors.blue,
          elevation: 0, // Remove the shadow
          title: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 24, // Adjust the icon size
                    ),
                    SizedBox(
                      width: 5, // Adjust the space between icon and text
                    ),
                    Text(
                      userName!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15, // Adjust the text size
                      ),
                    ),
                  ],
                ),
                Text(
                  'Attend Event $attendEvents',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10, // Adjust the text size
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
        
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              height: 250,
              child: Center(
                child: MyGridView(),
              ),
            ),
          ),

          SizedBox(
            width: 350,
            height: 150,
            child: MySlider(),
          ),

          SizedBox(
            height: 20,
          ),

          Center(
            child: Text(
              "All Events",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),

           SizedBox(
            height: 10,
          ),

          //Events
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection("event").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                  shrinkWrap: true, // Important to make it work within a ListView
                  physics: NeverScrollableScrollPhysics(), // Disable GridView scrolling
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns in the grid
                    crossAxisSpacing: 8.0, // Spacing between columns
                    mainAxisSpacing: 8.0, // Spacing between rows
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot =
                        snapshot.data!.docs[index];
                    return Card(
                      elevation: 3.0,
                      child: Container(
                        height: 100, // Set the container height to 100
                        width: 100, // Set the container width to 100
                        decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                                      ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(documentSnapshot["title"]),
                              Text(documentSnapshot["location"]),
                              Text(documentSnapshot["category"]),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}
