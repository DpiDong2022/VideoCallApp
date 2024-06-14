import 'package:flutter/material.dart';
import 'package:videocall/helpers/common.dart';
import 'package:videocall/models/user.dart';

class UserDetailPage extends StatefulWidget {
  final User user;

  UserDetailPage({super.key, required this.user});

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  ImageProvider<Object>? _avatar;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  Future<void> _loadAvatar() async {
    if (widget.user.image != null && widget.user.image!.isNotEmpty) {
      try {
        final memoryImage = await Common.blobToImageWidget(widget.user.image!);
        setState(() {
          _avatar = memoryImage;
          _isLoading = false;
        });
      } catch (e) {
        print('Error loading avatar: $e');
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _avatar = const AssetImage('assets/images/default_avatar.jpg');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.name),
        backgroundColor: Colors.blue[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: _isLoading
                  ? null
                  : _avatar ??
                      const AssetImage('assets/images/default_avatar.jpg'),
              backgroundColor: Colors.grey[200],
              child: _isLoading ? const CircularProgressIndicator() : null,
            ),
            const SizedBox(height: 20),
            Text(
              widget.user.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.user.phone,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildFriendButton(),
            const SizedBox(height: 10),
            _buildCallButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendButton() {
    return ElevatedButton(
      onPressed: () {
        // Implement logic for adding a friend
        // For example, call a function to send a friend request
      },
      child: const Text('Add Friend'),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(150, 50),
      ),
    );
  }

  Widget _buildCallButton() {
    return ElevatedButton(
      onPressed: () {
        // Implement logic for initiating a call
        // For example, navigate to a call page with user details
      },
      child: const Text('Call'),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(150, 50),
      ),
    );
  }
}
