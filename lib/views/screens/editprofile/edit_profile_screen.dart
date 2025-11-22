// screens/edit_profile_screen.dart
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img_lib;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/widgets/profilewidgets/account_creation_card.dart';
import '../../../core/utils/widgets/profilewidgets/edit_profile_text_field.dart';
import '../../../core/utils/widgets/profilewidgets/profile_photo_stack.dart';
import '../../../core/utils/widgets/profilewidgets/save_changes_button.dart';
import '../../../viewmodels/profile_viewmodel.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  File? _pickedImageFile;
  String? _newPhotoUrl;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final vm = Provider.of<ProfileViewModel>(context, listen: false);
    _nameController = TextEditingController(text: vm.user?.displayName ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<String?> _pickAndUploadImage() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1000,
      );

      if (picked == null) return null;

      final File originalFile = File(picked.path);


      final img_lib.Image? decoded = img_lib.decodeImage(await originalFile.readAsBytes());
      if (decoded == null) return null;

      // Resize + compress
      final img_lib.Image resized = img_lib.copyResize(decoded, width: 800);
      final compressedBytes = img_lib.encodeJpg(resized, quality: 80);

      final tempDir = await getTemporaryDirectory();
      final File tempFile = File(
          '${tempDir.path}/profile_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await tempFile.writeAsBytes(compressedBytes);

      setState(() => _pickedImageFile = tempFile);

      final userId = Provider.of<ProfileViewModel>(context, listen: false).user!.uid;

      // ✔ Correct Storage Path
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profileURL/$userId')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      print("📤 Uploading to Firebase Storage...");

      await storageRef.putFile(
        tempFile,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      final downloadURL = await storageRef.getDownloadURL();

      print("Uploaded: $downloadURL");
      return downloadURL;

    } catch (e) {
      print("Upload failed: $e");
      return null;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text("Edit Profile", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: Consumer<ProfileViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading || vm.user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = vm.user!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Profile Photo
                ProfilePhotoStack(
                  photoUrl: _newPhotoUrl ?? user.photoURL,
                  localImage: _pickedImageFile,
                  onAddPhoto: () async {
                    final url = await _pickAndUploadImage();
                    if (url != null) {
                      _newPhotoUrl = url;
                      setState(() {});
                    }
                  },
                ),
                const SizedBox(height: 40),


                EditProfileTextField(
                  label: "Display name",
                  initialValue: _nameController.text,
                  onChanged: (v) => _nameController.text = v,
                ),
                const SizedBox(height: 20),


                EditProfileTextField(
                  label: "Email address",
                  initialValue: user.email,
                  enabled: false,
                ),
                const SizedBox(height: 40),


                AccountCreationCard(creationDate: user.createdAt),
                const SizedBox(height: 40),


                SaveChangesButton(
                  onPressed: () async {
                    if (_nameController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Name cannot be empty")),
                      );
                      return;
                    }

                    try {

                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .update({
                        'displayName': _nameController.text.trim(),
                        if (_newPhotoUrl != null) 'photoURL': _newPhotoUrl!,
                      });


                      vm.updateCurrentUser(user.copyWith( displayName: _nameController.text.trim(), photoURL: _newPhotoUrl ?? user.photoURL, ));

                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Profile updated successfully!"),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      debugPrint("Firestore Update Error: $e");
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Failed to save: $e"), backgroundColor: Colors.red),
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}