import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String? photoUrl;
  final double radius;

  const Avatar({super.key, this.photoUrl, this.radius = 24});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey.shade100,
      backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
    );
  }
}
