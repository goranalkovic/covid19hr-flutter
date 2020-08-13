import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.flare_rounded,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.deepPurple
              : Colors.deepPurple[100],
        ),
        SizedBox(width: 6),
        Text(
          'COVID-19 podaci',
          style: TextStyle(
            fontFamily:
                GoogleFonts.sourceCodeProTextTheme().bodyText1.fontFamily,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyText1.color,
          ),
        ),
      ],
    );
  }
}
