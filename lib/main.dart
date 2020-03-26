import 'dart:async';

import 'package:corovavirusapp/repository/corona_bloc.dart';
import 'package:corovavirusapp/repository/shared_preferences.dart';
import 'package:corovavirusapp/util/package_Info.dart';
import 'package:corovavirusapp/widget/chart/country_details_chart.dart';
import 'package:corovavirusapp/widget/config/main_theme.dart';
import 'package:corovavirusapp/widget/config/widget_config.dart';
import 'package:corovavirusapp/widget/drawer/setting_widget.dart';
import 'package:corovavirusapp/widget/home.dart';
import 'package:corovavirusapp/widget/search/country_info_search.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runMyApp();
}

Future<void> init() async {
  await CoronaSharedPreferences().initSharedPreferencesProp();
  CoronaBloc();
  initPackageInfo();
}

void runMyApp() {
  runZoned<Future<void>>(
    () async {
      runApp(
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(
              isLightTheme: !CoronaSharedPreferences().darkThemeOn),
          child: const MyApp(),
        ),
      );
    },
    onError: (dynamic error, StackTrace stackTrace) async {
//      await FireBaseManager().logException(
//        error,
//        stackTrace: stackTrace,
//      );
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      theme: themeProvider.getThemeData,
      debugShowCheckedModeBanner: false,
      initialRoute: homeRoute,
      routes: {
        homeRoute: (context) => HomeWidget(key: Key('Home_Widget')),
      },
      onGenerateRoute: (settingRoute) {
        switch (settingRoute.name) {
          case appInfoRoute:
            return PageTransition<dynamic>(
              child: const AppInfoWidget(),
              type: PageTransitionType.leftToRight,
            );
          case countryChartRoute:
            return PageTransition<dynamic>(
              child: CountryInfoHistoryWidget(
                countriesInfoDto: settingRoute.arguments,
              ),
              type: PageTransitionType.fade,
            );
          case countrySearchRoute:
            return PageTransition<dynamic>(
              child: CountryInfoSearchWidget(
                countriesInfoDto: settingRoute.arguments,
              ),
              type: PageTransitionType.fade,
            );
        }
        return MaterialPageRoute<dynamic>(
          builder: (context) => const Placeholder(),
        );
      },
    );
  }

  @override
  void dispose() {
    CoronaBloc().dispose();
    super.dispose();
  }
}
