import 'package:corovavirusapp/dto/usa/usa_state_info.dart';
import 'package:corovavirusapp/repository/corona_bloc.dart';
import 'package:corovavirusapp/util/constance.dart';
import 'package:corovavirusapp/widget/config/widget_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';

class UsaWidget extends StatefulWidget {
  @override
  _UsaWidgetState createState() => _UsaWidgetState();
}

class _UsaWidgetState extends State<UsaWidget> {
  @override
  void initState() {
    CoronaBloc().getUsaStateInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<List<UsaStateInfo>>(
        stream: CoronaBloc().usaStateInfoBehaviorSubject$.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.isEmpty) {
              return buildDisplayContentSizeBox(
                  ApiErrorWidget(_refreshIconOnPressed), context);
            }

            List<UsaStateInfo> usaStateInfosDto = snapshot.data;

            return AnimationLimiter(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: usaStateInfosDto.length,
                itemBuilder: (BuildContext context, int index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: UsaInfoWidget(
                          usaInfoDto: usaStateInfosDto[index],
                          key: Key(usaStateInfosDto[index].state),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (snapshot.hasError) {
            return buildDisplayContentSizeBox(
                ApiErrorWidget(_refreshIconOnPressed), context);
          }
          return buildDisplayContentSizeBox(const ProgressBarWidget(), context);
        },
      ),
    );
  }

  void _refreshIconOnPressed() async {
    await Future.value(
      [CoronaBloc().getUsaStateInfo()],
    );
  }
}

class UsaInfoWidget extends StatelessWidget {
  final UsaStateInfo usaInfoDto;

  UsaInfoWidget({this.usaInfoDto, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Slidable(
        actionPane: const SlidableDrawerActionPane(),
        secondaryActions: _buildSecondaryActions(context),
        child: ListTile(
          onTap: () {},
          title: Text(
            usaInfoDto.state,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          subtitle: RichText(
            text: TextSpan(
              text: 'Cases: ',
              style: DefaultTextStyle.of(context).style.copyWith(fontSize: 14),
              children: <TextSpan>[
                TextSpan(
                  text: '${usaInfoDto.cases}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[600],
                    fontSize: 16,
                  ),
                ),
                TextSpan(text: ' | Today: '),
                TextSpan(
                  text: '${usaInfoDto.todayCases}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[600],
                    fontSize: 16,
                  ),
                ),
                TextSpan(text: ' | Active: '),
                TextSpan(
                  text: '${usaInfoDto.active}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[600],
                    fontSize: 16,
                  ),
                ),
                TextSpan(text: '\nDeaths: '),
                TextSpan(
                  text: '${usaInfoDto.deaths}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red[600],
                    fontSize: 16,
                  ),
                ),
                TextSpan(text: ' | Today : '),
                TextSpan(
                  text: '${usaInfoDto.todayDeaths}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red[600],
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
    var msg =
        usaInfoDto.toJson().toString().replaceAll("{", "").replaceAll("}", "");

    msg = msg + '\n\n' + google_play_app_url;
    Share.share(msg);
  }
}
