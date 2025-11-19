
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePhotoStack extends StatelessWidget {
  final String? photoUrl;
  final File? localImage;
  final VoidCallback onAddPhoto;

  const ProfilePhotoStack({
    super.key,
    this.photoUrl,
    this.localImage,
    required this.onAddPhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 70,
          backgroundImage: localImage != null
              ? FileImage(localImage!)
              : (photoUrl != null && photoUrl!.isNotEmpty
              ? NetworkImage(photoUrl!)
              : const AssetImage("assets/appImages/Diary.png") as ImageProvider),
        ),

        Positioned(
          bottom: 4,
          right: 4,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(50),
              splashColor: Colors.white30,
              onTap: () {
                print("Camera clicked!");
                onAddPhoto();
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.85),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
                  ],
                ),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 28),
              ),
            ),
          ),
        ),
      ],
    );
  }
}