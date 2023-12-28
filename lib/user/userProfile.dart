import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_connection/user/dobPicker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  String? name, phoneNumber, location, userName;
  int? eventCount = 0, joinCount = 0;
  DateTime? dob;

  String? userID;

  Future<void> getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString('uid');
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> addProfile() async {
    await getUserID(); // Wait for getUserID to complete

    if (formKey.currentState!.validate()) {
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection("profile").doc(userID);

      print(userID);

      Map<String, dynamic> event = {
        "name": name,
        "phoneNumber": phoneNumber,
        "eventCount": eventCount,
        "location": location,
        "DOB": dob,
        "joinCount": joinCount,
        "userName": userID,
      };

      documentReference.set(event).whenComplete(() {
        print("$name created");

        // Clear text fields after data is added
        nameController.clear();
        phoneNumberController.clear();
        locationController.clear();
        dobController.clear();

        // Optionally, you can also reset other state variables if needed
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: const Text(
          'Create Your Profile',
          style: TextStyle(color: Colors.white),
        )),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ... (your existing UI code)
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Your Name",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    prefixIcon: Icon(Icons.event),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    if (double.tryParse(value) != null) {
                      return 'Name cannot be a number';
                    }
                    return null;
                  },
                  onChanged: (String name) {
                    this.name = name;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: phoneNumberController,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    prefixIcon: Icon(Icons.description),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (value.length != 11) {
                      return 'Phone number must be 11 digits';
                    }
                    return null;
                  },
                  onChanged: (String ph) {
                    this.phoneNumber = ph;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: locationController,
                    decoration: const InputDecoration(
                      labelText: "Your Location (Current)",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    onChanged: (String location) {
                      this.location = location;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Location';
                      }
                    }),
                const SizedBox(
                  height: 20,
                ),
                DatePick(
                  onDateSelected: (combinedDate) {
                    if (combinedDate == null ||
                        combinedDate == 'Not selected') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a valid date'),
                        ),
                      );
                    }
                    dob = combinedDate;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50),
                  child: ElevatedButton(
                    onPressed: () {
                      addProfile();
                      Navigator.pop(context);
                      Navigator.pop(context); // Go back to the previous screen
                      Navigator.pop(context); // Go back to the previous screen (SignUpScreen)
                    },
                    child: const Text('Add User Profile'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
