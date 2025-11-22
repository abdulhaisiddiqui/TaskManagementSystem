
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img_lib;
import 'package:taskapp/data/models/user_model.dart';

class ProfileViewModel extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = true;
  bool _isSaving = false;
  File? _localPhotoPreview;

  late final TextEditingController nameController = TextEditingController();
  late final TextEditingController emailController = TextEditingController();


  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  File? get localPhotoPreview => _localPhotoPreview;

  ProfileViewModel() {
    loadUser();
  }

  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();

    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (doc.exists) {
        _user = UserModel.fromMap(firebaseUser.uid, doc.data()!);
      } else {

        _user = UserModel(
          uid: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName ?? 'User',
          photoURL: firebaseUser.photoURL,
          createdAt: DateTime.now(),
          notificationSettings: {},
          stats: {'completedTasks': 0},
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .set(_user!.toMap());
      }


      nameController.text = _user!.displayName;
      emailController.text = _user!.email;

    } catch (e) {
      debugPrint("Error loading user: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  void updateCurrentUser(UserModel user) {
    _user = user;
    notifyListeners();
  }
  Future<void> pickAndUploadPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    final file = File(picked.path);

    final ref = FirebaseStorage.instance
        .ref()
        .child('profile_photos/${_user!.uid}')
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

    try {
      await ref.putFile(
        file,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      final url = await ref.getDownloadURL();

      // Firestore update
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .update({'photoURL': url});

      _user = _user!.copyWith(photoURL: url);
      notifyListeners();
    } catch (e) {
      debugPrint("UPLOAD ERROR => $e");
    }
  }




  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    if (_user == null) return;

    final updated = _user!.copyWith(
      displayName: displayName,
      photoURL: photoURL,
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .update({
      if (displayName != null) 'displayName': displayName,
      if (photoURL != null) 'photoURL': photoURL,
    });

    _user = updated;
    notifyListeners();
  }

  Future<void> saveProfileChanges() async {
    _isSaving = true;
    notifyListeners();

    await FirebaseFirestore.instance.collection('users').doc(_user!.uid).update({
      'displayName': nameController.text.trim(),
    });

    _user = _user!.copyWith(
      displayName: nameController.text.trim(),
    );

    _isSaving = false;
    notifyListeners();
  }
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}