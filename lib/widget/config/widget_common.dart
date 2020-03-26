import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animations/loading_animations.dart';

class ProgressBarWidget extends StatelessWidget {
  const ProgressBarWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingBouncingGrid.circle(
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}

const divider = Divider();

const sizedBox_Drawer = SizedBox(
  width: 10,
);

// display in middle of sticky header
SizedBox buildDisplayContentSizeBox(Widget widget, BuildContext context) {
  return SizedBox(
    child: widget,
    height: MediaQuery.of(context).size.height / 2,
  );
}

class ApiErrorWidget extends StatelessWidget {
  final VoidCallback callback;

  const ApiErrorWidget(this.callback, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    checkConnectivityAndDisplayMsg(context);
    return SafeArea(
      child: Center(
        child: Row(
          textDirection: TextDirection.ltr,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('failed to retrieve data\n\nplease try again',
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).dividerColor,
                    fontSize: 17)),
            IconButton(
              onPressed: () async {
                showToast("retrieving data....", context);
                callback();
              },
              icon: Icon(
                FontAwesomeIcons.sync,
                color: Theme.of(context).dividerColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> checkConnectivityAndDisplayMsg(BuildContext context) async {
  final ConnectivityResult connectivityResult =
      await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.none) {
    showToast('No internet access', context);
  } else {
    showToast('failed to retrieve data', context);
  }
}

void showToast(String msg, BuildContext context,
    {Toast toastLength, Color textColor, Color backgroundColor}) {
  Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.BOTTOM,
      toastLength: toastLength ?? Toast.LENGTH_SHORT,
      backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
      textColor: textColor ?? Theme.of(context).indicatorColor);
}
