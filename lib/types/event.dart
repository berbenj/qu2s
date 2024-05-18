import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firedart/firestore/firestore.dart';
import '../services/database_service.dart';
import '../utils/platform.dart';

class EventData {
  final String title;
  DateTime start, end;
  final String parent;

  EventData({
    required this.title,
    required this.start,
    required this.end,
    required this.parent,
  });

  get map => {
        'title': title,
        'start': start,
        'end': end,
        'parent': parent,
      };
}

/// Event that has data to make scheduling easy
class SEvent extends EventData {
  DateTime availabilityStart, availabilityEnd;
  final Duration length;

  SEvent({
    required super.title,
    required super.start,
    required super.end,
    required super.parent,
    required this.availabilityStart,
    required this.availabilityEnd,
    required this.length,
  });

  /// duration of witch this event can be shifted at max if it is placed at the start of it's awailability
  /// this value can not be negative
  Duration get flexibilty {
    var dur = (availabilityEnd.difference(availabilityStart)) - length;
    if (dur < Duration.zero) {
      return Duration.zero;
    }
    return dur;
  }
}

class Event extends EventData {
  final String id;

  Duration get duration => end.difference(start);

  Event.fromMap(this.id, Map<String, dynamic> map)
      : super(
          title: map['title'],
          start: Q2Platform.isWindows ? map['start'] : map['start'].toDate(),
          end: Q2Platform.isWindows ? map['end'] : map['end'].toDate(),
          parent: map['parent'],
        );

  static delete({required String id}) async {
    if (DatabaseService.user != null) {
      if (Q2Platform.isWindows) {
        Firestore.instance
            .collection('users')
            .document(DatabaseService.user!.id)
            .collection('events')
            .document(id)
            .delete();
      } else {
        FirebaseFirestore.instance
            .collection('users')
            .doc(DatabaseService.user!.id)
            .collection('events')
            .doc(id)
            .delete();
      }
    }
  }

  static Future<Event?> add({
    required EventData evnetData,
  }) async {
    final Map<String, dynamic> data = evnetData.map;

    if (DatabaseService.user != null) {
      if (Q2Platform.isWindows) {
        var doc = await Firestore.instance
            .collection('users')
            .document(DatabaseService.user!.id)
            .collection('events')
            .add(data);
        return Event.fromMap(doc.id, doc.map);
      } else {
        var doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(DatabaseService.user!.id)
            .collection('events')
            .add(data);
        return Event.fromMap(doc.id, (await doc.get()).data()!);
      }
    }
    return null;
  }

  static edit({
    required Event event,
  }) async {
    final Map<String, dynamic> data = event.map;

    if (DatabaseService.user != null) {
      if (Q2Platform.isWindows) {
        Firestore.instance
            .collection('users')
            .document(DatabaseService.user!.id)
            .collection('events')
            .document(event.id)
            .update(data);
      } else {
        FirebaseFirestore.instance
            .collection('users')
            .doc(DatabaseService.user!.id)
            .collection('events')
            .doc(event.id)
            .update(data);
      }
    }
  }

  static Future<List<Event>> getAll() async {
    List<Event> data = [];

    if (DatabaseService.user != null) {
      if (Q2Platform.isWindows) {
        for (var element in (await Firestore.instance
                .collection('users')
                .document(DatabaseService.user!.id)
                .collection('events')
                .get())
            .reversed) {
          data.add(Event.fromMap(element.id, element.map));
        }
      } else {
        for (var element in (await FirebaseFirestore.instance
                .collection('users')
                .doc(DatabaseService.user!.id)
                .collection('events')
                .get())
            .docs
            .reversed) {
          data.add(Event.fromMap(element.id, element.data()));
        }
      }
    }

    return data;
  }

  static Future<List<Event>> getByDate(DateTime dateFrom, DateTime dateTo) async {
    List<Event> data = [];

    if (DatabaseService.user != null) {
      if (Q2Platform.isWindows) {
        for (var element in (await Firestore.instance
                .collection('users')
                .document(DatabaseService.user!.id)
                .collection('events')
                .where('start', isLessThanOrEqualTo: dateTo)
                .where('end', isGreaterThanOrEqualTo: dateFrom)
                .get())
            .reversed) {
          data.add(Event.fromMap(element.id, element.map));
        }
      } else {
        for (var element in (await FirebaseFirestore.instance
                .collection('users')
                .doc(DatabaseService.user!.id)
                .collection('events')
                .where('start', isLessThanOrEqualTo: dateTo)
                .where('end', isGreaterThanOrEqualTo: dateFrom)
                .get())
            .docs
            .reversed) {
          data.add(Event.fromMap(element.id, element.data()));
        }
      }
    }

    return data;
  }

  static Future<List<Event>> getByParent(String parent) async {
    List<Event> data = [];

    if (DatabaseService.user != null) {
      if (Q2Platform.isWindows) {
        for (var element in (await Firestore.instance
                .collection('users')
                .document(DatabaseService.user!.id)
                .collection('events')
                .where('parent', isEqualTo: parent)
                .get())
            .reversed) {
          data.add(Event.fromMap(element.id, element.map));
        }
      } else {
        for (var element in (await FirebaseFirestore.instance
                .collection('users')
                .doc(DatabaseService.user!.id)
                .collection('events')
                .where('parent', isEqualTo: parent)
                .get())
            .docs
            .reversed) {
          data.add(Event.fromMap(element.id, element.data()));
        }
      }
    }

    return data;
  }
}
