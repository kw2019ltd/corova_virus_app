import 'package:charts_flutter/flutter.dart' as charts;
import 'package:corovavirusapp/dto/timeline/country_info_timeline_dto.dart';
import 'package:corovavirusapp/repository/corona_bloc.dart';
import 'package:corovavirusapp/repository/shared_preferences.dart';
import 'package:corovavirusapp/util/utils.dart';
import 'package:corovavirusapp/widget/config/widget_common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CountryLineChart extends StatelessWidget {
  final String country;

  const CountryLineChart({this.country, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CountryInfoTimelineDto>(
        initialData: CoronaBloc().countryInfoTimelineDto$,
        stream: CoronaBloc().countriesInfoTimeLineDtoBehaviorSubject$.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.timeline == null ||
                snapshot.data.timeline.cases.map.isEmpty) {
              return buildDisplayContentSizeBox(
                  ApiErrorWidget(_refreshIconOnPressed), context);
            }
            return Column(
              children: <Widget>[
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(left: 5, top: 5),
                  child: charts.TimeSeriesChart(
                    _createSampleData(snapshot.data),
                    animate: true,
                    defaultRenderer: charts.LineRendererConfig(
                        includePoints: true,
                        includeArea: true,
                        strokeWidthPx: 3.5,
                        radiusPx: 5,
                        areaOpacity: 0.1),
                    customSeriesRenderers: [
                      charts.PointRendererConfig(
                          customRendererId: 'customPoint')
                    ],
                    dateTimeFactory: const charts.LocalDateTimeFactory(),
                    behaviors: _buildChartBehaviors(),
                    domainAxis: _buildOrdinalAxisSpec(),
                    primaryMeasureAxis: _buildNumericAxisSpec(),
                  ),
                )),
              ],
            );
          } else if (snapshot.hasError) {
            return buildDisplayContentSizeBox(
                ApiErrorWidget(_refreshIconOnPressed), context);
          }
          return buildDisplayContentSizeBox(const ProgressBarWidget(), context);
        });
  }

  void _refreshIconOnPressed() async {
    await CoronaBloc().getCountriesInfoTimeLine(country);
  }

  List<charts.ChartBehavior> _buildChartBehaviors() {
    return [
      charts.SeriesLegend(
          legendDefaultMeasure: charts.LegendDefaultMeasure.lastValue,
          showMeasures: true,
          cellPadding: const EdgeInsets.all(4.0),
          horizontalFirst: false,
          entryTextStyle: charts.TextStyleSpec(fontSize: 15),
          desiredMaxColumns: 2,
          desiredMaxRows: 2),
    ];
  }

  charts.DateTimeAxisSpec _buildOrdinalAxisSpec() {
    return charts.DateTimeAxisSpec(
      renderSpec: charts.SmallTickRendererSpec(
        // Tick and Label styling here.
        labelStyle: charts.TextStyleSpec(
            fontSize: 13, // size in Pts.
            color: CoronaSharedPreferences().darkThemeOn
                ? charts.Color.white
                : charts.Color.black),
      ),
    );
  }

  charts.NumericAxisSpec _buildNumericAxisSpec() {
    return charts.NumericAxisSpec(
      renderSpec: charts.GridlineRendererSpec(
        // Tick and Label styling here.
        labelStyle: charts.TextStyleSpec(
            fontSize: 13,
            color: CoronaSharedPreferences().darkThemeOn
                ? charts.Color.white
                : charts.Color.black // size in Pts.
            ),

        // Change the line colors to match text color.
      ),
    );
  }

  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData(
      CountryInfoTimelineDto countryInfoTimelineDto) {
    Map<String, int> coronaCasesMap =
        getCoronaCasesMap(countryInfoTimelineDto.timeline.cases.map);
    Map<String, int> coronaDeathsMap = getCoronaDeathsMap(
        countryInfoTimelineDto.timeline.deaths.map, coronaCasesMap);
    Map<String, int> coronaRecoveredMap = getCoronaRecoveredMap(
        countryInfoTimelineDto.timeline.recovered.map, coronaCasesMap);

    List<TimeSeriesSales> coronaCasesDataTimeSeriesSales = [];
    if (coronaCasesMap.isNotEmpty) {
      coronaCasesMap.forEach((String key, int value) {
        coronaCasesDataTimeSeriesSales
            .add(TimeSeriesSales(stringToDateTime(key), value));
      });
    }

    List<TimeSeriesSales> coronaDeathsDataTimeSeriesSales = [];
    if (coronaDeathsMap.isNotEmpty) {
      coronaDeathsMap.forEach((String key, int value) {
        coronaDeathsDataTimeSeriesSales
            .add(TimeSeriesSales(stringToDateTime(key), value));
      });
    }

    List<TimeSeriesSales> coronaRecoveredDataTimeSeriesSales = [];

    if (coronaRecoveredMap.isNotEmpty) {
      coronaRecoveredMap.forEach((String key, int value) {
        coronaRecoveredDataTimeSeriesSales
            .add(TimeSeriesSales(stringToDateTime(key), value));
      });
    }

    return [
      charts.Series<TimeSeriesSales, DateTime>(
        id: 'Cases',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault.darker,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: coronaCasesDataTimeSeriesSales,
      ),
      if (coronaDeathsDataTimeSeriesSales.isNotEmpty) ...{
        charts.Series<TimeSeriesSales, DateTime>(
            id: 'Deaths',
            colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault.darker,
            domainFn: (TimeSeriesSales sales, _) => sales.time,
            measureFn: (TimeSeriesSales sales, _) => sales.sales,
            data: coronaDeathsDataTimeSeriesSales)
      },
      if (coronaRecoveredDataTimeSeriesSales.isNotEmpty) ...{
        charts.Series<TimeSeriesSales, DateTime>(
          id: 'Recovered',
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault.darker,
          domainFn: (TimeSeriesSales sales, _) => sales.time,
          measureFn: (TimeSeriesSales sales, _) => sales.sales,
          data: coronaRecoveredDataTimeSeriesSales,
        )
      }
    ];
  }
}

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}
