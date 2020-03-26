import 'package:corovavirusapp/dto/countries_info_dto.dart';
import 'package:corovavirusapp/dto/global_info_dto.dart';
import 'package:corovavirusapp/dto/timeline/country_info_timeline_dto.dart';

class CacheManager {
  static final CacheManager _cacheManager = CacheManager._internal();

  factory CacheManager() => _cacheManager;

  CacheManager._internal();

  GlobalInfoDto globalInfoDto;
  List<CountriesInfoDto> countriesInfoDto;
  CountryInfoTimelineDto countryInfoTimelineDto;
}
