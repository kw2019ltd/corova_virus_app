import 'package:shared_preferences/shared_preferences.dart';

const show_favorite = "show_favorite";
const String favorite_list = 'favorite_list';
const String dark_theme_on = 'dark_theme_on';

class CoronaSharedPreferences {
  static final CoronaSharedPreferences _coronaSharedPreferences =
      CoronaSharedPreferences._internal();

  factory CoronaSharedPreferences() => _coronaSharedPreferences;

  CoronaSharedPreferences._internal();

  SharedPreferences _sharedPreferences;
  List<String> favoriteList;
  bool showFavorite;
  bool darkThemeOn;

  Future<void> initSharedPreferencesProp() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _initShowFavorite();
    _initFavoriteList();
    _initDarkTheme();
  }

  void _initShowFavorite() {
    showFavorite = _sharedPreferences.getBool(show_favorite) ?? false;
    _sharedPreferences.setBool(show_favorite, showFavorite);
  }

  void _initDarkTheme() {
    darkThemeOn = _sharedPreferences.getBool(dark_theme_on) ?? false;
    _sharedPreferences.setBool(dark_theme_on, darkThemeOn);
  }

  void _initFavoriteList() {
    final List<String> list = _sharedPreferences.getStringList(favorite_list);
    favoriteList = list ?? [];
  }

  Future<void> _saveFavoriteList() async {
    await _sharedPreferences.setStringList(favorite_list, favoriteList);
  }

  Future<void> removeFavoriteCountry(String country) async {
    favoriteList.remove(country);
    await _saveFavoriteList();
  }

  Future<void> addFavoriteCountry(String country) async {
    favoriteList.add(country);
    await _saveFavoriteList();
  }

  Future<void> saveShowFavorite(bool value) async {
    showFavorite = value;
    await _sharedPreferences.setBool(show_favorite, showFavorite);
  }

  Future<void> saveDarkTheme(bool value) async {
    darkThemeOn = value;
    await _sharedPreferences.setBool(dark_theme_on, darkThemeOn);
  }
}
