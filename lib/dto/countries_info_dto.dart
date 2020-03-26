import 'package:corovavirusapp/dto/country_info.dart';

class CountriesInfoDto {
  String country;
  int cases;
  int todayCases;
  int deaths;
  int todayDeaths;
  int recovered;
  int active;
  int critical;
  String casesPerOneMillion = "0";
  CountryInfo countryInfo;
  CountriesInfoDto.fromJsonMap(Map<String, dynamic> map)
      : country = toCountry(map),
        cases = map["cases"] ?? 0,
        todayCases = map["todayCases"] ?? 0,
        deaths = map["deaths"] ?? 0,
        todayDeaths = map["todayDeaths"] ?? 0,
        recovered = map["recovered"] ?? 0,
        active = map["active"] ?? 0,
        critical = map["critical"] ?? 0,
        casesPerOneMillion = map["casesPerOneMillion"]?.toString(),
        countryInfo = CountryInfo.fromJsonMap(map["countryInfo"] ?? {});

  static String toCountry(map) {
    String str = map["country"];
    return str != null && str.toLowerCase().contains("iran") ? "Iran" : str;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['country'] = country;
    data['cases'] = cases;
    data['todayCases'] = todayCases;
    data['deaths'] = deaths;
    data['todayDeaths'] = todayDeaths;
    data['recovered'] = recovered;
    data['active'] = active;
    data['critical'] = critical;
    data['casesPerOneMillion'] = casesPerOneMillion;
    return data;
  }
}
