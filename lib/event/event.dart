import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_connection/event/datePicker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Event extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EventState();
}

class EventState extends State<Event> {
  String? title, detail, location;
  int? entryFee;
  String category = 'Select Category';
  DateTime? dateTime;
  String? imageUrl; // Added imageUrl to store the URL of the uploaded image
  String? userID;

  TextEditingController titleController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController entryFeeController = TextEditingController();

  // Function to pick an image from the device
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      var file = File(pickedFile.path);

      try {
        // Upload the file to Firebase Storage
        var storageRef = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('event_images/${DateTime.now()}.jpg');

        await storageRef.putFile(file);

        // Get the download URL of the uploaded image
        imageUrl = await storageRef.getDownloadURL();

        print('Image uploaded successfully!');
      } catch (e) {
        print('Error uploading image: $e');
      }
    } else {
      print('No image selected.');
    }
  }

 Future<void> addEvent() async {
  await getUserID();

  DocumentReference documentReference =
      FirebaseFirestore.instance.collection("event").doc();

  // Retrieve the event ID
  String eventId = documentReference.id;

  Map<String, dynamic> event = {
    "title": title,
    "detail": detail,
    "category": category,
    "location": location,
    "date": dateTime,
    "entryFee": entryFee,
    "userID": userID,
    "imageUrl": imageUrl,
  };

  // Set the event data in the "event" collection
  await documentReference.set(event).then((_) async {
    print("$title created");

    // Now create a corresponding document in the "eventJoined" collection with the same ID
    // DocumentReference documentReference1 =
    //     FirebaseFirestore.instance.collection("eventJoined").doc(eventId);

    // // Set the user ID in the "eventJoined" document or create it if it doesn't exist
    // await documentReference1.set(
    //   {"userID": FieldValue.arrayUnion([userID])},
    //   SetOptions(merge: true), // Use merge option to create if document doesn't exist
    // );

    // Clear text fields after data is added
    titleController.clear();
    detailController.clear();
    locationController.clear();
    entryFeeController.clear();

    // Optionally, you can also reset other state variables if needed
    setState(() {
      category = 'Select Category';
      dateTime = null;
      imageUrl = null;
    });
  }).catchError((error) {
    print("Error creating event: $error");
  });
}


  Future<void> getUserID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString('uid');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(
            child: const Text(
          'Create Event',
          style: TextStyle(color: Colors.white),
        )),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: InkWell(
                  onTap: () async {
                    await pickImage();
                    setState(() {}); // Refresh UI after picking an image
                  },
                  child: imageUrl != null
                      ? ClipOval(
                          child: Image.network(
                            imageUrl!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(
                          Icons.add_a_photo,
                          size: 30,
                          color: const Color.fromARGB(255, 77, 77, 77),
                        ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              const Text(
                'Event',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Color.fromARGB(255, 54, 54, 54)),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Event Name",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  prefixIcon: Icon(Icons.title),
                ),
                onChanged: (String title) {
                  this.title = title;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: detailController,
                decoration: const InputDecoration(
                  labelText: "Detail",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  prefixIcon: Icon(Icons.description),
                ),
                onChanged: (String detail) {
                  this.detail = detail;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: "Location",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  prefixIcon: Icon(Icons.location_on),
                ),
                onChanged: (String location) {
                  this.location = location;
                },
              ),
              SizedBox(
                height: 20,
              ),
              DropdownButton<String>(
                value: category,
                focusNode: FocusNode(canRequestFocus: false),
                borderRadius: BorderRadius.circular(20),
                onChanged: (String? value) => setState(() {
                  category = value!;
                }),
                items: [
                  'Select Category',
                  'Sports',
                  'Entertainment',
                  'Education',
                  'Career',
                  'Business',
                  'Vacation'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(
                height: 20,
              ),
              DatePickWidget(
                onDateTimeSelected: (combinedDate) {
                  dateTime = combinedDate;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: entryFeeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Entry Fee (PKR)",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  prefixIcon: Icon(Icons.attach_money_outlined),
                ),
                onChanged: (String entryFee) {
                  this.entryFee = int.tryParse(entryFee);
                },
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: EdgeInsets.only(left: 50, right: 50),
                child: ElevatedButton(
                  onPressed: () => addEvent(),
                  child: const Text('Add Event'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
