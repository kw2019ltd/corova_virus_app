import 'dart:io';

import 'package:corovavirusapp/dto/countries_info_dto.dart';
import 'package:corovavirusapp/widget/chart/country_line_chart.dart';
import 'package:corovavirusapp/widget/chart/pie_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_extend/share_extend.dart';

class CountryInfoHistoryWidget extends StatelessWidget {
  final CountriesInfoDto countriesInfoDto;
  final ScreenshotController screenshotController = ScreenshotController();

  CountryInfoHistoryWidget({this.countriesInfoDto, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: _AppBarWidget(
            screenshotController: screenshotController,
            country: countriesInfoDto.country,
          ),
        ),
        body: Screenshot(
          controller: screenshotController,
          child: Card(
            margin: EdgeInsets.all(0),
            child: TabBarView(
              children: [
                CountryLineChart(
                  country: countriesInfoDto.country,
                ),
                PieChartImpl(
                  dataMap: getPieChartData(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Map<String, double> getPieChartData() {
    Map<String, double> dataMap = Map();
    dataMap.putIfAbsent("Cases : ${countriesInfoDto.cases}",
        () => countriesInfoDto.cases.toDouble());
    dataMap.putIfAbsent("Recovered : ${countriesInfoDto.recovered}",
        () => countriesInfoDto.recovered.toDouble());
    dataMap.putIfAbsent("Deaths : ${countriesInfoDto.deaths}",
        () => countriesInfoDto.deaths.toDouble());

    return dataMap;
  }
}

class _AppBarWidget extends StatelessWidget {
  final String country;
  final ScreenshotController screenshotController;

  _AppBarWidget({this.screenshotController, this.country, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: <Widget>[
        IconButton(
          tooltip: "Capure Screen",
          icon: Icon(
            FontAwesomeIcons.camera,
            color: Colors.white,
          ),
          onPressed: () async {
            File file = await screenshotController.capture(
                pixelRatio: 1.5, delay: Duration(milliseconds: 10));
            await ShareExtend.share(file.path, "image",
                subject: "CoronaVirus $country");
          },
        )
      ],
      centerTitle: true,
      title: Text(country,
          style: TextStyle(
            fontSize: 24,
          )),
      bottom: const TabBar(
        tabs: [
          Tab(
            icon: Icon(FontAwesomeIcons.chartLine),
          ),
          Tab(
            icon: Icon(FontAwesomeIcons.chartPie),
          ),
        ],
      ),
    );
  }
}
