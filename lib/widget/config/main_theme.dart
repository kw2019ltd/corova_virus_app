import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color blueGrey_900 = Color.fromRGBO(26, 32, 33, 1); //Colors.blueGrey[900];
Color teal_800 = Colors.teal[800]; //Color.fromRGBO(249, 77, 102, 1);
Color teal_900 = Colors.teal[900];

const MaterialColor primarySwatch_teal = MaterialColor(
  0xFF004D40,
  <int, Color>{
    50: Color(0xFF004D40),
    100: Color(0xFF004D40),
    200: Color(0xFF004D40),
    300: Color(0xFF004D40),
    400: Color(0xFF004D40),
    500: Color(0xFF004D40),
    600: Color(0xFF004D40),
    700: Color(0xFF004D40),
    800: Color(0xFF004D40),
    900: Color(0xFF004D40),
  },
);

class ThemeProvider with ChangeNotifier {
  bool isLightTheme;

  ThemeProvider({this.isLightTheme});

  ThemeData get getThemeData => isLightTheme ? lightTheme : darkTheme;

  set setThemeData(bool val) {
    if (val) {
      isLightTheme = true;
    } else {
      isLightTheme = false;
    }
    notifyListeners();
  }
}

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  accentColor: teal_800,
  primaryColor: teal_800,
  indicatorColor: Colors.white,
  dividerColor: Colors.white,
  backgroundColor: blueGrey_900,
  cardColor: blueGrey_900,
  scaffoldBackgroundColor: blueGrey_900,
  buttonColor: teal_800,
  // _color_teal_800,
  dialogBackgroundColor: Colors.grey[850],
  buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
  hintColor: Colors.white,
  accentTextTheme: TextTheme(
    title: GoogleFonts.varelaRound(),
    headline: GoogleFonts.varelaRound(),
    body1: GoogleFonts.varelaRound(),
    subtitle: GoogleFonts.varelaRound(),
    display1: GoogleFonts.varelaRound(),
    body2: GoogleFonts.varelaRound(),
    button: GoogleFonts.varelaRound(),
    caption: GoogleFonts.varelaRound(),
    display4: GoogleFonts.varelaRound(),
    display2: GoogleFonts.varelaRound(),
    display3: GoogleFonts.varelaRound(),
    overline: GoogleFonts.varelaRound(),
    subhead: GoogleFonts.varelaRound(),
  ),
  primaryTextTheme: TextTheme(
    title: GoogleFonts.varelaRound(
      fontWeight: FontWeight.w700,
    ),
    headline: GoogleFonts.varelaRound(),
    body1: GoogleFonts.varelaRound(),
    subtitle: GoogleFonts.varelaRound(),
    display1: GoogleFonts.varelaRound(),
    body2: GoogleFonts.varelaRound(),
    button: GoogleFonts.varelaRound(),
    caption: GoogleFonts.varelaRound(),
    display4: GoogleFonts.varelaRound(),
    display2: GoogleFonts.varelaRound(),
    display3: GoogleFonts.varelaRound(),
    overline: GoogleFonts.varelaRound(),
    subhead: GoogleFonts.varelaRound(),
  ),
  textTheme: TextTheme(
    title: GoogleFonts.varelaRound(),
    headline: GoogleFonts.varelaRound(),
    body1: GoogleFonts.varelaRound(),
    subtitle: GoogleFonts.varelaRound(),
    display1: GoogleFonts.varelaRound(),
    body2: GoogleFonts.varelaRound(),
    button: GoogleFonts.varelaRound(),
    caption: GoogleFonts.varelaRound(),
    display4: GoogleFonts.varelaRound(),
    display2: GoogleFonts.varelaRound(),
    display3: GoogleFonts.varelaRound(),
    overline: GoogleFonts.varelaRound(),
    subhead: GoogleFonts.varelaRound(),
  ),
);

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: primarySwatch_teal,
  primaryColor: teal_900,
  accentColor: teal_900,
  indicatorColor: Colors.white,
  backgroundColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  dividerColor: teal_900,
  iconTheme: IconThemeData(color: teal_900),
  accentIconTheme: const IconThemeData(color: Colors.grey),
  buttonColor: teal_900,
  buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
  hintColor: Colors.black,
  accentTextTheme: TextTheme(
    title: GoogleFonts.varelaRound(),
    headline: GoogleFonts.varelaRound(),
    body1: GoogleFonts.varelaRound(),
    subtitle: GoogleFonts.varelaRound(),
    display1: GoogleFonts.varelaRound(),
    body2: GoogleFonts.varelaRound(),
    button: GoogleFonts.varelaRound(color: Colors.white),
    caption: GoogleFonts.varelaRound(),
    display4: GoogleFonts.varelaRound(),
    display2: GoogleFonts.varelaRound(),
    display3: GoogleFonts.varelaRound(),
    overline: GoogleFonts.varelaRound(),
    subhead: GoogleFonts.varelaRound(),
  ),
  primaryTextTheme: TextTheme(
    title: GoogleFonts.varelaRound(
      color: Colors.white,
      fontWeight: FontWeight.w700,
    ),
    headline: GoogleFonts.varelaRound(),
    body1: GoogleFonts.varelaRound(),
    subtitle: GoogleFonts.varelaRound(),
    display1: GoogleFonts.varelaRound(),
    body2: GoogleFonts.varelaRound(),
    button: GoogleFonts.varelaRound(color: Colors.white),
    caption: GoogleFonts.varelaRound(),
    display4: GoogleFonts.varelaRound(),
    display2: GoogleFonts.varelaRound(),
    display3: GoogleFonts.varelaRound(),
    overline: GoogleFonts.varelaRound(),
    subhead: GoogleFonts.varelaRound(),
  ),
  textTheme: TextTheme(
    title: GoogleFonts.varelaRound(color: Colors.white),
    headline: GoogleFonts.varelaRound(),
    body1: GoogleFonts.varelaRound(),
    subtitle: GoogleFonts.varelaRound(),
    display1: GoogleFonts.varelaRound(),
    body2: GoogleFonts.varelaRound(),
    button: GoogleFonts.varelaRound(color: Colors.white),
    caption: GoogleFonts.varelaRound(),
    display4: GoogleFonts.varelaRound(),
    display2: GoogleFonts.varelaRound(),
    display3: GoogleFonts.varelaRound(),
    overline: GoogleFonts.varelaRound(),
    subhead: GoogleFonts.varelaRound(),
  ),
);
