import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: false,
      showSelectedLabels: false,
      backgroundColor: const Color.fromRGBO(20, 20, 20, 0.8),
      unselectedItemColor: Colors.white,
      selectedItemColor: Colors.white,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.menu_book), label: 'Biblioteca'),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
      ],
    );
  }
}
