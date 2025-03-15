import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';
import 'package:vacation/layout/startpage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vacation/shared/theme/theme.dart';

import 'modules/attendance/cubit.dart';
import 'modules/clock/cubit/clock_permission_cubit.dart';
import 'modules/days/cubit/day_off_cubit.dart';
import 'modules/substitute_day/cubit/sub_day_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EasyLoading.init();
  // await checkForUpdates();
  runApp(MyApp());
}
//
// bool _updateInProgress = false; // Prevent multiple update checks
//
// Future<void> checkForUpdates() async {
//   if (_updateInProgress) return; // Avoid duplicate update checks
//   _updateInProgress = true;
//
//   final shorebirdCodePush = ShorebirdCodePush();
//
//   try {
//     final prefs = await SharedPreferences.getInstance();
//
//     // Check if the app was updated before it was last closed
//     bool wasUpdateDownloaded = prefs.getBool("update_downloaded") ?? false;
//
//     if (wasUpdateDownloaded) {
//       print("🔄 Update was downloaded earlier. Restarting app now...");
//       prefs.setBool("update_downloaded", false); // Reset flag
//       Restart.restartApp(); // Restart the app to apply update
//       return;
//     }
//
//     // Check if a new patch is available
//     final isUpdateAvailable = await shorebirdCodePush.isNewPatchAvailableForDownload();
//
//     if (isUpdateAvailable) {
//       print("📥 New update available, downloading...");
//
//       // Download the update
//       await shorebirdCodePush.downloadUpdateIfAvailable();
//
//       print("✅ Update downloaded successfully. Restarting app...");
//
//       // Save update state to SharedPreferences
//       prefs.setBool("update_downloaded", true);
//
//       // Restart app to apply the update
//       Restart.restartApp();
//     } else {
//       print("ℹ️ No new update available.");
//     }
//   } catch (e) {
//     print("❌ Error checking for updates: $e");
//   } finally {
//     _updateInProgress = false; // Reset flag after update check
//   }
// }

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
        BlocProvider(create: (context) => AttendeCubits()..createDatabase()),

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

