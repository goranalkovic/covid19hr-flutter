import 'dart:ui';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

final tableHeader = TextStyle(
  fontSize: 13,
  fontFamily: 'DMSans',
);

final tableItem = TextStyle(
  fontSize: 14,
  letterSpacing: -1,
  fontFeatures: [
    FontFeature.tabularFigures(),
  ],
);

final tableItemFooter = TextStyle(color: Colors.grey, fontSize: 12);

Color totalColor = Colors.blueGrey;
Color deathsColor = Colors.red;
Color recoveriesColor = Colors.lightGreen;
Color activeColor = Colors.lightBlue;
Color contrastingColor = Colors.grey.shade900;

final totalColorDark = Colors.blueGrey[300];
final deathsColorDark = Colors.red[300];
final recoveriesColorDark = Colors.lightGreen[300];
final activeColorDark = Colors.lightBlue[300];
final contrastingColorDark = Colors.grey.shade100;

final totalColorLight = Colors.blueGrey;
final deathsColorLight = Colors.red;
final recoveriesColorLight = Colors.lightGreen;
final activeColorLight = Colors.lightBlue;
final contrastingColorLight = Colors.grey.shade900;

WindowButtonColors buttonColors = WindowButtonColors(
  iconNormal: contrastingColor.withOpacity(0.75),
  mouseOver: contrastingColor.withOpacity(0.1),
  mouseDown: contrastingColor.withOpacity(0.15),
  iconMouseOver: activeColor,
  iconMouseDown: activeColor,
);

WindowButtonColors closeButtonColors = WindowButtonColors(
  mouseOver: Color(0xFFD32F2F),
  mouseDown: Color(0xFFB71C1C),
  iconNormal: contrastingColor.withOpacity(0.75),
  iconMouseOver: Colors.white,
);

final defaultTabBarTheme = TabBarTheme(
  labelStyle: TextStyle(fontFamily: 'DM Sans'),
  unselectedLabelStyle: TextStyle(fontFamily: 'DM Sans'),
  unselectedLabelColor: Colors.grey[800],
  labelColor: Colors.deepPurple,
  indicator: UnderlineTabIndicator(
    borderSide: BorderSide(
        color: Colors.transparent, width: 0, style: BorderStyle.none),
  ),
);

final defaultAppBarTheme = AppBarTheme(
  elevation: 0,
  centerTitle: true,
);

launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    // throw 'Could not launch $url';
  }
}
