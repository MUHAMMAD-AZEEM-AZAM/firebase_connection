// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:image_picker/image_picker.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';


// Future<void> uploadImage(String eventId) async {
//   final picker = ImagePicker();
//   final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//   if (pickedFile != null) {
//     var file = File(pickedFile.path);

//     try {
//       // Upload the file to Firebase Storage
//       var storageRef = firebase_storage.FirebaseStorage.instance
//           .ref()
//           .child('events/$eventId/${DateTime.now()}.jpg');

//       await storageRef.putFile(file);

//       print('Image uploaded successfully!');
//     } catch (e) {
//       print('Error uploading image: $e');
//     }
//   } else {
//     print('No image selected.');
//   }
// }





// Future<void> saveImageUrl(String eventId, String imageUrl) async {
//   try {
//     // Update the document in the "events" collection with the image URL
//     await FirebaseFirestore.instance
//         .collection('events')
//         .doc(eventId)
//         .update({'image': imageUrl});
    
//     print('Image URL saved to Firestore!');
//   } catch (e) {
//     print('Error saving image URL: $e');
//   }
// }



// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:firebase_connection/event/datePicker.dart';
// import 'package:flutter/material.dart';

// class Event extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => EventState();
// }

// class EventState extends State<Event> {
//   String? title, detail, location;
//   int? entryFee;
//   String category = 'Select Category';
//   DateTime? dateTime;
//   String? imageUrl; // Added imageUrl to store the URL of the uploaded image

//   TextEditingController titleController = TextEditingController();
//   TextEditingController detailController = TextEditingController();
//   TextEditingController locationController = TextEditingController();
//   TextEditingController entryFeeController = TextEditingController();

//   // Function to pick an image from the device
//   Future<void> pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       var file = File(pickedFile.path);

//       try {
//         // Upload the file to Firebase Storage
//         var storageRef = firebase_storage.FirebaseStorage.instance
//             .ref()
//             .child('event_images/${DateTime.now()}.jpg');

//         await storageRef.putFile(file);

//         // Get the download URL of the uploaded image
//         imageUrl = await storageRef.getDownloadURL();

//         print('Image uploaded successfully!');
//       } catch (e) {
//         print('Error uploading image: $e');
//       }
//     } else {
//       print('No image selected.');
//     }
//   }

//   addEvent() {
//     DocumentReference documentReference =
//         FirebaseFirestore.instance.collection("event").doc();

//     Map<String, dynamic> event = {
//       "title": title,
//       "detail": detail,
//       "category": category,
//       "location": location,
//       "date": dateTime,
//       "entryFee": entryFee,
//       "userID": 2,
//       "imageUrl": imageUrl, // Added imageUrl to the event data
//     };

//     documentReference.set(event).whenComplete(() {
//       print("$title created");

//       // Clear text fields after data is added
//       titleController.clear();
//       detailController.clear();
//       locationController.clear();
//       entryFeeController.clear();

//       // Optionally, you can also reset other state variables if needed
//       setState(() {
//         category = 'Select Category';
//         dateTime = null;
//         imageUrl = null; // Clear imageUrl after adding event
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//    backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text('Create Event'),
//         backgroundColor: Colors.blue,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(50),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Center(
//                 child: InkWell(
//                   onTap: () async {
//                     await pickImage();
//                     setState(() {}); // Refresh UI after picking an image
//                   },
//                   child: imageUrl != null
//                       ? ClipOval(
//                           child: Image.network(
//                             imageUrl!,
//                             width: 100,
//                             height: 100,
//                             fit: BoxFit.cover,
//                           ),
//                         )
//                       : Icon(
//                           Icons.add_a_photo,
//                           size: 100,
//                         ),
//                 ),
//               ),
//                SizedBox(
//                 height: 20,
//               ),
//               const Text(
//                 'Event',
//                 style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               TextFormField(
//                 controller: titleController,
//                 decoration: const InputDecoration(
//                   labelText: "Event Name",
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue, width: 2.0),
//                   ),
//                   prefixIcon: Icon(Icons.event),
//                 ),
//                 onChanged: (String title) {
//                   this.title = title;
//                 },
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               TextFormField(
//                 controller: detailController,
//                 decoration: const InputDecoration(
//                   labelText: "Detail",
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue, width: 2.0),
//                   ),
//                   prefixIcon: Icon(Icons.description),
//                 ),
//                 onChanged: (String detail) {
//                   this.detail = detail;
//                 },
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               TextFormField(
//                 controller: locationController,
//                 decoration: const InputDecoration(
//                   labelText: "Location",
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue, width: 2.0),
//                   ),
//                   prefixIcon: Icon(Icons.location_on),
//                 ),
//                 onChanged: (String location) {
//                   this.location = location;
//                 },
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               DropdownButton<String>(
//                 value: category,
//                 focusNode: FocusNode(canRequestFocus: false),
//                 borderRadius: BorderRadius.circular(20),
//                 onChanged: (String? value) => setState(() {
//                   category = value!;
//                 }),
//                 items: [
//                   'Select Category',
//                   'Sports',
//                   'Entertainment',
//                   'Education',
//                   'Career',
//                   'Business',
//                   'Vacation'
//                 ].map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               DatePickWidget(
//                 onDateTimeSelected: (combinedDate) {
//                   dateTime = combinedDate;
//                 },
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               TextFormField(
//                 controller: entryFeeController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(
//                   labelText: "Entry Fee (PKR)",
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide(color: Colors.blue, width: 2.0),
//                   ),
//                   prefixIcon: Icon(Icons.attach_money_outlined),
//                 ),
//                 onChanged: (String entryFee) {
//                   this.entryFee = int.tryParse(entryFee);
//                 },
//               ),
//               SizedBox(
//                 height: 40,
//               ),
//               Padding(
//                 padding: EdgeInsets.only(left: 80, right: 80),
//                 child: ElevatedButton(
//                   onPressed: () => addEvent(),
//                   child: const Text('Add Event'),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
