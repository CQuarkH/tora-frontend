import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tora_frontend/features/child/models/calendar.dart';
import 'package:tora_frontend/features/child/models/child.dart';
import 'package:tora_frontend/features/child/screens/calendar/child_daydetail_screen.dart';

class ChildCalendarScreen extends HookWidget {
  const ChildCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool canOpen(DateTime date) {
      final now = DateTime.now();
      return date.isAfter(now) ||
          date.isAtSameMomentAs(DateTime(now.year, now.month, now.day));
    }

    return CalendarControllerProvider(
      controller: EventController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: MonthView(
            useAvailableVerticalSpace: true,
            controller: EventController(),
            cellAspectRatio: 1.5,
            onCellTap: (events, date) => canOpen(date)
                ? Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ChildDayDetailScreen(
                        currentChild: Child.createSampleChild(),
                        todayCalendar: Calendar.createSampleCalendar(
                          Child.createSampleChild().id,
                          date: date,
                        ),
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
