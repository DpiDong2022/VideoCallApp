import 'package:flutter/material.dart';
import 'package:videocall/helpers/common.dart';
import 'package:videocall/models/notification2.dart';

class NotificationCard extends StatefulWidget {
  final Notification2 notification;

  NotificationCard({super.key, required this.notification});

  @override
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 0.0), // Small vertical padding to separate cards slightly
      child: Card(
        shadowColor: Colors.white,
        color: Colors.white,
        surfaceTintColor: Colors.white,
        margin: EdgeInsets.zero, // Remove default margin
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(), // Apply corner radius
          side: BorderSide(
            color: Colors.black, // Set the border color
            width: 0.001, // Set the border width
          ),
        ),

        child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20), // Adjust as needed
            title: RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: widget.notification.name,
                  style: const TextStyle(
                      height: 1.4,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              TextSpan(
                  text: widget.notification.isFriendRequst
                      ? " sent a friend request."
                      : " has accepted the friend request.",
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                    height: 1.4,
                  ))
            ])),
            subtitle: Text(
              widget.notification.at,
              style: const TextStyle(fontSize: 15),
            ),
            trailing: Column(
              children: [
                if (!widget.notification.isAccepted &&
                    widget.notification.isFriendRequst) ...[
                  TextButton(
                      style: Common.customButtonStyle(
                          backgroundColor: Colors.blue,
                          size: const Size(100, 15),
                          textColor: Colors.white,
                          fontSize: 14,
                          circular: 6),
                      onPressed: () {
                        setState(() {
                          widget.notification.isAccepted = true;
                        });
                      },
                      child: const Text("Accept"))
                ] else if (widget.notification.isAccepted &&
                    widget.notification.isFriendRequst) ...[
                  TextButton(
                      style: Common.customButtonStyle(
                          backgroundColor:
                              const Color.fromARGB(255, 66, 171, 30),
                          size: const Size(100, 15),
                          textColor: Colors.white,
                          fontSize: 14,
                          circular: 6),
                      onPressed: () {},
                      child: const Text("Accepted"))
                ]
              ],
            )),
      ),
    );
  }
}
