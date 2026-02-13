import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasky_app/features/auth/data/model/user_model.dart';
import 'package:tasky_app/features/home/data/model/task_model.dart';

import '../../../../core/network/result.dart';

abstract class HomeFirebase {
  // static CollectionReference<TaskModel> get _getCollection {
  //   final uid = FirebaseAuth.instance.currentUser!.uid;
  //   return FirebaseFirestore.instance
  //       .collection(UserModel.collectionName)
  //       .withConverter<UserModel>(
  //         fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
  //         toFirestore: (user, _) => user.toJson(),
  //       )
  //       .doc(uid)
  //       .collection(TaskModel.collectionName)
  //       .withConverter<TaskModel>(
  //         fromFirestore: (snapshot, _) => TaskModel.fromJson(snapshot.data()!),
  //         toFirestore: (task, _) => task.toJson(),
  //       );
  // }

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
      // await _getCollection.add(task);
      final doc = _getCollection.doc();
      task.id = doc.id;
      await doc.set(task);
      return Success<TaskModel>(task);
    } on Exception catch (e) {
      return ErrorState<TaskModel>(e.toString());
    }
  }

  static Future<Result<List<TaskModel>>> getTasks(DateTime date) async {
    final pureDate = DateTime(date.year, date.month, date.day);
    try {
      final querySnapshot = await _getCollection
          .where('date', isEqualTo: Timestamp.fromDate(pureDate))
          
          .orderBy('priority', descending: false)
          .get();

      final docs = querySnapshot.docs;

      final listOfTasks = docs.map<TaskModel>((doc) => doc.data()).toList();

      return Success<List<TaskModel>>(listOfTasks);
    } catch (e) {
      return ErrorState<List<TaskModel>>(e.toString());
    }
  }

  // final tasks = querySnapshot.docs.map<TaskModel>((doc) => doc.data()).toList();

  static Future<void> isDoneHandle(TaskModel task) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection(UserModel.collectionName)
        .doc(uid)
        .collection(TaskModel.collectionName)
        .doc(task.id)
        .update({'is_done': !(task.isDone ?? false)});
  }
}
