import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tora_frontend/features/child/models/calendar.dart';
import 'package:tora_frontend/features/child/models/child.dart';
import 'package:tora_frontend/features/child/screens/calendar/child_daydetail_screen.dart';

class ChildCalendarScreen extends HookWidget {
  const ChildCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inicializar los datos de localización española
    useEffect(() {
      initializeDateFormatting('es_ES', null);
      return null;
    }, []);

    bool canOpen(DateTime date) {
      final now = DateTime.now();
      return date.isAfter(now) ||
          date.isAtSameMomentAs(DateTime(now.year, now.month, now.day));
    }

    return CalendarControllerProvider(
      controller: EventController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // Configurar localización para español
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('es', 'ES')],
        locale: const Locale('es', 'ES'),
        home: Scaffold(
          body: MonthView(
            startDay: WeekDays.monday,
            headerBuilder: (date) {
              final formatter = DateFormat('MMMM yyyy', 'es_ES');
              final monthYear = formatter.format(date);

              return Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  // Capitalizar la primera letra del mes
                  monthYear.substring(0, 1).toUpperCase() +
                      monthYear.substring(1),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              );
            },
            // Builder personalizado para los días de la semana en español (comenzando desde lunes)
            weekDayBuilder: (dayIndex) {
              final weekDays = [
                'Lun',
                'Mar',
                'Mié',
                'Jue',
                'Vie',
                'Sáb',
                'Dom',
              ];
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.deepPurple[50],
                  border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
                ),
                child: Center(
                  child: Text(
                    weekDays[dayIndex % 7],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepPurple[700],
                    ),
                  ),
                ),
              );
            },
            headerStyle: HeaderStyle(
              titleAlign: TextAlign.center,
              decoration: BoxDecoration(color: Colors.deepPurple[100]),
            ),
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
