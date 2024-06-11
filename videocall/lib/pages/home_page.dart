import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AppBar',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VideoCallAppBar(
        title: 'Appbar',
        onSearchTap: () {},
        onAddFriendTap: () {},
        onSettingsTap: () {},
      ),
    );
  }
}

class VideoCallAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onSearchTap;
  final VoidCallback onAddFriendTap;
  final VoidCallback onSettingsTap;

  const VideoCallAppBar({
    super.key,
    required this.title,
    required this.onSearchTap,
    required this.onAddFriendTap,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      elevation: 4.0, // Shadow effect
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w100,
        ),
      ),
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Icons.search, color: Colors.white),
        onPressed: () {},
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.group_add_outlined, color: Colors.white),
          onPressed: onSearchTap,
        ),
        IconButton(
          icon:
              const Icon(Icons.settings_suggest_outlined, color: Colors.white),
          onPressed: onSearchTap,
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
