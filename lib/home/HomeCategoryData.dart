import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_connection/event/EventDetail.dart';
import 'package:flutter/material.dart';

class CategoryData extends StatefulWidget {
  final String category;
  const CategoryData(this.category, {super.key});

  @override
  State<StatefulWidget> createState() => CategoryDataState(category);
}

class CategoryDataState extends State<CategoryData> {
  String category;
  CategoryDataState(this.category);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
  stream: FirebaseFirestore.instance.collection("event").snapshots(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      // Replace 'desiredCategory' with the actual category you want to filter
      String desiredCategory = category;

      // Filter the items based on the category condition
      List<DocumentSnapshot> filteredItems = snapshot.data!.docs
          .where((doc) => doc["category"] == desiredCategory)
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

            return GestureDetector(
               onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EventDetail(documentSnapshot: documentSnapshot)),
                        );
                      },
              child: Container(
                height: 100,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
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
                                      documentSnapshot["imageUrl"] == null
                                          ? 'https://images.pexels.com/photos/3811021/pexels-photo-3811021.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'
                                          : documentSnapshot["imageUrl"],
                                      fit: BoxFit.cover,
                                    )),
                                  ),
                                  Text(
                                    documentSnapshot["title"],
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  Text(documentSnapshot["location"]),
                      ],
                    ),
                  ),
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
)
    );
  }
}
