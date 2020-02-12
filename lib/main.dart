import 'package:corona_flutter/core/api.dart';
import 'package:corona_flutter/core/hospital.dart';
import 'package:corona_flutter/core/news.dart';
import 'package:corona_flutter/core/settings.dart';
import 'package:corona_flutter/core/stat.dart';
import 'package:corona_flutter/core/travel_alert.dart';
import 'package:corona_flutter/pages/about_page.dart';
import 'package:corona_flutter/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(CoronaTrackerApp());
}

class CoronaTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final remoteRepo = RemoteRepository();
    final settings = Settings();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Settings>.value(
          value: settings,
        ),
        ChangeNotifierProvider<NewsService>(
          create: (_) => NewsService(
            remote: remoteRepo,
            settings: settings,
          ),
        ),
        ChangeNotifierProvider<StatsService>(
          create: (_) => StatsService(
            remote: remoteRepo,
            settings: settings,
          ),
        ),
        ChangeNotifierProvider<HospitalsService>(
          create: (_) => HospitalsService(
            remote: remoteRepo,
            settings: settings,
          ),
        ),
        ChangeNotifierProvider<TravelAlertsService>(
          create: (_) => TravelAlertsService(
            remote: remoteRepo,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'CoronaTracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          fontFamily: 'HKGrotesk',
          primarySwatch: Colors.teal,
        ),
        routes: {
          '/': (context) {
            return HomePage();
          },
          '/about': (context) {
            return AboutPage();
          },
        },
      ),
    );
  }
}
