import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreatedScreen extends StatelessWidget {
  Future<String?> getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: const Text(
          'Events You Created',
          style: TextStyle(color: Colors.white),
        )),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          SizedBox(height: 20,),
          FutureBuilder<String?>(
            future: getUserID(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Return a loading indicator while waiting for the userID
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                // Handle errors
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (snapshot.hasData) {
                // Once we have the userID, use it in the StreamBuilder
                String? userID = snapshot.data;
          
                return StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("event").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // Filter the items
                      List<DocumentSnapshot> filteredItems = snapshot.data!.docs
                          .where((doc) => doc["userID"] == userID)
                          .toList();
          
                      return Expanded(
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Number of columns in the grid
                            crossAxisSpacing: 8.0, // Spacing between columns
                            mainAxisSpacing: 8.0, // Spacing between rows
                          ),
                          itemCount: filteredItems.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot documentSnapshot = filteredItems[index];
          
                            return Container(
                              height: 100,
                              child: Card(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(documentSnapshot["title"]),
                                    Text(documentSnapshot["location"]),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                );
              } else {
                return const Center(
                  child: Text('No userID available'),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
