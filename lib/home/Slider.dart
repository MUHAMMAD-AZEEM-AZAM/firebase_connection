import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MySlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('promotions').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        var imageUrls =
            snapshot.data?.docs.map((doc) => doc['imageUrl']).toList();

        return CarouselSlider(
          items: imageUrls?.map((imageUrl) {
            return Builder(
              builder: (BuildContext context) {
                return Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                );
              },
            );
          }).toList(),
          options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
            viewportFraction: 0.8,
          ),
        );
      },
    );
  }
}
