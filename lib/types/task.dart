import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedart/firestore/firestore.dart';
import '../services/database_service.dart';
import '../utils/platform.dart';

class Task {
  String id;
  String title;
  String? description;
  DateTime startDate;
  DateTime endDate;
  Duration duration;
  int depth;
  List<String> parents;
  List<String> subtasks;
  List<String> events;
  TaskStatus status;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.startDate,
    required this.endDate,
    required this.duration,
    required this.depth,
    required this.parents,
    required this.subtasks,
    required this.events,
    required this.status,
  });

  String get durationAsString {
    if (duration == Duration.zero) return '0h';
    Duration d = duration.abs();
    String res = '';

    if (d.inDays > 0) {
      res += '${d.inDays}d ';
      d -= Duration(days: d.inDays);
    }
    if (d.inHours > 0) {
      res += '${d.inHours}h ';
      d -= Duration(hours: d.inHours);
    }
    if (d.inMinutes > 0) {
      res += '${d.inMinutes}m ';
      d -= Duration(minutes: d.inMinutes);
    }
    if (d.inSeconds > 0) {
      res += '${d.inSeconds}s ';
    }
    return res;
  }

  Task.fromMap(this.id, Map<String, dynamic> map)
      : title = map['title'] as String,
        description = map['description'] as String?,
        startDate = Q2Platform.isWindows ? map['startDate'] : map['startDate']?.toDate(),
        endDate = Q2Platform.isWindows ? map['endDate'] : map['endDate']?.toDate(),
        duration = Duration(seconds: map['duration']),
        depth = map['depth'] as int,
        parents = List<String>.from(map['parents']),
        subtasks = List<String>.from(map['subtasks']),
        events = List<String>.from(map['events']),
        status = TaskStatus.values[map['status']];

  get map => {
        'title': title,
        'description': description,
        'startDate': startDate,
        'endDate': endDate,
        'duration': duration.inSeconds,
        'depth': depth,
        'parents': parents,
        'subtasks': subtasks,
        'events': events,
        'status': status.index,
      };

  static delete({required String id}) async {
    if (DatabaseService.user != null) {
      if (Q2Platform.isWindows) {
        Firestore.instance
            .collection('users')
            .document(DatabaseService.user!.id)
            .collection('tasks')
            .document(id)
            .delete();
      } else {
        FirebaseFirestore.instance
            .collection('users')
            .doc(DatabaseService.user!.id)
            .collection('tasks')
            .doc(id)
            .delete();
      }
    }
  }

  static add({
    required String title,
    String? description,
    required DateTime startDate,
    required DateTime endDate,
    required Duration duration,
    required int depth,
    required List<String> parents,
  }) async {
    final Map<String, dynamic> data = {
      'title': title,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'duration': duration.inSeconds,
      'depth': depth,
      'parents': parents,
      'subtasks': <String>[],
      'events': <String>[],
      'status': TaskStatus.notScheduled.index,
    };

    if (DatabaseService.user != null) {
      if (Q2Platform.isWindows) {
        Firestore.instance.collection('users').document(DatabaseService.user!.id).collection('tasks').add(data);
      } else {
        FirebaseFirestore.instance.collection('users').doc(DatabaseService.user!.id).collection('tasks').add(data);
      }
    }
  }

  static edit({
    required Task task,
  }) async {
    final Map<String, dynamic> data = task.map;

    if (DatabaseService.user != null) {
      if (Q2Platform.isWindows) {
        Firestore.instance
            .collection('users')
            .document(DatabaseService.user!.id)
            .collection('tasks')
            .document(task.id)
            .update(data);
      } else {
        FirebaseFirestore.instance
            .collection('users')
            .doc(DatabaseService.user!.id)
            .collection('tasks')
            .doc(task.id)
            .update(data);
      }
    }
  }

  static Future<List<Task>> getAll() async {
    List<Task> data = [];

    if (DatabaseService.user != null) {
      if (Q2Platform.isWindows) {
        for (var element in (await Firestore.instance
                .collection('users')
                .document(DatabaseService.user!.id)
                .collection('tasks')
                .get())
            .reversed) {
          data.add(Task.fromMap(element.id, element.map));
        }
      } else {
        for (var element in (await FirebaseFirestore.instance
                .collection('users')
                .doc(DatabaseService.user!.id)
                .collection('tasks')
                .get())
            .docs
            .reversed) {
          data.add(Task.fromMap(element.id, element.data()));
        }
      }
    }

    return data;
  }

  static Future<List<Task>> getByDepth(int depth) async {
    List<Task> data = [];

    if (DatabaseService.user != null) {
      if (Q2Platform.isWindows) {
        for (var element in (await Firestore.instance
                .collection('users')
                .document(DatabaseService.user!.id)
                .collection('tasks')
                .where('depth', isGreaterThanOrEqualTo: depth, isLessThanOrEqualTo: depth + 1)
                .get())
            .reversed) {
          data.add(Task.fromMap(element.id, element.map));
        }
      } else {
        for (var element in (await FirebaseFirestore.instance
                .collection('users')
                .doc(DatabaseService.user!.id)
                .collection('tasks')
                .where('depth', isGreaterThanOrEqualTo: depth, isLessThanOrEqualTo: depth + 1)
                .get())
            .docs
            .reversed) {
          data.add(Task.fromMap(element.id, element.data()));
        }
      }
    }

    return data;
  }
}

enum TaskStatus {
  notScheduled,

  // normal state
  todo,
  inProgress,
  done,

  // error states
  unplacable,
  pastDueDate,
}

extension TaskStatusExtension on TaskStatus {
  bool get hasEvent => this == TaskStatus.todo || this == TaskStatus.inProgress || this == TaskStatus.done;
}
