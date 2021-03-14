import 'dart:io';
import 'dart:ui';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:covid19hr/app_logo.dart';
import 'package:covid19hr/appstate.dart';
import 'package:covid19hr/footer.dart';
import 'package:covid19hr/generic_chart.dart';
import 'package:covid19hr/mobile_home.dart';
import 'package:covid19hr/desktop_home.dart';
import 'package:covid19hr/styles.dart';
import 'package:covid19hr/table_view.dart';
import 'package:covid19hr/titled_card.dart';
import 'package:covid19hr/ui_blocks/day_summary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  runApp(MyApp(savedThemeMode: savedThemeMode));

  doWhenWindowReady(() {
    final initialSize = Size(890, 648);
    appWindow.minSize = Size(480, 640);
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode savedThemeMode;

  const MyApp({Key key, this.savedThemeMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    if (!kIsWeb) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarIconBrightness: brightness,
        statusBarBrightness: brightness,
        systemNavigationBarIconBrightness: brightness,
      ));

      if (Platform.isIOS || Platform.isAndroid && !kIsWeb) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
        ));
      }
    }

    TextTheme lightTextTheme =
        ThemeData.light().textTheme.apply(fontFamily: 'Inter');
    TextTheme darkTextTheme =
        ThemeData.dark().textTheme.apply(fontFamily: 'Inter');

    return AdaptiveTheme(
      light: ThemeData.light().copyWith(
        primaryColor: Colors.white,
        accentColor: Colors.deepPurple,
        textTheme: lightTextTheme,
        scaffoldBackgroundColor: Colors.white,
        tabBarTheme: defaultTabBarTheme,
        appBarTheme: defaultAppBarTheme.copyWith(
          color: Colors.white,
          actionsIconTheme:
              IconThemeData(color: lightTextTheme.bodyText1.color),
          brightness: Brightness.light,
        ),
        toggleableActiveColor: Colors.deepPurple,
        sliderTheme: ThemeData.light().sliderTheme.copyWith(
              thumbColor: Colors.deepPurple,
              activeTrackColor: Colors.grey[100],
              inactiveTrackColor: Colors.grey[100],
              activeTickMarkColor: Colors.grey,
              inactiveTickMarkColor: Colors.grey,
              overlayColor: Colors.deepPurple.withOpacity(0.1),
              trackHeight: 6,
            ),
      ),
      dark: ThemeData.dark().copyWith(
        primaryColor: Colors.deepPurple[400],
        accentColor: Colors.deepPurple[300],
        scaffoldBackgroundColor: Color(0xff202020),
        textTheme: darkTextTheme,
        tabBarTheme: defaultTabBarTheme.copyWith(
          unselectedLabelColor: Colors.grey[100],
          labelColor: Colors.deepPurple[300],
        ),
        appBarTheme: defaultAppBarTheme.copyWith(
          actionsIconTheme: IconThemeData(color: darkTextTheme.bodyText1.color),
          brightness: Brightness.dark,
          color: Color(0xff202020),
        ),
        toggleableActiveColor: Colors.deepPurple[300],
        sliderTheme: ThemeData.dark().sliderTheme.copyWith(
              thumbColor: Colors.deepPurple[300],
              activeTrackColor: Colors.grey[850],
              inactiveTrackColor: Colors.grey[850],
              activeTickMarkColor: Colors.grey,
              inactiveTickMarkColor: Colors.grey,
              overlayColor: Colors.deepPurple[300].withOpacity(0.1),
              trackHeight: 6,
            ),
      ),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (light, dark) => MaterialApp(
        // themeMode: ThemeMode.dark,
        title: 'COVID-19 podaci',
        debugShowCheckedModeBanner: false,
        home: ChangeNotifierProvider(
          create: (_) => Covid19Provider(),
          child: Scaffold(
            body: HomePage(),
          ),
        ),
        theme: light,
        darkTheme: dark,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    totalColor = isDark ? totalColorDark : totalColorLight;
    recoveriesColor = isDark ? recoveriesColorDark : recoveriesColorLight;
    deathsColor = isDark ? deathsColorDark : deathsColorLight;
    activeColor = isDark ? activeColorDark : activeColorLight;
    contrastingColor = isDark ? contrastingColorDark : contrastingColorLight;

    buttonColors = WindowButtonColors(
      iconNormal: contrastingColor.withOpacity(0.75),
      mouseOver: contrastingColor.withOpacity(0.1),
      mouseDown: contrastingColor.withOpacity(0.15),
      iconMouseOver: activeColor,
      iconMouseDown: activeColor,
    );

    closeButtonColors = WindowButtonColors(
      mouseOver: Color(0xFFD32F2F),
      mouseDown: Color(0xFFB71C1C),
      iconNormal: contrastingColor.withOpacity(0.75),
      iconMouseOver: Colors.white,
    );

    bool isWide = MediaQuery.of(context).size.width > 800;

    if (isWide) {
      return DesktopHome();
    } else {
      return MobileHome();
    }
  }
}
