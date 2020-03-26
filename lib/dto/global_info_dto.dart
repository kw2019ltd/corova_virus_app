import 'package:intl/intl.dart';

class GlobalInfoDto {
  int cases;
  int deaths;
  int recovered;
  String updatedDate;
  String updatedTime;
  static DateFormat formatter = DateFormat("MMM d y");
  static DateFormat timeFormatter = DateFormat().add_jm();

  GlobalInfoDto.fromJsonMap(Map<String, dynamic> map)
      : cases = map["cases"] ?? 0,
        deaths = map["deaths"] ?? 0,
        recovered = map["recovered"] ?? 0,
        updatedDate = toDate(map["updated"], formatter),
        updatedTime = toDate(map["updated"], timeFormatter);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['cases'] = cases;
    data['deaths'] = deaths;
    data['recovered'] = recovered;
    return data;
  }

  static String toDate(int date, DateFormat formatter) {
    try {
      if (date != null) {
        return formatter.format(DateTime.fromMillisecondsSinceEpoch(date));
      }
    } catch (ex) {
      return "";
    }
    return "";
  }
}
