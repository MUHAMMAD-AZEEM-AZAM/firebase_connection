import 'package:firebase_connection/home/HomeCategoryData.dart';
import 'package:flutter/material.dart';

class MyGridView extends StatelessWidget {
  // Data
  final List<List<dynamic>> category = [
    ['Sports', Icons.sports_baseball_sharp],
    ['Entertainment', Icons.movie_filter_sharp],
    ['Education', Icons.lightbulb],
    ['Career', Icons.handshake_outlined],
    ['Business', Icons.business_outlined],
    ['Vacations', Icons.beach_access],
    ['Social', Icons.groups],
    ['Politics', Icons.account_balance_outlined],
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // Number of columns in the grid
        mainAxisSpacing: 4.0, // Spacing between rows
      ),
      itemCount: category.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CategoryData(category[index][0])),
            );
          },
          child: MyCard(
            title: category[index][0],
            icon: category[index][1],
          ),
        );
      },
    );
  }
}

class MyCard extends StatelessWidget {
  final String title;
  final IconData icon;

  MyCard({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
  elevation: 1.5,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15.0),
  ),
  child: Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 18.0,
          color: const Color.fromARGB(255, 0, 42, 77),
        ),
        SizedBox(height: 4.0),
        Text(
          title,
          style: TextStyle(fontSize: 10.0),
        ),
      ],
    ),
  ),
);

  }
}
