import 'package:flutter/material.dart';
import 'package:music_player_app/providers/bottom_navegationbar_provider.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigationBarProvider =
        Provider.of<BottomNavigationBarProvider>(context);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      showSelectedLabels: true,
      backgroundColor: const Color.fromRGBO(20, 20, 20, 0.8),
      unselectedItemColor: Colors.white30,
      selectedItemColor: Colors.white,
      currentIndex: navigationBarProvider.currentIndex,
      onTap: (index) {
        navigationBarProvider.currentIndex = index;
      },
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
