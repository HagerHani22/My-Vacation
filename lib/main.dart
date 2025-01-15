import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vacation/layout/startpage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vacation/shared/theme/theme.dart';

import 'modules/clock/cubit/clock_permission_cubit.dart';
import 'modules/days/cubit/day_off_cubit.dart';
import 'modules/substitute_day/cubit/sub_day_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DayOffCubit()..createDatabase(),),
        BlocProvider(create: (context) => ClockPermissionCubit()..createDatabase(),),
        BlocProvider(create: (context) => SubstituteDayCubit()..createDatabase(),),
      ],
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: MaterialApp(
          title: 'أجازاتي',
          theme:lightTheme,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate, // Add this line

          ],
          supportedLocales: const [
            Locale('ar', 'EG'), // Arabic (United Arab Emirates)
          ],
          home:  const HomePage(),
        ),
      ),
    );
  }
}

