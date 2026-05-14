import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/constants.dart';
import 'core/theme.dart';
import 'firebase_options.dart';
import 'localization/app_localizations.dart';
import 'providers/auth_provider.dart';
import 'providers/interview_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/interview_setup_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/interview_detail_screen.dart';
import 'screens/interview_history_screen.dart';
import 'screens/report_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const InterviewSimulatorApp());
}

class InterviewSimulatorApp extends StatelessWidget {
  const InterviewSimulatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => InterviewProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, themeProvider, localeProvider, _) {
          final theme = AppTheme.themeForId(themeProvider.themeId);
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: theme,
            darkTheme: theme,
            themeMode: ThemeMode.light,
            locale: localeProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            initialRoute: AppConstants.splashRoute,
            routes: {
              AppConstants.splashRoute: (_) => const SplashScreen(),
              AppConstants.loginRoute: (_) => const LoginScreen(),
              AppConstants.homeRoute: (_) => const HomeScreen(),
              AppConstants.setupRoute: (_) => const SetupScreen(),
              AppConstants.chatRoute: (_) => const ChatScreen(),
              AppConstants.reportRoute: (_) => const ReportScreen(),
              AppConstants.historyRoute: (_) => const InterviewHistoryScreen(),
              AppConstants.interviewDetailRoute: (_) => const InterviewDetailScreen(),
            },
          );
        },
      ),
    );
  }
}
