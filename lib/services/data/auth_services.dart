import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paw_catcher_admin/services/model/model.dart';

final authLoadingProvider = StateProvider<bool>((ref) => false);

// class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String?> signInWithEmail({
    required String email,
    required String password,
    required WidgetRef ref,
  }) async {
    ref.read(authLoadingProvider.notifier).state = true;
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return getFirebaseAuthErrorMessage(e.code);
    } catch (e) {
      log("Unexpected error: $e");
      return "An unexpected error occurred. Please try again.";
    } finally {
      ref.read(authLoadingProvider.notifier).state = false;
    }
  }

  signOut() async {
    await auth.signOut();
  }

  Future<String?> signUp({
    required String email,
    required String password,
    required String name,
    required WidgetRef ref,
    required String phoneNumber
  }) async {
    ref.read(authLoadingProvider.notifier).state = true;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      String? userId = userCredential.user?.uid;
      if (userId != null) {
        final userdetail = FirebaseFirestore.instance.collection("Admin");
        final newUser =
            AdminModel(email: email, name: name, authId: userId,phoneNumber: phoneNumber).toJson();
        userdetail.doc(userId).set(newUser);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      return getFirebaseAuthErrorMessage(e.code);
    } catch (e) {
      log("Error $e");
      return "An unexpected error occurred. Please try again.";
    } finally {
      ref.read(authLoadingProvider.notifier).state = false;
    }
  }

  final userDetailsProvider =
      FutureProvider<AdminModel?>((ref) async {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      throw Exception('User ID is null');
    }

    try {
      final userDetailDoc = await FirebaseFirestore.instance
          .collection('Admin')
          .doc(userId)
          .get();

      if (userDetailDoc.exists) {
        return AdminModel.fromSnapshot(userDetailDoc);
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      log(e.code);
      return null;
    }
  }
  );

  /// **Error Handling**
  String getFirebaseAuthErrorMessage(String errorCode) {
    log("Firebase Auth Error Code: $errorCode");
    switch (errorCode) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Try again.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'invalid-email':
        return 'Invalid email format.';
      case 'weak-password':
        return 'Password should be at least 6 characters long.';
      case 'too-many-requests':
        return 'Too many failed attempts. Try again later.';
      case 'network-request-failed':
        return 'Check your internet connection.';
      case 'id-token-expired':
        return 'Your session has expired. Please log in again.';
      case 'id-token-revoked':
        return 'Your session has been revoked. Please log in again.';
      case 'claims-too-large':
        return 'Custom claims payload is too large.';
      case 'internal-error':
        return 'Internal server error. Please try again later.';
      case 'invalid-credential':
        return 'Invalid credentials. Check your details and try again.';
      case 'operation-not-allowed':
        return 'This sign-in method is disabled. Contact support.';
      case 'phone-number-already-exists':
        return 'This phone number is already in use.';
      case 'project-not-found':
        return 'No Firebase project found. Please check your configuration.';
      case 'session-cookie-expired':
        return 'Session expired. Please log in again.';
      case 'session-cookie-revoked':
        return 'Session revoked. Please log in again.';
      case 'unauthorized-continue-uri':
        return 'Unauthorized domain. Check Firebase Console settings.';
      case 'uid-already-exists':
        return 'The provided UID is already in use.';
      case 'The email address is badly formatted':
        return 'The email address is badly formatted';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
// }
