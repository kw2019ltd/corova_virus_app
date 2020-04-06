class UsaStateInfo {
  String state;
  int cases;
  int todayCases;
  int deaths;
  int todayDeaths;
  int active;

  UsaStateInfo.fromJsonMap(Map<String, dynamic> map)
      : state = map["state"],
        cases = map["cases"],
        todayCases = map["todayCases"],
        deaths = map["deaths"],
        todayDeaths = map["todayDeaths"],
        active = map["active"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['state'] = state;
    data['cases'] = cases;
    data['todayCases'] = todayCases;
    data['deaths'] = deaths;
    data['todayDeaths'] = todayDeaths;
    data['active'] = active;
    return data;
  }
}
