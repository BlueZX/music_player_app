import 'package:flutter/material.dart';
import 'package:music_player_app/layout/app_wrapper.dart';

class HomeScreen extends StatelessWidget {
  final Widget? content;
  const HomeScreen({
    Key? key,
    this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(20, 20, 20, 0.8),
              Color.fromRGBO(66, 66, 66, 1),
            ]),
      ),
      child: AppWrapper(
        content: content,
        withBottomNavbar: true,
      ),
    );
  }
}
