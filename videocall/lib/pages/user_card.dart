import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:videocall/helpers/common.dart';
import 'package:videocall/helpers/enum_helper.dart';
import 'package:videocall/models/user.dart';
import 'package:videocall/pages/video_call.dart';

class UserCard extends StatefulWidget {
  final User user;

  UserCard({super.key, required this.user});

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  MemoryImage? _avatar;
  bool _isLoading = true;
  ImageProvider? avatar;

  @override
  void initState() {
    super.initState();
    _initializeAvatar();
    if (widget.user.image!.isNotEmpty) {}
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

  Future<void> _showProfileDialog() async {
    showDialog(
      barrierColor: Colors.black.withOpacity(0.7),
      context: context,
      builder: (BuildContext context) {
        if (widget.user.image!.isEmpty) {
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                  image: AssetImage("assets/images/default_avatar.jpg")
                      as ImageProvider),
            ],
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: _avatar as ImageProvider),
            ],
          );
        }
      },
    );
  }

  void _showUnfriendConfirmationDialog() {
    showDialog(
      barrierColor: Colors.black.withOpacity(0.7),
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: const Text(
            'Unfriend Confirmation',
            style: TextStyle(fontSize: 18),
          ),
          content:
              Text('Are you sure you want to unfriend ${widget.user.name}?'),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Unfriend',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Common.customScaffoldMessager(
                  context: context,
                  message: "You have unfriended ${widget.user.name}!",
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Card(
        shadowColor: Colors.white,
        color: Colors.white,
        surfaceTintColor: Colors.white,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
          side: const BorderSide(
            color: Colors.black,
            width: 0.05,
          ),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          leading: CircleAvatar(
            radius: 30,
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
          subtitle: Text("Phone: ${widget.user.phone}"),
          trailing: PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            position: PopupMenuPosition.over,
            elevation: 15,
            offset: const Offset(-10, 38),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            surfaceTintColor: Colors.white,
            onSelected: (value) {
              switch (value) {
                case 'View profile picture':
                  _showProfileDialog();
                  break;
                case 'Copy phone number':
                  Clipboard.setData(ClipboardData(text: widget.user.phone));
                  Common.customScaffoldMessager(
                    context: context,
                    message: "The phone number has been saved!",
                  );
                  break;
                case 'Call':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoCallPage(user: widget.user),
                    ),
                  );
                  break;
                case 'Add friend':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoCallPage(user: widget.user),
                    ),
                  );
                  break;
                case 'Unfriend':
                  _showUnfriendConfirmationDialog();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'View profile picture',
                child: Row(
                  children: [
                    Icon(Icons.zoom_out_map_rounded, color: Colors.blue),
                    SizedBox(width: 14),
                    Text('View profile picture'),
                  ],
                ),
              ),
              const PopupMenuDivider(height: 0),
              const PopupMenuItem(
                value: 'Copy phone number',
                child: Row(
                  children: [
                    Icon(Icons.copy_outlined, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Copy phone number'),
                  ],
                ),
              ),
              if (widget.user.userType == UserTypeEnum.FRIEND) ...[
                const PopupMenuDivider(height: 0),
                const PopupMenuItem(
                  value: 'Call',
                  child: Row(
                    children: [
                      Icon(Icons.video_call_outlined, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('Call'),
                    ],
                  ),
                ),
              ],
              if (widget.user.userType == UserTypeEnum.UNKNOWN) ...[
                const PopupMenuDivider(height: 0),
                const PopupMenuItem(
                  value: 'Add friend',
                  child: Row(
                    children: [
                      Icon(Icons.person_add_alt_outlined, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('Add friend'),
                    ],
                  ),
                ),
              ] else if (widget.user.userType == UserTypeEnum.FRIEND) ...[
                const PopupMenuDivider(height: 0),
                const PopupMenuItem(
                  value: 'Unfriend',
                  child: Row(
                    children: [
                      Icon(Icons.person_remove_outlined, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('Unfriend'),
                    ],
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
