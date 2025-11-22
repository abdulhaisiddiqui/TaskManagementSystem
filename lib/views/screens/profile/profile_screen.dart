// views/screens/profile/profile_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/widgets/profilewidgets/build_Menu_Item.dart';
import '../../../core/utils/widgets/profilewidgets/profile_header.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import '../../../viewmodels/profile_viewmodel.dart';
import '../editprofile/edit_profile_screen.dart';
import '../loginsignup/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String? userId = FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context) {



    Stream<DocumentSnapshot<Map<String, dynamic>>> getUserStream(String uid) {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .snapshots();
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      // appBar: AppBar(
      //   title: Text("Profile", style: Theme.of(context).textTheme.headlineMedium),
      //   backgroundColor: Colors.transparent,
      //   actions: [
      //     Icon(Icons.edit_note_outlined)
      //   ],
      //   elevation: 0,
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 30,),
            Consumer<ProfileViewModel>(builder: (context,vm,child){
              return Align(
                alignment: Alignment.centerRight,
                child: IconButton(onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChangeNotifierProvider.value(
                        value: vm,
                        child: const EditProfileScreen(),
                      ),
                    ),
                  );
                }, icon: Icon(Icons.edit_note_outlined,size: 30,)),
              );
            }),
            const SizedBox(height: 12),
            const ProfileHeader(),

            const SizedBox(height: 12),

            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(

              stream: getUserStream(userId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  return const Text("No data found");
                }

                final userData = snapshot.data!.data()!;
                final tasks = userData['stats']?['completedTasks'] ?? 103;

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
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: Colors.white),
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


            const SizedBox(height: 12),
             BuildMenuItem(icon: Icons.person_outline, title: "Account information", isLogout: false),
             BuildMenuItem(icon: Icons.settings_outlined, title: "Settings", isLogout: false),
             BuildMenuItem(icon: Icons.logout, title: "Log out", isLogout: true,callback: (){
               AuthViewModel().logout(context);
               Navigator.pushReplacement(
                 context,
                 MaterialPageRoute(builder: (_) => LoginScreen()),
               );
             },),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}