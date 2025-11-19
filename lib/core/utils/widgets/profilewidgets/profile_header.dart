// views/screens/profile/widgets/profile_header.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_theme_constants.dart';
import '../../../../viewmodels/profile_viewmodel.dart';
import '../../../../views/screens/editprofile/edit_profile_screen.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, vm, child) {
        if (vm.isLoading) return _buildLoading();
        if (vm.user == null) return _buildGuest();

        final user = vm.user!;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.purple, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gray900.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 54,
                backgroundColor: AppColors.surfaceLight,
                backgroundImage: user.photoURL != null && user.photoURL!.isNotEmpty
                    ? NetworkImage(user.photoURL!)
                    : const AssetImage("assets/images/avatar.png") as ImageProvider,
              ),
            ),

            const SizedBox(width: 24),


            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    user.displayName,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),


                  Text(
                    "Student, designer",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondaryLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 16),


                  SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChangeNotifierProvider.value(
                              value: vm,
                              child: const EditProfileScreen(),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit_rounded, size: 20),
                      label: const Text("Edit profile"),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppThemeConstants.borderRadius),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }


  Widget _buildLoading() {
    return Row(
      children: [
        Container(
          width: 108,
          height: 108,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.gray200,
          ),
          child: const Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 24,
                width: 160,
                decoration: BoxDecoration(
                  color: AppColors.gray300,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                height: 18,
                width: 120,
                decoration: BoxDecoration(
                  color: AppColors.gray300,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildGuest() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          "Please login to see your profile",

          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}