import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(this.userName, this._message, this.userImage, this.isMe,
      {Key? key})
      : super(key: key);

  final String _message;
  final bool isMe;
  final String userName;
  final String? userImage;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: [
          Row(
            mainAxisAlignment:
                !isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft: isMe ? Radius.circular(12) : Radius.circular(0),
                    bottomRight:
                        isMe ? Radius.circular(0) : Radius.circular(12),
                  ),
                  color: isMe
                      ? Theme.of(context).colorScheme.secondary
                      : Colors.grey[400],
                ),
                width: constraints.minWidth * 0.5,
                margin: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 14,
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isMe ? Colors.white : Colors.black),
                    ),
                    Text(
                      _message,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            right: null,
            left: (constraints.maxWidth * 0.5) - 20,
            child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(userImage ?? ''),
            ),
          ),
        ],
        clipBehavior: Clip.none,
      ),
    );
  }
}
