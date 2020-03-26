class CountryInfo {
  String flag;

  CountryInfo.fromJsonMap(Map<String, dynamic> map) : flag = map["flag"] ?? "";

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['flag'] = flag;
    return data;
  }
}
