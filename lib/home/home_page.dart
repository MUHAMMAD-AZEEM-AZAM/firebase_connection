import 'package:firebase_connection/Menu%20bar/create_screen.dart';
import 'package:firebase_connection/Menu%20bar/created_screen.dart';
import 'package:firebase_connection/Menu%20bar/joined_screen.dart';
import 'package:firebase_connection/Menu%20bar/profile_screen.dart';
import 'package:firebase_connection/home/HomeScreen.dart';
import 'package:firebase_connection/user/userProfile.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String userID;
  const HomePage(this.userID, {super.key});

  @override
  _HomePageState createState() => _HomePageState(userID);
}

class _HomePageState extends State<HomePage> {
  String userID;
  _HomePageState(this.userID);
  int _currentIndex = 0;

  // Define your screen list
  final List<Widget> _screens = [
    Home(),
    JoinedScreen(),
    CreateScreen(),
    CreatedScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == _currentIndex) {
            print('\nthis is user Id$userID\n');
            // If the same tab is tapped again (Home), simulate a refresh
            setState(() {});
          } else {
            // If a different tab is tapped, navigate to the selected screen
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _currentIndex == 0 ? Colors.blue : Colors.grey,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.group,
              color: _currentIndex == 1 ? Colors.blue : Colors.grey,
            ),
            label: 'Joined',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add,
              color: _currentIndex == 2 ? Colors.blue : Colors.grey,
            ),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
              color: _currentIndex == 3 ? Colors.blue : Colors.grey,
            ),
            label: 'Created',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: _currentIndex == 4 ? Colors.blue : Colors.grey,
            ),
            label: 'Profile',
          ),
        ],
        // Customize the appearance of the BottomNavigationBar
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
        type: BottomNavigationBarType.fixed, // Ensure all labels are visible
        backgroundColor:
            Colors.white, // Background color of the BottomNavigationBar
        elevation: 5.0, // Elevation of the BottomNavigationBar
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Home';
      case 1:
        return 'Joined';
      case 2:
        return 'Create';
      case 3:
        return 'Created';
      case 4:
        return 'Profile';
      default:
        return 'Your App Name';
    }
  }
}
