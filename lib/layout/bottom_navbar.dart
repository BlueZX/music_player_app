import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;

  const BottomNavBar({Key? key, required this.currentIndex, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      showSelectedLabels: true,
      backgroundColor: const Color.fromRGBO(20, 20, 20, 0.8),
      unselectedItemColor: Colors.white30,
      selectedItemColor: Colors.white,
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.music_note), label: 'Mi musica'),
        BottomNavigationBarItem(
            icon: Icon(Icons.public_rounded), label: 'Explorar'),
        // BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
      ],
    );
  }
}
