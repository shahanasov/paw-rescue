import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:paw_catcher_admin/services/model/model.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signInWithEmail(
      {required String email, required String password}) async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
  }

  signOut() async {
    await auth.signOut();
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    
  }) async {
    // ref.read(authLoadingProvider.notifier).state = true;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      String? userId = userCredential.user?.uid;
      if (userId != null) {
        final userdetail = FirebaseFirestore.instance.collection("Admin");
        final newUser = AdminModel(email: email, name: name,authId: userId).toJson();
        userdetail.doc(userId).set(newUser);
      }
    } catch (e) {
      log("Error $e");
    } finally {
      // ref.read(authLoadingProvider.notifier).state = false;
    }
  }
}