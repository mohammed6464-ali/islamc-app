import 'package:add_2_calendar/add_2_calendar.dart';

class DeviceCalendarService {
  const DeviceCalendarService();

  Future<bool> addAllDayEvent({
    required String title,
    required DateTime date,
    String? notes,
  }) {
    final DateTime start = DateTime(date.year, date.month, date.day);
    return Add2Calendar.addEvent2Cal(
      Event(
        title: title,
        description: notes ?? '',
        startDate: start,
        endDate: start.add(const Duration(days: 1)),
        allDay: true,
      ),
    );
  }
}
