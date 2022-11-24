import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player_app/providers/bottom_navegationbar_provider.dart';
import 'package:music_player_app/providers/db_provider.dart';
import 'package:music_player_app/providers/playlist_provider.dart';
import 'package:provider/provider.dart';

import 'package:music_player_app/providers/player_provider.dart';
import 'package:music_player_app/screens/screens.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: ((context) => PlayerProvider()),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: ((context) => PlaylistProvider()),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: ((context) => BottomNavigationBarProvider()),
          lazy: false,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music player',
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      routes: {
        // 'player': (_) => const PlayerScreen(),
        'home': (_) => const HomeScreen(),
      },
      theme: ThemeData(
        fontFamily: 'Proxima Nova',
        // pageTransitionsTheme: const PageTransitionsTheme(builders: {
        //   TargetPlatform.android: FadeUpwardsPageTransitionsBuilder()
        // }),
      ),
    );
  }
}
