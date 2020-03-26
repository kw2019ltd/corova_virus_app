import 'dart:async';

import 'package:corovavirusapp/dto/countries_info_dto.dart';
import 'package:corovavirusapp/dto/global_info_dto.dart';
import 'package:corovavirusapp/dto/timeline/country_info_timeline_dto.dart';
import 'package:corovavirusapp/repository/cache.dart';
import 'package:corovavirusapp/repository/repository.dart';
import 'package:corovavirusapp/util/logging.dart';
import 'package:rxdart/rxdart.dart';

class CoronaBloc {
  static final CoronaBloc _instance = CoronaBloc._internal();

  factory CoronaBloc() => _instance;

  CoronaBloc._internal() {
    _init();
  }

  final CoronaRepository _coronaRepository = CoronaRepository();
  final _StateManager _stateManager = _StateManager();
  final CacheManager _cacheManager = CacheManager();

  void _init() {
    getGlobalInfo(newCall: true);
    getAllCountriesInfo(newCall: true);
  }

  Future<void> getGlobalInfo({bool newCall}) async {
    final GlobalInfoDto globalInfoDto =
        await _coronaRepository.getGlobalInfo(newCall: newCall);
    if (globalInfoDto != null) {
      CoronaBloc().globalInfoDtoBehaviorSubject$.add(globalInfoDto);
    }
  }

  Future<void> getAllCountriesInfo({bool newCall}) async {
    final List<CountriesInfoDto> countriesInfoDto =
        await _coronaRepository.getAllCountriesInfo(newCall: newCall);
    if (countriesInfoDto != null) {
      CoronaBloc().countriesInfoDtoBehaviorSubject$.add(countriesInfoDto);
    }
  }

  Future<void> getAllCountriesInfoSortedBy({String sortBy}) async {
    final List<CountriesInfoDto> countriesInfoDto =
        await _coronaRepository.getAllCountriesInfoSortedBy(sortBy: sortBy);
    if (countriesInfoDto != null) {
      CoronaBloc().countriesInfoDtoBehaviorSubject$.add(countriesInfoDto);
    }
  }

  Future<void> getCountriesInfoTimeLine(String countryName) async {
    final CountryInfoTimelineDto countryInfoTimelineDto =
        await _coronaRepository.getCountriesInfoTimeLine(countryName);
    if (countryInfoTimelineDto != null) {
      CoronaBloc()
          .countriesInfoTimeLineDtoBehaviorSubject$
          .add(countryInfoTimelineDto);
    }
  }

  void dispose() {
    _stateManager.dispose();
  }

  GlobalInfoDto get globalInfoDto$ => _cacheManager.globalInfoDto;

  List<CountriesInfoDto> get countriesInfoDto$ =>
      _cacheManager.countriesInfoDto;

  CountryInfoTimelineDto get countryInfoTimelineDto$ =>
      _cacheManager.countryInfoTimelineDto;

  BehaviorSubject<GlobalInfoDto> get globalInfoDtoBehaviorSubject$ =>
      _stateManager.globalInfoDtoBehaviorSubject;

  BehaviorSubject<List<CountriesInfoDto>>
      get countriesInfoDtoBehaviorSubject$ =>
          _stateManager.countriesInfoDtoBehaviorSubject;

  BehaviorSubject<FAVORITE_EVENT> get favoriteEventBehaviorSubject$ =>
      _stateManager.favoriteEventBehaviorSubject;

  PublishSubject<CountryInfoTimelineDto>
      get countriesInfoTimeLineDtoBehaviorSubject$ =>
          _stateManager.countriesInfoTimeLineDtoBehaviorSubject;
}

class _StateManager {
  BehaviorSubject<GlobalInfoDto> globalInfoDtoBehaviorSubject =
      BehaviorSubject();
  BehaviorSubject<List<CountriesInfoDto>> countriesInfoDtoBehaviorSubject =
      BehaviorSubject();

  PublishSubject<CountryInfoTimelineDto>
      countriesInfoTimeLineDtoBehaviorSubject = PublishSubject();

  BehaviorSubject<FAVORITE_EVENT> favoriteEventBehaviorSubject =
      BehaviorSubject();

  void dispose() {
    logger.info("dispose _StateManager streams");
    globalInfoDtoBehaviorSubject.close();
    countriesInfoDtoBehaviorSubject.close();
    favoriteEventBehaviorSubject.close();
    countriesInfoTimeLineDtoBehaviorSubject.close();
  }
}

enum FAVORITE_EVENT { SHOW_FAVORITE, NO_FAVORITE }

class FavoriteEvent {
  final FAVORITE_EVENT event;

  const FavoriteEvent(this.event);
}
