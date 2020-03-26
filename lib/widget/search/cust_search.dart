import 'package:corovavirusapp/dto/countries_info_dto.dart';
import 'package:corovavirusapp/repository/corona_bloc.dart';
import 'package:corovavirusapp/repository/shared_preferences.dart';
import 'package:corovavirusapp/widget/config/widget_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSearchDelegate extends SearchDelegate<dynamic> {
  CustomSearchDelegate()
      : super(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(
          Icons.clear,
        ),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return this.buildSuggestion(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return this.buildSuggestion(context);
  }

  Widget buildSuggestion(BuildContext context) {
    if (CoronaBloc().countriesInfoDto$ != null) {
      List<CountriesInfoDto> countriesInfoDto = [];
      countriesInfoDto = CoronaBloc()
          .countriesInfoDto$
          .where(
            (item) => item.country.toLowerCase().contains(
                  query.toLowerCase(),
                ),
          )
          .toList();
      if (countriesInfoDto.isEmpty) {
        return Container(
          child: Center(
            child: Text(
              'Country not found !',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        );
      }
      return ListView.separated(
        separatorBuilder: (_, __) => const Divider(),
        itemCount: countriesInfoDto.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: RichText(
              text: TextSpan(
                text: '${countriesInfoDto[index].country}\n',
                style: GoogleFonts.varelaRound(
                  color: Theme.of(context).hintColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: '${(index + 1).toString()}',
                    style: TextStyle(
                      fontSize: 10,
                      color: CoronaSharedPreferences().darkThemeOn
                          ? Colors.grey[500]
                          : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            trailing: CircleAvatar(
              backgroundColor: Theme.of(context).backgroundColor,
              radius: 15,
              child: Image(
                image: NetworkImage(countriesInfoDto[index].countryInfo.flag),
                fit: BoxFit.fill,
              ),
            ),
            onTap: () {
              close(context, null);
              Navigator.pushNamed(
                context,
                countrySearchRoute,
                arguments: countriesInfoDto[index],
              );
            },
          );
        },
      );
    } else {
      return Container(
        child: Center(
          child: Text(
            'No Country to display !',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      );
    }
  }
}
