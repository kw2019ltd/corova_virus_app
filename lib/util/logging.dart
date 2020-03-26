import 'package:corovavirusapp/util/constance.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

// logging

final Logger logger = Logger("corona_app");

void initLog() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    if (!isProductionMode) {
      print('${rec.level.name}: ${rec.time}: ${rec.message} : ${rec.error}');
      if (rec.stackTrace != null) {
        debugPrint('${rec.level.name}: ${rec.time}: ${rec.stackTrace}');
      }
    }
  });
}

// flutter error
void initFlutterError() {
  FlutterError.onError = (FlutterErrorDetails details) {
    if (!isProductionMode) {
      // In development mode simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      //   FireBaseManager().crashlytics.recordFlutterError(details);
    }
  };
}
