import 'package:corovavirusapp/dto/timeline/cases.dart';
import 'package:corovavirusapp/dto/timeline/deaths.dart';
import 'package:corovavirusapp/dto/timeline/recovered.dart';

class Timeline {
  Cases cases;
  Deaths deaths;
  Recovered recovered;

  Timeline.fromJsonMap(Map<String, dynamic> map)
      : cases = Cases.fromJsonMap(map["cases"]),
        deaths = Deaths.fromJsonMap(map["deaths"]),
        recovered = Recovered.fromJsonMap(map["recovered"]);
}
