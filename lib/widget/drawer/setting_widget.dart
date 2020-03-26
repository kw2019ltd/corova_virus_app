import 'package:corovavirusapp/util/package_Info.dart';
import 'package:flutter/material.dart';

class AppInfoWidget extends StatelessWidget {
  const AppInfoWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('App info'),
          centerTitle: true,
        ),
        body: Stack(
          overflow: Overflow.visible,
          fit: StackFit.expand,
          children: <Widget>[
            Center(
              child: ListView(
                children: <Widget>[
                  const SizedBox(
                    height: 100,
                  ),
                  _AppInfoTextRowWidget('App name:', appName),
                  _AppInfoTextRowWidget('App version:', version),
                  _AppInfoTextRowWidget('Build number:', buildNumber),
                ],
              ),
            )
          ],
        ));
  }
}

class _AppInfoTextRowWidget extends StatelessWidget {
  final String _text;
  final String _value;

  const _AppInfoTextRowWidget(this._text, this._value, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        _value,
        softWrap: true,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: Text(
        _text,
        softWrap: true,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
    );
  }
}
