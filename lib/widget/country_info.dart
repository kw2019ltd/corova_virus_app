import 'package:corovavirusapp/dto/countries_info_dto.dart';
import 'package:corovavirusapp/repository/corona_bloc.dart';
import 'package:corovavirusapp/repository/shared_preferences.dart';
import 'package:corovavirusapp/util/constance.dart';
import 'package:corovavirusapp/widget/config/widget_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';

class CountryInfoWidget extends StatelessWidget {
  final CountriesInfoDto countriesInfoDto;
  final bool showCountry;

  CountryInfoWidget({this.showCountry = true, this.countriesInfoDto, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Slidable(
        enabled: showCountry,
        actionPane: const SlidableDrawerActionPane(),
        secondaryActions: _buildSecondaryActions(context),
        child: ListTile(
          onTap: () {
            CoronaBloc().getCountriesInfoTimeLine(countriesInfoDto.country);
            if (!showCountry) {
              Navigator.popAndPushNamed(context, countryChartRoute,
                  arguments: countriesInfoDto);
            } else {
              Navigator.pushNamed(context, countryChartRoute,
                  arguments: countriesInfoDto);
            }
          },
          title: Text(
            showCountry ? countriesInfoDto.country : "",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          trailing: _FavoriteWidget(
            country: countriesInfoDto.country,
          ),
          subtitle: RichText(
            text: TextSpan(
              text: 'Cases: ',
              style: DefaultTextStyle.of(context).style.copyWith(fontSize: 14),
              children: <TextSpan>[
                TextSpan(
                  text: '${countriesInfoDto.cases}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[600],
                    fontSize: 16,
                  ),
                ),
                TextSpan(text: ' | Today: '),
                TextSpan(
                  text: '${countriesInfoDto.todayCases}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[600],
                    fontSize: 16,
                  ),
                ),
                TextSpan(text: ' | Active: '),
                TextSpan(
                  text: '${countriesInfoDto.active}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[600],
                    fontSize: 16,
                  ),
                ),
                TextSpan(text: '\nDeaths: '),
                TextSpan(
                  text: '${countriesInfoDto.deaths}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red[600],
                    fontSize: 16,
                  ),
                ),
                TextSpan(text: ' | Today : '),
                TextSpan(
                  text: '${countriesInfoDto.todayDeaths}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red[600],
                    fontSize: 16,
                  ),
                ),
                TextSpan(text: '\nRecovered: '),
                TextSpan(
                  text: '${countriesInfoDto.recovered}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[600],
                      fontSize: 16),
                ),
                TextSpan(text: ' | Critical : '),
                TextSpan(
                  text: '${countriesInfoDto.critical}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green[600],
                    fontSize: 16,
                  ),
                ),
                TextSpan(text: '\nCasesPerOneMillion: '),
                TextSpan(
                  text: '${countriesInfoDto.casesPerOneMillion}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSecondaryActions(BuildContext context) {
    final List<Widget> secondaryActions = [_buildShareIconSlideAction(context)];
    return secondaryActions;
  }

  IconSlideAction _buildShareIconSlideAction(BuildContext context) {
    return IconSlideAction(
      caption: 'Share',
      color: Theme.of(context).primaryColor,
      icon: FontAwesomeIcons.share,
      onTap: _sharePrice,
    );
  }

  void _sharePrice() {
//    FireBaseManager().analytics.logShare(
//        contentType: share_app_button,
//        itemId: share_app_button_list_title,
//        method: share_app_button_list_title);
    var msg = countriesInfoDto
        .toJson()
        .toString()
        .replaceAll("{", "")
        .replaceAll("}", "");

    msg = msg + '\n\n' + google_play_app_url;
    Share.share(msg);
  }
}

class _FavoriteWidget extends StatefulWidget {
  final String country;

  const _FavoriteWidget({this.country, Key key}) : super(key: key);

  @override
  __FavoriteWidgetState createState() => __FavoriteWidgetState();
}

class __FavoriteWidgetState extends State<_FavoriteWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isFavorite =
        CoronaSharedPreferences().favoriteList.contains(widget.country);

    return IconButton(
      tooltip: "Add To Favorite",
      icon: Icon(
          isFavorite ? FontAwesomeIcons.solidStar : FontAwesomeIcons.star,
          color: isFavorite
              ? CoronaSharedPreferences().darkThemeOn
                  ? Colors.yellowAccent
                  : Colors.yellowAccent[700]
              : CoronaSharedPreferences().darkThemeOn
                  ? Theme.of(context).hintColor
                  : Theme.of(context).primaryColor),
      onPressed: () {
        setState(
          () {
            if (isFavorite) {
              CoronaSharedPreferences().removeFavoriteCountry(widget.country);
            } else {
              CoronaSharedPreferences().addFavoriteCountry(widget.country);
            }
            if (CoronaSharedPreferences().showFavorite) {
              CoronaBloc()
                  .favoriteEventBehaviorSubject$
                  .add(FAVORITE_EVENT.SHOW_FAVORITE);
            }
          },
        );
      },
    );
  }
}
