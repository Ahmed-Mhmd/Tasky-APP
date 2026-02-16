// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/network/result.dart';
import '../model/user_model.dart';

abstract class AuthFunctions {
  static CollectionReference<UserModel> get _getCollection {
    return FirebaseFirestore.instance
        .collection(UserModel.collectionName)
        .withConverter<UserModel>(
          fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
          toFirestore: (user, _) => user.toJson(),
        );
  }

  static Future<void> addUser(UserModel user) async {
    try {
      await _getCollection.doc(user.uid).set(user);
    } catch (e) {
      throw 'Error From adding user: $e';
    }
  }

  static Future<Result<String>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Success<String>(user.user?.uid ?? '');
    } on FirebaseAuthException catch (e) {
      String message = "Login failed";

      switch (e.code) {
        case 'invalid-credential':
        case 'wrong-password':
        case 'user-not-found':
          message = "Incorrect email or password";
          break;

        case 'invalid-email':
          message = "Invalid email format";
          break;

        case 'too-many-requests':
          message = "Too many attempts, try again later";
          break;
      }

      return ErrorState<String>(message);
    }
  }

  static Future<Result<UserModel>> registerUser({
    required UserModel user,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: user.email ?? '',
            password: user.password ?? '',
          );

      // final token = credential.user?.uid;
      final token = FirebaseAuth.instance.currentUser?.uid;
      user.uid = token ?? '';
      await addUser(user);
      return Success(user);
    } on FirebaseAuthException catch (e) {
      String message = 'Registration failed, try again';

      switch (e.code) {
        case 'email-already-in-use':
          message = "Email already registered";
          break;

        case 'weak-password':
          message = "Password must be at least 6 characters";
          break;

        case 'invalid-email':
          message = "Invalid email format";
          break;
        case 'operation-not-allowed':
          message = "Registration is currently disabled";
          break;
      }

      return ErrorState(message);
    }
  }
}
