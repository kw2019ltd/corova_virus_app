import 'package:corovavirusapp/dto/timeline/timeline.dart';

class CountryInfoTimelineDto {
  String country;
  Timeline timeline;

  CountryInfoTimelineDto.fromJsonMap(Map<String, dynamic> map)
      : country = map["country"],
        timeline = Timeline.fromJsonMap(map["timeline"]);
}
