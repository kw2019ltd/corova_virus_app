import 'package:corovavirusapp/repository/corona_bloc.dart';
import 'package:corovavirusapp/util/constance.dart';
import 'package:corovavirusapp/util/package_Info.dart';
import 'package:corovavirusapp/widget/config/widget_config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).backgroundColor.withOpacity(0.5),
        child: ListView(
          padding: const EdgeInsets.only(top: 0.0),
          children: <Widget>[
            _UserAccountsDrawerHeaderWidget(),
            _buildShareListTile(context),
            Divider(
              height: 1,
            ),
            _buildYoutubeGuideListTile(context),
            Divider(
              height: 1,
            ),
            _buildMailListTile(context),
            Divider(
              height: 1,
            ),
            _buildRateUsListTile(context),
            Divider(
              height: 1,
            ),
            _buildTermAndPolicyListTile(context),
            Divider(
              height: 1,
            ),
            _buildAppInfoListTile(context),
          ],
        ),
      ),
    );
  }

  ListTile _buildShareListTile(BuildContext context) {
    return ListTile(
      title: _buildDrawerRow('Share app', FontAwesomeIcons.share, context),
      onTap: () {
//        FireBaseManager().sendAnalyticsShareEvent(
//          contentType: share_app_button,
//          itemId: share_app_button,
//          method: "DrawerWidget",
//        );
//        Share.share(
//          google_play_app_url,
//          subject: appName,
//        );
      },
    );
  }

  Row _buildDrawerRow(String text, IconData iconData, BuildContext context) {
    return Row(children: <Widget>[
      Icon(
        iconData,
        size: 24,
      ),
      const SizedBox(
        width: 20,
      ),
      Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    ]);
  }

  ListTile _buildAppInfoListTile(BuildContext context) {
    return ListTile(
      title: _buildDrawerRow('App info', FontAwesomeIcons.infoCircle, context),
      onTap: () {
        Navigator.pushNamed(context, appInfoRoute);
      },
    );
  }

  ListTile _buildMailListTile(BuildContext context) {
    return ListTile(
      title: _buildDrawerRow('Contact us', FontAwesomeIcons.mailBulk, context),
      onTap: () {
        _launchURL(app_mail_url);
      },
    );
  }

  ListTile _buildRateUsListTile(BuildContext context) {
    return ListTile(
      title: _buildDrawerRow('Rate us', FontAwesomeIcons.solidStar, context),
      onTap: () {
        _launchURL(google_play_app_rate_url);
      },
    );
  }

  ListTile _buildYoutubeGuideListTile(BuildContext context) {
    return ListTile(
      title: _buildDrawerRow('App guide', FontAwesomeIcons.youtube, context),
      onTap: () {
        _launchURL(youtube_guide_url);
      },
    );
  }

  ListTile _buildTermAndPolicyListTile(BuildContext context) {
    return ListTile(
      title: _buildDrawerRow(
          'Term And Privacy Policy', FontAwesomeIcons.shieldAlt, context),
      onTap: () {
        _launchURL(app_main_site_url);
      },
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, enableJavaScript: true);
    }
  }
}

class _UserAccountsDrawerHeaderWidget extends StatelessWidget {
  const _UserAccountsDrawerHeaderWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      accountName: Text(
        '$appName',
        textAlign: TextAlign.right,
        style: GoogleFonts.concertOne(fontSize: 17),
      ),
      accountEmail: Padding(
          padding: const EdgeInsets.only(bottom: 20, top: 10),
          child: Text(
            '${CoronaBloc().globalInfoDto$?.updatedDate ?? ""}',
            textAlign: TextAlign.right,
            style: GoogleFonts.concertOne(fontSize: 17),
          )),
      currentAccountPicture: const Image(
        image: AssetImage(
          imageAppIcon,
        ),
      ),
    );
  }
}
