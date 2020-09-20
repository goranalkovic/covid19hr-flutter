import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final tableHeader = TextStyle(
  fontSize: 13,
  fontFamily: 'DMSans',
);

final tableItem = TextStyle(
  fontSize: 16,
  letterSpacing: -1,
  fontFeatures: [
    FontFeature.tabularFigures(),
  ],
);

final tableItemFooter = TextStyle(color: Colors.grey);

Color totalColor = Colors.blueGrey;
Color deathsColor = Colors.red;
Color recoveriesColor = Colors.lightGreen;
Color activeColor = Colors.lightBlue;

final totalColorDark = Colors.blueGrey[300];
final deathsColorDark = Colors.red[300];
final recoveriesColorDark = Colors.lightGreen[300];
final activeColorDark = Colors.lightBlue[300];

final totalColorLight = Colors.blueGrey;
final deathsColorLight = Colors.red;
final recoveriesColorLight = Colors.lightGreen;
final activeColorLight = Colors.lightBlue;
