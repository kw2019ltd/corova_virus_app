import 'dart:async';

import 'package:corovavirusapp/dto/countries_info_dto.dart';
import 'package:corovavirusapp/dto/global_info_dto.dart';
import 'package:corovavirusapp/dto/timeline/country_info_timeline_dto.dart';
import 'package:corovavirusapp/dto/usa/usa_state_info.dart';
import 'package:corovavirusapp/http/corona_api.dart';
import 'package:corovavirusapp/repository/cache.dart';

class CoronaRepository {
  final CoronaApi _coronaApi = CoronaApi();
  final CacheManager _cacheManager = CacheManager();

  Future<GlobalInfoDto> getGlobalInfo({bool newCall}) async {
    GlobalInfoDto globalInfoDto = _cacheManager.globalInfoDto;
    if (globalInfoDto == null || newCall) {
      globalInfoDto = await _coronaApi.getGlobalInfo();
      if (globalInfoDto != null) {
        _cacheManager.globalInfoDto = globalInfoDto;
      }
    }
    return Future.value(globalInfoDto);
  }

  Future<List<CountriesInfoDto>> getAllCountriesInfo({bool newCall}) async {
    List<CountriesInfoDto> countriesInfoDto = _cacheManager.countriesInfoDto;
    if (countriesInfoDto == null || newCall) {
      countriesInfoDto = await _coronaApi.getAllCountriesInfo();
      if (countriesInfoDto != null) {
        _cacheManager.countriesInfoDto = countriesInfoDto;
      }
    }
    return Future.value(countriesInfoDto);
  }

  Future<List<CountriesInfoDto>> getAllCountriesInfoSortedBy(
      {String sortBy}) async {
    List<CountriesInfoDto> countriesInfoDto =
        await _coronaApi.getAllCountriesInfoSortedBy(sortBy: sortBy);
    if (countriesInfoDto != null) {
      _cacheManager.countriesInfoDto = countriesInfoDto;
    }
    return Future.value(countriesInfoDto);
  }

  Future<List<UsaStateInfo>> getUsaStateInfo() async {
    List<UsaStateInfo> countriesInfoDto = await _coronaApi.getAllUsaInfo();
    return Future.value(countriesInfoDto);
  }

  Future<CountryInfoTimelineDto> getCountriesInfoTimeLine(
      String countryName) async {
    _cacheManager.countryInfoTimelineDto = null;
    CountryInfoTimelineDto countryInfoTimeline =
        await _coronaApi.getCountriesInfoTimeLine(countryName);
    _cacheManager.countryInfoTimelineDto = countryInfoTimeline;
    return Future.value(countryInfoTimeline);
  }
}
