import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasky_app/features/auth/data/model/user_model.dart';
import 'package:tasky_app/features/home/data/model/task_model.dart';

import '../../../../core/network/result.dart';

abstract class HomeFirebase {
  static CollectionReference<TaskModel> get _getCollection {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection(UserModel.collectionName)
        .doc(uid)
        .collection(TaskModel.collectionName)
        .withConverter<TaskModel>(
          fromFirestore: (snapshot, _) => TaskModel.fromJson(snapshot.data()!),
          toFirestore: (task, _) => task.toJson(),
        );
  }

  static Future<Result<TaskModel>> addTask(TaskModel task) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return ErrorState("User not logged in");
      final doc = _getCollection.doc();
      task.id = doc.id;
      await doc.set(task);
      return Success<TaskModel>(task);
    } on Exception catch (e) {
      return ErrorState<TaskModel>(e.toString());
    }
  }

  static Future<Result<List<TaskModel>>> getTasks(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));

    try {
      final querySnapshot = await _getCollection
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('date', isLessThan: Timestamp.fromDate(end))
          .orderBy('date')
          .orderBy('priority')
          .get();

      final listOfTasks = querySnapshot.docs.map((doc) => doc.data()).toList();

      return Success<List<TaskModel>>(listOfTasks);
    } catch (e) {
      return ErrorState<List<TaskModel>>(e.toString());
    }
  }

  static Future<void> isDoneHandle(TaskModel task) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection(UserModel.collectionName)
        .doc(uid)
        .collection(TaskModel.collectionName)
        .doc(task.id)
        .update({'is_done': !(task.isDone ?? false)});
  }

  static Future<void> updateTask(TaskModel task) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection(UserModel.collectionName)
        .doc(uid)
        .collection(TaskModel.collectionName)
        .doc(task.id)
        .update(task.toJson());
  }

  static Future<void> deleteTask(String id) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection(UserModel.collectionName)
        .doc(uid)
        .collection(TaskModel.collectionName)
        .doc(id)
        .delete();
  }
}
