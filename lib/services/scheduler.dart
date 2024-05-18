import 'package:dart_date/dart_date.dart';

import '../types/event.dart';
import '../types/task.dart';

schedule() async {
  final tasks = await Task.getAll();
  final dbEvents = await Event.getAll();
  List<SEvent> events = [];

  for (Task task in tasks) {
    if (task.status != TaskStatus.done && task.status != TaskStatus.inProgress) {
      events.add(
        SEvent(
          title: task.title,
          start: task.startDate,
          end: task.endDate,
          parent: task.id,
          availabilityStart: task.startDate,
          availabilityEnd: task.endDate,
          length: task.duration,
        ),
      );
    }
  }

  List<SEvent> calendar = [];
  List<SEvent> pastEvents = [];
  List<SEvent> unplacedEvents = [];

  var now = DateTime.now();

  for (var event in events) {
    if ((event.availabilityEnd.subtract(event.length)).isPast) {
      pastEvents.add(event);
    }

    // earliest an event can start is now
    if (event.availabilityStart.isPast) {
      event.availabilityStart = now;
    }
  }

  // sort items absed on smallest flexibility
  // events.shuffle(); // unnecessary for now
  events.sort((a, b) {
    return a.flexibilty.compareTo(b.flexibilty);
  });
  // events.sort((a, b) => b.priority.compareTo(a.priority));

  // place all events or declare them unplacable
  for (;;) {
    if (events.isEmpty) {
      break;
    }
    var event = events.removeAt(0);

    // if event connot be placed than don't try to
    if (pastEvents.contains(event)) continue;

    bool success = placeEventFirstOpenPosition(event, calendar);
    if (success) {
      continue;
    }

    success = placeEventCheckIfShiftPossible(event, calendar);
    if (success) {
      continue;
    }

    success = placeEventCheckIfSwapPossible(event, calendar);
    if (success) {
      continue;
    }

    unplacedEvents.add(event);
  }

  for (var event in calendar) {
    var task = tasks.firstWhere((element) => element.id == event.parent);
    if (!task.status.hasEvent) {
      // add new event in db
      var newEvent = await Event.add(
        evnetData: EventData(title: event.title, start: event.start, end: event.end, parent: event.parent),
      );

      if (newEvent != null) {
        // update task
        task.events = [newEvent.id];
        task.status = TaskStatus.todo;
        Task.edit(task: task);
      }
    } else if (task.status.hasEvent) {
      final thisEvent = dbEvents.firstWhere((element) => element.parent == event.parent);
      // update old event time
      thisEvent.start = event.start;
      thisEvent.end = event.end;
      Event.edit(event: thisEvent);
    }
  }

  for (var event in unplacedEvents) {
    var task = tasks.firstWhere((element) => element.id == event.parent);
    // if task wasn't scheduled to begin with
    if (task.status == TaskStatus.notScheduled) {
      // update task status
      task.status = TaskStatus.unplacable;
      Task.edit(task: task);
    }
    // if there is an event associated with task
    else if (task.status != TaskStatus.unplacable) {
      // delete event
      Event.delete(id: task.events[0]);
      // update task status
      task.status = TaskStatus.unplacable;
      Task.edit(task: task);
    }
  }

  for (var event in pastEvents) {
    var task = tasks.firstWhere((element) => element.id == event.parent);
    // if there is an event associated with task
    if (task.status.hasEvent) {
      // delete event
      Event.delete(id: task.events[0]);
    }
    // update task status
    task.status = TaskStatus.pastDueDate;
    Task.edit(task: task);
  }
}

bool placeEventCheckIfSwapPossible(SEvent event, List<SEvent> calendar) {
  // todo: implement this
  return false;
}

bool placeEventCheckIfShiftPossible(SEvent event, List<SEvent> calendar) {
  // todo: implement this

  /// search for all end and start points from [calendar] that are whitin the [event]'s availability → expansion point (ep)
  ///   after found one only the same type should be search for
  ///   (eg.: if the first ep found is and end point then only search for end points)
  /// search free space before and after ep
  /// search possible free space moving events along, forward and backwards
  ///   check how far the next event can be moved maxed based on the one after that one recoursively
  /// is the space available enough?
  /// if yes than move everything the minimum amount, then place [event]
  /// otherwise do nothing and exit

  return false;
}

/// Tries to place [event] to the first position where it fits
/// without moving other events in the [calendar] around.
/// Returns true if it managed to place event, otherwise returns false.
bool placeEventFirstOpenPosition(SEvent event, List<SEvent> calendar) {
  void insertIntoCalendar(SEvent event) {
    calendar.insert(
      calendar.indexWhere((element) => event.start.isBefore(element.start)) == -1
          ? calendar.length
          : calendar.indexWhere((element) => event.start.isBefore(element.start)),
      event,
    );
  }

  /// find the first event in calendar that has a placement that touches [event]'s availability
  int otherIndex = -1;
  for (var i = 0; i < calendar.length; i++) {
    if (!calendar[i].end.isBefore(event.availabilityStart) && calendar[i].end.isBefore(event.availabilityEnd)) {
      otherIndex = i;
      break;
    }
  }

  /// if there is no event overleaping in calendar than check if there is enough space to place event and place it, or exit
  if (otherIndex == -1) {
    event.start = event.availabilityStart;
    event.end = event.start.add(event.length);
    if (calendar.isEmpty) {
      calendar.add(event);
    } else {
      insertIntoCalendar(event);
    }
    return true;
  }

  if (calendar[otherIndex].start.isAfter(event.availabilityStart)) {
    /// check if it fits before it
    var availableSpaceBefore = calendar[otherIndex].start.difference(event.availabilityStart);
    if (availableSpaceBefore > event.length) {
      event.start = event.availabilityStart;
      event.end = event.start.add(event.length);
      insertIntoCalendar(event);
      return true;
    }
  }

  for (;;) {
    /// if [other] is the last event in calendar, then check if there is place to place [event],
    /// place it if possible, exit if not
    if (otherIndex == calendar.length - 1) {
      var start = calendar[otherIndex].end;
      if (event.availabilityStart.isAfter(calendar[otherIndex].end)) {
        start = event.availabilityStart;
      }
      var end = start.add(event.length);
      if (!end.isAfter(event.availabilityEnd)) {
        event.start = start;
        event.end = end;
        insertIntoCalendar(event);
        return true;
      }
      return false;
    }

    /// 3. if between [other] and the event one after that in the calendar,
    /// there is enough space to place event, then place it
    {
      var start = calendar[otherIndex].end;
      var end = calendar[otherIndex + 1].start;
      if (end.isAfter(event.availabilityEnd)) {
        end = event.availabilityEnd;
      }
      var availableSpace = end.difference(start);
      if (availableSpace >= event.length) {
        event.start = start; // todo: check if this is correct, and should not be `max(start, event.availabilityStart)`
        event.end = start.add(event.length);
        insertIntoCalendar(event);
        return true;
      }
    }

    /// 4. if there is not then increment [other]
    otherIndex++;

    /// 5. if [other] is past [event]'s availability then exit
    if (calendar[otherIndex].start.isAfter(event.availabilityEnd)) {
      return false;
    }
  }
}
