import 'package:flutter/material.dart';
import 'package:videocall/helpers/common.dart';
import 'package:videocall/models/user.dart';

class UserCard extends StatefulWidget {
  final User user;

  const UserCard({super.key, required this.user});

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  MemoryImage? _avatar;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeAvatar();
  }

  Future<void> _initializeAvatar() async {
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
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 35,
          backgroundImage: _avatar != null
              ? _avatar as ImageProvider
              : const AssetImage('assets/images/default_avatar.jpg')
                  as ImageProvider,
          child: _isLoading
              ? const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                )
              : null,
        ),
        title: Text(
          widget.user.name,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      ),
    );
  }
}
