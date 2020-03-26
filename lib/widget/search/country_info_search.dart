import 'dart:io';

import 'package:corovavirusapp/dto/countries_info_dto.dart';
import 'package:corovavirusapp/repository/shared_preferences.dart';
import 'package:corovavirusapp/util/constance.dart';
import 'package:corovavirusapp/widget/chart/pie_chart.dart';
import 'package:corovavirusapp/widget/country_info.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:share_extend/share_extend.dart';

class CountryInfoSearchWidget extends StatelessWidget {
  final CountriesInfoDto countriesInfoDto;
  final ScreenshotController screenshotController = ScreenshotController();

  CountryInfoSearchWidget({this.countriesInfoDto, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: _AppBarWidget(
          screenshotController: screenshotController,
          country: countriesInfoDto.country,
        ),
      ),
      body: Screenshot(
        controller: screenshotController,
        child: Container(
          child: Card(
            margin: EdgeInsets.all(0),
            child: Column(
              children: <Widget>[
                CountryInfoWidget(
                  showCountry: false,
                  countriesInfoDto: countriesInfoDto,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: IconButton(
                      tooltip: "Share",
                      icon: Icon(FontAwesomeIcons.share),
                      onPressed: _sharePrice,
                      color: CoronaSharedPreferences().darkThemeOn
                          ? Theme.of(context).hintColor
                          : Theme.of(context).primaryColor),
                ),
                Expanded(
                  child: PieChartImpl(
                    dataMap: getPieChartData(),
                  ),
                )
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

  void _sharePrice() {
    var msg = countriesInfoDto
        .toJson()
        .toString()
        .replaceAll("{", "")
        .replaceAll("}", "");

    msg = msg + '\n\n' + google_play_app_url;
    Share.share(msg, subject: "CoronaVirus ${countriesInfoDto.country}");
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
      title: Text(
        country,
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
