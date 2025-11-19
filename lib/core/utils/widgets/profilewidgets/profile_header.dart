// views/screens/profile/widgets/profile_header.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../viewmodels/profile_viewmodel.dart';
import '../../../../views/screens/editprofile/edit_profile_screen.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, vm, child) {
        if (vm.isLoading) {
          return _buildLoading();
        }

        if (vm.user == null) {
          return _buildGuest();
        }

        final user = vm.user!;

        return Row(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: user.photoURL != null && user.photoURL!.isNotEmpty
                  ? NetworkImage(user.photoURL!)
                  : const AssetImage("assets/images/avatar.png") as ImageProvider,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.displayName,
                    style: Theme.of(context).textTheme.headlineSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Student, designer",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChangeNotifierProvider.value(
                            value: vm,
                            child: EditProfileScreen(),
                          ),
                        ),
                      );
                    },
                    child: const Text("Edit profile"),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoading() => const Row(
    children: [
      CircleAvatar(radius: 50, child: CircularProgressIndicator()),
      SizedBox(width: 20),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, height: 20, child: LinearProgressIndicator()),
          SizedBox(height: 8),
          SizedBox(width: 80, height: 16, child: LinearProgressIndicator()),
        ],
      ),
    ],
  );

  Widget _buildGuest() => const Text("Please login to see profile");
}