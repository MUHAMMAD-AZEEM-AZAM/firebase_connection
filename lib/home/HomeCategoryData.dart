import 'package:cloud_firestore/cloud_firestore.dart';
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
)
    );
  }
}
