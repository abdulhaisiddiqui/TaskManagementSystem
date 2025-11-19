// views/screens/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/widgets/profilewidgets/build_Menu_Item.dart';
import '../../../core/utils/widgets/profilewidgets/profile_header.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import '../../../viewmodels/profile_viewmodel.dart';
import '../loginsignup/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: Text("Profile", style: Theme.of(context).textTheme.headlineMedium),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const ProfileHeader(),

              const SizedBox(height: 30),

              Consumer<ProfileViewModel>(
                builder: (context, vm, child) {
                  final tasks = vm.user?.stats['completedTasks'] ?? 103;

                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.primary.withOpacity(0.8)
                      ]),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Amazing!", style: const TextStyle(color: Colors.white, fontSize: 18)),
                        const SizedBox(height: 8),
                        Text(
                          "You have completed\n$tasks task${tasks > 1 ? 's' : ''}!",
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text("Details"),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),
               BuildMenuItem(icon: Icons.person_outline, title: "Account information", isLogout: false),
               BuildMenuItem(icon: Icons.settings_outlined, title: "Settings", isLogout: false),
               BuildMenuItem(icon: Icons.logout, title: "Log out", isLogout: true,callback: (){
                 AuthViewModel().logout(context);
                 Navigator.pushReplacement(
                   context,
                   MaterialPageRoute(builder: (_) => LoginScreen()),
                 );
               },),
            ],
          ),
        ),
      ),
    );
  }
}