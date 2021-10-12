import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'config/router_manager.dart';
import 'config/storage_manager.dart';
import 'generated/l10n.dart';
import 'package:flutter_k_chart/generated/l10n.dart' as k_chart;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageManager.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      theme: ThemeData(fontFamily: 'openSans'),
      // 你的翻译
      // locale: ui.window.locale,
      initialRoute: RouteConfig.splash,
      title: 'Huobi Globol',
      debugShowCheckedModeBanner: false,
      getPages: RouteConfig.getPages,
      defaultTransition: Transition.cupertino,
      transitionDuration: Duration(milliseconds: 500),
      localizationsDelegates: const [
        S.delegate,
        k_chart.S.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
    );
  }
}
