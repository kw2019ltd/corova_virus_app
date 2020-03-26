import 'dart:async';
import 'dart:convert';
import 'dart:io' show HttpStatus;

import 'package:corovavirusapp/dto/countries_info_dto.dart';
import 'package:corovavirusapp/dto/global_info_dto.dart';
import 'package:corovavirusapp/dto/timeline/country_info_timeline_dto.dart';
import 'package:corovavirusapp/http/api_config.dart';
import 'package:corovavirusapp/repository/corona_bloc.dart';
import 'package:corovavirusapp/util/logging.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class CoronaApi {
  Future<GlobalInfoDto> getGlobalInfo() async {
    try {
      final Uri uri = Uri.https(heroku_2_base_url, 'all');
      final Response response = await http.get(
        uri,
        headers: headers,
      );

      if (response.statusCode == HttpStatus.ok) {
        return GlobalInfoDto.fromJsonMap(
          json.decode(response.body) as Map<String, dynamic>,
        );
      }
      CoronaBloc().globalInfoDtoBehaviorSubject$.addError(response.statusCode);
    } catch (e, s) {
      logger.severe("error while calling getGlobalInfo api", e, s);
      CoronaBloc().globalInfoDtoBehaviorSubject$.addError(e, s);
    }
    return null;
  }

  Future<List<CountriesInfoDto>> getAllCountriesInfo() async {
    try {
      final Uri uri = Uri.https(
        heroku_2_base_url,
        'countries',
      );
      final Response response = await http.get(
        uri,
        headers: headers,
      );

      if (response.statusCode == HttpStatus.ok) {
        return (json.decode(response.body) as List<dynamic>)
            .map((dynamic res) =>
                CountriesInfoDto.fromJsonMap(res as Map<String, dynamic>))
            .toList();
      }
      CoronaBloc()
          .countriesInfoDtoBehaviorSubject$
          .addError(response.statusCode);
    } catch (e, s) {
      logger.severe("error while calling getAllCountriesInfo api", e, s);
      CoronaBloc().countriesInfoDtoBehaviorSubject$.addError(e, s);
    }
    return null;
  }

  Future<List<CountriesInfoDto>> getAllCountriesInfoSortedBy(
      {String sortBy}) async {
    try {
      final Uri uri = Uri.https(
        heroku_2_base_url,
        'countries',
        {"sort": sortBy},
      );
      final Response response = await http.get(
        uri,
        headers: headers,
      );
      if (response.statusCode == HttpStatus.ok) {
        return (json.decode(response.body) as List<dynamic>)
            .map((dynamic res) =>
                CountriesInfoDto.fromJsonMap(res as Map<String, dynamic>))
            .toList();
      }
      CoronaBloc()
          .countriesInfoDtoBehaviorSubject$
          .addError(response.statusCode);
    } catch (e, s) {
      logger.severe(
          "error while calling getAllCountriesInfoSortedBy api", e, s);
      CoronaBloc().countriesInfoDtoBehaviorSubject$.addError(e, s);
    }
    return null;
  }

  Future<CountryInfoTimelineDto> getCountriesInfoTimeLine(
      String countryName) async {
    try {
      final Uri uri = Uri.https(
        heroku_2_base_url,
        'v2/historical/$countryName',
      );
      final Response response = await http.get(
        uri,
        headers: headers,
      );

      if (response.statusCode == HttpStatus.ok) {
        return CountryInfoTimelineDto.fromJsonMap(
          json.decode(response.body) as Map<String, dynamic>,
        );
      }
      CoronaBloc()
          .countriesInfoTimeLineDtoBehaviorSubject$
          .addError(response.statusCode);
    } catch (e, s) {
      logger.severe(
          "error while calling getCountriesInfoTimeLine api for $countryName",
          e,
          s);
      CoronaBloc().countriesInfoTimeLineDtoBehaviorSubject$.addError(e, s);
    }
    return null;
  }
}
