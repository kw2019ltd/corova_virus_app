import 'dart:async';
import 'dart:io';

import 'package:corovavirusapp/dto/countries_info_dto.dart';
import 'package:corovavirusapp/dto/global_info_dto.dart';
import 'package:corovavirusapp/repository/corona_bloc.dart';
import 'package:corovavirusapp/repository/shared_preferences.dart';
import 'package:corovavirusapp/util/constance.dart';
import 'package:corovavirusapp/widget/chart/pie_chart.dart';
import 'package:corovavirusapp/widget/config/main_theme.dart';
import 'package:corovavirusapp/widget/config/widget_common.dart';
import 'package:corovavirusapp/widget/country_info.dart';
import 'package:corovavirusapp/widget/drawer/drawer_widget.dart';
import 'package:corovavirusapp/widget/search/cust_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boom_menu/flutter_boom_menu.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:share_extend/share_extend.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeWidget extends StatelessWidget {
  HomeWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: PreferredSize(
        child: _AppBarWidget(),
        preferredSize: Size.fromHeight(130),
      ),
      floatingActionButton: BoomMenu(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        scrollVisible: true,
        overlayColor: Colors.black,
        overlayOpacity: 0.7,
        foregroundColor: Colors.white,
        child: Icon(Icons.sort),
        children: [
          MenuItem(
            child: Icon(
              FontAwesomeIcons.sort,
              color: Colors.white,
            ),
            title: "Sort by total cases",
            titleColor: Colors.white,
            subtitle: "",
            subTitleColor: Colors.white,
            backgroundColor: Colors.blue[600],
            onTap: () => sortBy(sortBy: cases),
          ),
          MenuItem(
            child: Icon(
              FontAwesomeIcons.sort,
              color: Colors.white,
            ),
            title: "Sort by today cases",
            titleColor: Colors.white,
            subtitle: "",
            subTitleColor: Colors.white,
            backgroundColor: Colors.blue[400],
            onTap: () => sortBy(sortBy: todayCases),
          ),
          MenuItem(
            child: Icon(
              FontAwesomeIcons.sort,
              color: Colors.white,
            ),
            title: "Sort by total deaths",
            titleColor: Colors.white,
            subtitle: "",
            subTitleColor: Colors.white,
            backgroundColor: Colors.red[600],
            onTap: () => sortBy(sortBy: deaths),
          ),
          MenuItem(
            child: Icon(
              FontAwesomeIcons.sort,
              color: Colors.white,
            ),
            title: "Sort by today deaths",
            titleColor: Colors.white,
            subtitle: "",
            subTitleColor: Colors.white,
            backgroundColor: Colors.red[700],
            onTap: () => sortBy(sortBy: todayDeaths),
          ),
          MenuItem(
            child: Icon(
              FontAwesomeIcons.sort,
              color: Colors.white,
            ),
            title: "Sort by total recovered",
            titleColor: Colors.white,
            subtitle: "",
            subTitleColor: Colors.white,
            backgroundColor: Colors.green[600],
            onTap: () => sortBy(sortBy: recovered),
          ),
          MenuItem(
            child: Icon(
              FontAwesomeIcons.sort,
              color: Colors.white,
            ),
            title: "Sort by critical cases",
            titleColor: Colors.white,
            subtitle: "",
            subTitleColor: Colors.white,
            backgroundColor: Colors.green[800],
            onTap: () => sortBy(sortBy: critical),
          ),
        ],
      ),
      body: StreamBuilder<FAVORITE_EVENT>(
          initialData: CoronaSharedPreferences().showFavorite
              ? FAVORITE_EVENT.SHOW_FAVORITE
              : FAVORITE_EVENT.NO_FAVORITE,
          stream: CoronaBloc().favoriteEventBehaviorSubject$.stream,
          builder: (context, snapshot) {
            FAVORITE_EVENT favoriteEvent = snapshot.data;
            return Container(
              child: StreamBuilder<List<CountriesInfoDto>>(
                stream: CoronaBloc().countriesInfoDtoBehaviorSubject$.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.isEmpty) {
                      return buildDisplayContentSizeBox(
                          ApiErrorWidget(_refreshIconOnPressed), context);
                    }

                    List<CountriesInfoDto> countriesInfoDto = snapshot.data;
                    if (favoriteEvent == FAVORITE_EVENT.SHOW_FAVORITE) {
                      countriesInfoDto = countriesInfoDto
                          .where((element) => CoronaSharedPreferences()
                              .favoriteList
                              .contains(element.country))
                          .toList();
                    }
                    return AnimationLimiter(
                      child: LiquidPullToRefresh(
                        backgroundColor: Theme.of(context).indicatorColor,
                        color: Theme.of(context).primaryColor,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: countriesInfoDto.length,
                          itemBuilder: (BuildContext context, int index) {
                            final ScreenshotController screenshotController =
                                ScreenshotController();
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 500),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: GestureDetector(
                                    child: Screenshot(
                                      controller: screenshotController,
                                      child: CountryInfoWidget(
                                        countriesInfoDto:
                                            countriesInfoDto[index],
                                        key: Key(
                                            countriesInfoDto[index].country),
                                      ),
                                    ),
                                    onDoubleTap: () async {
                                      File file =
                                          await screenshotController.capture(
                                              pixelRatio: 1.5,
                                              delay:
                                                  Duration(milliseconds: 10));
                                      await ShareExtend.share(
                                          file.path, "image",
                                          subject:
                                              "CoronaVirus ${countriesInfoDto[index].country}");
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        springAnimationDurationInMilliseconds: 500,
                        showChildOpacityTransition: false,
                        onRefresh: _handlePullToRefresh,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return buildDisplayContentSizeBox(
                        ApiErrorWidget(_refreshIconOnPressed), context);
                  }
                  return buildDisplayContentSizeBox(
                      const ProgressBarWidget(), context);
                },
              ),
            );
          }),
    );
  }

  Future<void> sortBy({String sortBy}) async {
    await CoronaBloc().getAllCountriesInfoSortedBy(sortBy: sortBy);
  }

  Future<void> _handlePullToRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(milliseconds: 500), () {
      completer.complete();
    });
    return completer.future.then<void>(
      (_) {
        _refreshIconOnPressed();
      },
    );
  }

  void _refreshIconOnPressed() async {
    await Future.value(
      [
        CoronaBloc().getAllCountriesInfo(newCall: true),
        CoronaBloc().getGlobalInfo(newCall: true)
      ],
    );
  }
}

class _AppBarWidget extends StatelessWidget {
  final ScreenshotController screenshotController = ScreenshotController();

  _AppBarWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 5,
      centerTitle: true,
      actions: <Widget>[
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            bool showFavorite = CoronaSharedPreferences().showFavorite;
            return IconButton(
              tooltip: "Show Favorite",
              iconSize: 20,
              icon: Icon(
                  showFavorite
                      ? FontAwesomeIcons.solidStar
                      : FontAwesomeIcons.star,
                  color: showFavorite ? Colors.yellowAccent : Colors.white),
              onPressed: () {
                CoronaSharedPreferences().saveShowFavorite(!showFavorite);
                setState(
                  () {
                    FAVORITE_EVENT favoriteEvent = showFavorite
                        ? FAVORITE_EVENT.NO_FAVORITE
                        : FAVORITE_EVENT.SHOW_FAVORITE;
                    CoronaBloc()
                        .favoriteEventBehaviorSubject$
                        .add(favoriteEvent);
                  },
                );
              },
            );
          },
        ),
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            bool darkThemeOn = CoronaSharedPreferences().darkThemeOn;
            return IconButton(
                tooltip: "Dark/Light Mode",
                iconSize: 20,
                icon: Icon(
                    darkThemeOn
                        ? FontAwesomeIcons.solidMoon
                        : FontAwesomeIcons.moon,
                    color: darkThemeOn ? Colors.yellowAccent : Colors.white),
                onPressed: () {
                  CoronaSharedPreferences().saveDarkTheme(!darkThemeOn);
                  final ThemeProvider themeProvider =
                      Provider.of<ThemeProvider>(context, listen: false);
                  themeProvider.setThemeData = darkThemeOn;
                  setState(() {});
                });
          },
        ),
        IconButton(
          tooltip: "Search",
          iconSize: 20,
          icon: Icon(FontAwesomeIcons.search),
          onPressed: () {
            showSearch<dynamic>(
              context: context,
              delegate: CustomSearchDelegate(),
            );
          },
        )
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: UnderlineTabIndicator(
            borderSide: BorderSide(color: Colors.white),
          ),
          height: 70,
          alignment: Alignment.center,
          child: StreamBuilder<GlobalInfoDto>(
            stream: CoronaBloc().globalInfoDtoBehaviorSubject$.stream,
            builder: (context, snapshot) {
              GlobalInfoDto globalInfoDto = CoronaBloc().globalInfoDto$;
              if (snapshot.hasData || globalInfoDto != null) {
                globalInfoDto = snapshot.data ?? globalInfoDto;
                return GestureDetector(
                  child: RichText(
                    text: TextSpan(
                      text: 'Total Cases: ',
                      style: GoogleFonts.varelaRound(
                          fontWeight: FontWeight.bold, fontSize: 16),
                      children: <TextSpan>[
                        TextSpan(
                          text: '${globalInfoDto.cases}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            backgroundColor: Colors.blue[600],
                          ),
                        ),
                        TextSpan(text: '\nTotal Deaths: '),
                        TextSpan(
                          text: '${globalInfoDto.deaths}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              backgroundColor: Colors.red[600]),
                        ),
                        TextSpan(text: '\nTotal Recovered: '),
                        TextSpan(
                          text: '${globalInfoDto.recovered}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            backgroundColor: Colors.green[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    _showDialog(context);
                  },
                );
              } else {
                return Text('');
              }
            },
          ),
        ),
      ),
      title: InkWell(
        child: StreamBuilder<GlobalInfoDto>(
          stream: CoronaBloc().globalInfoDtoBehaviorSubject$.stream,
          builder: (context, snapshot) {
            GlobalInfoDto globalInfoDto = CoronaBloc().globalInfoDto$;
            if (snapshot.hasData) {
              globalInfoDto = snapshot.data;
            }
            String dateText = "";
            if (globalInfoDto != null && globalInfoDto.updatedDate != null) {
              dateText =
                  globalInfoDto.updatedDate + " " + globalInfoDto.updatedTime;
            }
            return RichText(
              text: TextSpan(
                text: 'Global Cases  ',
                style: GoogleFonts.concertOne(
                    fontWeight: FontWeight.bold, fontSize: 25),
                children: <TextSpan>[
                  if (dateText != "") ...{
                    TextSpan(
                      text: '\n$dateText',
                      style: TextStyle(fontSize: 15),
                    )
                  }
                ],
              ),
            );
          },
        ),
        onTap: _launchURL,
      ),
    );
  }

  Future<void> _launchURL() async {
    if (await canLaunch(corona_main_site)) {
      await launch(corona_main_site, enableJavaScript: true);
    }
  }

  void _showDialog(BuildContext context) {
    showSlideDialog(
        backgroundColor: blueGrey_900,
        context: context,
        child: Container(
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    tooltip: "Capure Screen",
                    icon: Icon(
                      FontAwesomeIcons.camera,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      screenshotController
                          .capture(
                              pixelRatio: 1.5,
                              delay: Duration(milliseconds: 10))
                          .then(
                        (File image) async {
                          await ShareExtend.share(image.path, "image",
                              subject: "Total Cases");
                        },
                      );
                    },
                  ),
                  IconButton(
                    tooltip: "Share",
                    icon: Icon(
                      FontAwesomeIcons.share,
                      color: Colors.white,
                    ),
                    onPressed: _shareGlobalInfo,
                  )
                ],
              ),
              Screenshot(
                controller: screenshotController,
                child: PieChartImpl(
                  textColor: Colors.white,
                  dataMap: _getPieChartData(),
                ),
              )
            ],
          ),
        ),
        barrierColor: Colors.white.withOpacity(0.7),
        pillColor: Colors.white);
  }

  Map<String, double> _getPieChartData() {
    Map<String, double> dataMap = Map();
    dataMap.putIfAbsent("Total Cases : ${CoronaBloc().globalInfoDto$.cases}",
        () => CoronaBloc().globalInfoDto$.cases.toDouble());
    dataMap.putIfAbsent(
        "Total Recovered : ${CoronaBloc().globalInfoDto$.recovered}",
        () => CoronaBloc().globalInfoDto$.recovered.toDouble());
    dataMap.putIfAbsent("Total Deaths : ${CoronaBloc().globalInfoDto$.deaths}",
        () => CoronaBloc().globalInfoDto$.deaths.toDouble());

    return dataMap;
  }

  void _shareGlobalInfo() {
    var msg = CoronaBloc()
        .globalInfoDto$
        .toJson()
        .toString()
        .replaceAll("{", "")
        .replaceAll("}", "");

    msg = "Total Cases \n" + msg + '\n\n' + google_play_app_url;
    Share.share(msg, subject: "Total Global Info");
  }
}
