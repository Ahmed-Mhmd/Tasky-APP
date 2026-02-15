import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  static const String collectionName = "Tasks";
  TaskModel({
    this.id,
    this.title,
    this.description,
    this.priority,
    required this.date,
    this.isDone,
  });
  String? id;
  String? title;
  String? description;
  int? priority;
  DateTime date;
  bool? isDone;

  //toJson
  Map<String, dynamic> toJson() {
    // final pureDate = DateTime(date.year, date.month, date.day);

    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority,
      // 'date': Timestamp.fromDate(pureDate),
      'date': Timestamp.fromDate(date),
      'is_done': isDone,
    };
  }

  //fromJson
  TaskModel.fromJson(Map<String, dynamic> json)
    : this(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        priority: int.tryParse(json['priority'].toString()) ?? 0,
        
        date: (json['date'] as Timestamp).toDate(),
        isDone: json['is_done'] ?? false,
      );
  DateTime get normalizedDate => DateTime(date.year, date.month, date.day);
}
