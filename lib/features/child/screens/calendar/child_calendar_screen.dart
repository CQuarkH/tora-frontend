// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tora_frontend/core/theme/tora_theme.dart';
import 'package:tora_frontend/features/auth/services/auth_service.dart';
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

    bool isPastDay(DateTime date) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      return date.isBefore(today);
    }

    return FutureBuilder(
      future: () async {
        final authService = AuthService();
        final user = await authService.getCurrentUser();
        return user;
      }(),

      builder: (context, asyncSnapshot) {
        return CalendarControllerProvider(
          controller: EventController(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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
                backgroundColor: ToraTheme.pureWhite,
                body: MonthView(
                  startDay: WeekDays.monday,

                  // Header personalizado con tema aplicado
                  headerBuilder: (date) {
                    final formatter = DateFormat('MMMM yyyy', 'es_ES');
                    final monthYear = formatter.format(date);

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 12,
                      ),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            ToraTheme.mintGreen.withOpacity(0.9),
                            ToraTheme.softBlue.withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: ToraTheme.lightGray.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        // Capitalizar la primera letra del mes
                        monthYear.substring(0, 1).toUpperCase() +
                            monthYear.substring(1),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                          letterSpacing: 0.5,
                        ),
                      ),
                    );
                  },

                  // Builder personalizado para los días de la semana
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
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          weekDays[dayIndex % 7],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: ToraTheme.mediumText,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    );
                  },

                  // Builder personalizado para las celdas de días
                  cellBuilder: (date, events, isToday, isInMonth, isSelected) {
                    final isCurrentDay = isToday;
                    final isPast = isPastDay(date);
                    final canOpenDay = canOpen(date);

                    Color backgroundColor;
                    Color textColor;
                    Color borderColor = Colors.transparent;
                    double elevation = 0;

                    if (isCurrentDay) {
                      // Día actual - amarillo cálido
                      backgroundColor = ToraTheme.warmYellow;
                      textColor = ToraTheme.darkText;
                      borderColor = ToraTheme.warmYellow.withOpacity(0.5);
                      elevation = 4;
                    } else if (isPast) {
                      // Días pasados - más oscuros y desaturados
                      backgroundColor = ToraTheme.lightText.withOpacity(0.3);
                      textColor = ToraTheme.lightText;
                    } else if (!isInMonth) {
                      // Días fuera del mes actual
                      backgroundColor = ToraTheme.pureWhite.withOpacity(0.3);
                      textColor = ToraTheme.lightText.withOpacity(0.5);
                    } else {
                      // Días futuros normales
                      backgroundColor = ToraTheme.pureWhite;
                      textColor = ToraTheme.darkText;
                      borderColor = ToraTheme.lightGray.withOpacity(0.3);
                    }

                    return Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: borderColor,
                          width: isCurrentDay ? 2 : 1,
                        ),
                        boxShadow: elevation > 0
                            ? [
                                BoxShadow(
                                  color: ToraTheme.warmYellow.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: canOpenDay
                              ? () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => ChildDayDetailScreen(
                                        currentChild:
                                            asyncSnapshot.data as Child,
                                        todayCalendar:
                                            Calendar.createSampleCalendar(
                                              (asyncSnapshot.data as Child).id,
                                              date: date,
                                            ),
                                      ),
                                    ),
                                  );
                                }
                              : null,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Número del día
                                Text(
                                  date.day.toString(),
                                  style: TextStyle(
                                    fontSize: isCurrentDay ? 18 : 16,
                                    fontWeight: isCurrentDay
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                    color: textColor,
                                    letterSpacing: 0.2,
                                  ),
                                ),

                                // Indicador de eventos (si los hay)
                                if (events.isNotEmpty)
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: events.take(3).map((event) {
                                        return Container(
                                          width: 6,
                                          height: 6,
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 1,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isPast
                                                ? ToraTheme.lightText
                                                      .withOpacity(0.5)
                                                : ToraTheme.mintGreen,
                                            shape: BoxShape.circle,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),

                                // Indicador visual para día actual
                                if (isCurrentDay)
                                  Container(
                                    margin: const EdgeInsets.only(top: 2),
                                    width: 20,
                                    height: 2,
                                    decoration: BoxDecoration(
                                      color: ToraTheme.darkText,
                                      borderRadius: BorderRadius.circular(1),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },

                  headerStyle: const HeaderStyle(
                    titleAlign: TextAlign.center,
                    decoration: BoxDecoration(color: Colors.transparent),
                  ),

                  useAvailableVerticalSpace: true,
                  controller: EventController(),
                  cellAspectRatio: 1.2,

                  // Personalizar la apariencia general del calendario
                  borderColor: ToraTheme.lightGray.withOpacity(0.2),
                  borderSize: 0.5,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
