import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_connection/SharedPref.dart';
import 'package:firebase_connection/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  late Future<String?> _userIDFuture;
  late Future<DocumentSnapshot> _profileDataFuture;

  @override
  void initState() {
    super.initState();
    _userIDFuture = getUserID();
    _profileDataFuture = _userIDFuture.then((userID) =>
        FirebaseFirestore.instance.collection("profile").doc(userID).get());

    // Fetch and store profile data in SharedPreferences when the screen is opened
    storeProfileDataInSharedPreferences();
  }

  Future<String?> getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid');
  }

  Future<void> storeProfileDataInSharedPreferences() async {
    String? userID = await getUserID();
    DocumentSnapshot profileData = await FirebaseFirestore.instance
        .collection("profile")
        .doc(userID)
        .get();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save the profile data in SharedPreferences
    prefs.setString('uid', userID!);
    prefs.setString('name', profileData['name']);
    prefs.setString('dob', profileData['DOB']);
    prefs.setString('eventCount', profileData['eventCount']);
    prefs.setString('joinCount', profileData['joinCount']);
    prefs.setString('location', profileData['location']);
    prefs.setString('phoneNumber', profileData['phoneNumber']);
    prefs.setString('userID', profileData['userName']);
    // Add other fields as needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder(
            future: _profileDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                var profileData = snapshot.data as DocumentSnapshot;
                return Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Create a card for the name with a large font size and a blue gradient background
                    Card(
                      color: Colors.transparent,
                      elevation: 3.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Container(
                        width: 350,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Center(
                          child: Text(
                            profileData['name'].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 1, 86, 155),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Create a card for the date of birth with a small font size and a white background
                    Card(
                      color: Colors.transparent,
                      elevation: 3.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Container(
                        width: 300,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.cake,
                                size: 50,
                                color: Color.fromARGB(255, 179, 21,
                                    0), // You can choose a color for the cake icon
                              ),
                              const Text(
                                'Date of Birth ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 1, 86, 155),
                                ),
                              ),
                              Text(
                                DateFormat('dd-MM-yyyy')
                                    .format(profileData['DOB'].toDate()),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Create a card for the event count with a medium font size and a green background
                    Row(
                      children: [
                        Card(
                          color: Colors.transparent,
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Container(
                            width: 150,
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Events Attend ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 1, 86, 155),
                                    ),
                                  ),
                                  Text(
                                    '${profileData['eventCount']}',
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(255, 215, 0, 1.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Create a card for the join count with a medium font size and a yellow background
                        Card(
                          color: Colors.transparent,
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Container(
                            width: 150,
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Events Join',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 1, 86, 155),
                                    ),
                                  ),
                                  Text(
                                    '${profileData['joinCount']}',
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(255, 215, 0, 1.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Card(
                      color: Colors.transparent,
                      elevation: 3.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Container(
                        width: 300,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Location ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 1, 86, 155),
                                ),
                              ),
                              Text(
                                profileData['location'],
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Create a card for the phone number with a small font size and a white background
                    Card(
                      color: Colors.transparent,
                      elevation: 3.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Container(
                        width: 300,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Phone Number ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 1, 86, 155),
                                ),
                              ),
                              Text(
                                profileData['phoneNumber'],
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.blue, // Set the background color to blue
                          foregroundColor: Colors
                              .white, // Set the text and icon color to white
                          maximumSize: const Size(150, 100),
                          minimumSize: const Size(
                              150, 60) // Set the minimum width to 150
                          ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Logout'),
                          Icon(Icons.logout),
                        ],
                      ),
                      onPressed: () async {
                        // Get the instance of shared preferences
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        // Call the clear method to delete all the data
                        await preferences.clear();
                        // Show a snackbar to confirm
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Logout'),
                          ),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyApp()),
                        );
                      },
                    )
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
