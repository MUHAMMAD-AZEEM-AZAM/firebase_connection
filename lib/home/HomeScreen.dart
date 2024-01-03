import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_connection/event/EventDetail.dart';
import 'package:firebase_connection/home/HomeCategory.dart';
import 'package:firebase_connection/home/Slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  String? userName='' ;
  int? attendEvents=0;

  @override
  void initState() {
    super.initState();
    // Fetch userId from shared preferences and update user data
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('uid');

    // If userId is available, fetch user data from Firestore
    if (userId != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection("profile")
          .doc(userId)
          .get();

      setState(() {
        userName = userSnapshot["name"];
        attendEvents = userSnapshot["eventCount"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0), // Adjust the preferred height
        child: AppBar(
          shape: const RoundedRectangleBorder(
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
                    const SizedBox(
                      width: 5, // Adjust the space between icon and text
                    ),
                    Text(
                      userName!.toUpperCase(),
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
            child: SizedBox(
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

          const SizedBox(
            height: 20,
          ),

          const Center(
            child: Text(
              "All Events",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          //Events
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection("event").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                  shrinkWrap:
                      true, // Important to make it work within a ListView
                  physics:
                      const NeverScrollableScrollPhysics(), // Disable GridView scrolling
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
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EventDetail(documentSnapshot: documentSnapshot)),
                        );
                      },
                      child: Card(
                        elevation: 3.0,
                        child: Container(
                          width: 100, // Set the container width to 100
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.teal, width: 2.0)),
                                  child: ClipOval(
                                      child: Image.network(
                                    documentSnapshot["imageUrl"] ?? 'https://images.pexels.com/photos/3811021/pexels-photo-3811021.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                                    fit: BoxFit.cover,
                                  )),
                                ),
                                Text(
                                  documentSnapshot["title"],
                                  style: const TextStyle(color: Colors.blue),
                                ),
                                Text(documentSnapshot["location"]),
                              ],
                            ),
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
