Map<String, dynamic> getCoronaCasesMap(Map<String, dynamic> values) {
  Map<String, int> dateValues = {};
  if (values == null || values.isEmpty) {
    return dateValues;
  }
  int count = 0;
  values.forEach((String key, dynamic value) {
    if (count % 16 == 0) {
      dateValues[key] = value;
    }
    count = count + 1;
  });
  if (values.length % 14 != 0) {
    dateValues[values.keys.elementAt(values.length - 1)] =
        values.values.elementAt(values.length - 1);
  }
  return dateValues;
}

Map<String, int> getCoronaDeathsMap(
    Map<String, dynamic> values, Map<String, int> cases) {
  Map<String, int> dateValues = {};
  if (values == null || values.isEmpty) {
    return dateValues;
  }
  cases.forEach((String key, int value) {
    dateValues[key] = values[key];
  });
  return dateValues;
}

Map<String, int> getCoronaRecoveredMap(
    Map<String, dynamic> values, Map<String, int> cases) {
  Map<String, int> dateValues = {};
  if (values == null || values.isEmpty) {
    return dateValues;
  }
  cases.forEach((String key, int value) {
    dateValues[key] = values[key];
  });
  return dateValues;
}

DateTime stringToDateTime(String stringAsDate) {
  List<String> dateAsList = stringAsDate.split("/");
  return DateTime(int.parse(dateAsList[2]), int.parse(dateAsList[0]),
      int.parse(dateAsList[1]));
}
