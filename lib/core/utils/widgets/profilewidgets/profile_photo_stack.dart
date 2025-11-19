// core/utils/widgets/profile/profile_photo_stack.dart
import 'dart:io';

import 'package:flutter/material.dart';

import '../../../theme/app_color.dart';
import '../../../theme/app_theme_constants.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      clipBehavior: Clip.none,
      children: [

        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.purple,
              width: 4.0,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.gray900.withOpacity(isDark ? 0.6 : 0.25),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 72,
            backgroundColor: isDark ? AppColors.gray800 : AppColors.gray200,
            backgroundImage: localImage != null
                ? FileImage(localImage!)
                : (photoUrl != null && photoUrl!.isNotEmpty
                ? NetworkImage(photoUrl!)
                : const AssetImage("assets/appImages/Diary.png") as ImageProvider),
          ),
        ),


        Positioned(
          bottom: 6,
          right: 6,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(50),
              splashColor: AppColors.primary.withOpacity(0.3),
              highlightColor: AppColors.primary.withOpacity(0.15),
              onTap: onAddPhoto,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.purple,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.5),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}