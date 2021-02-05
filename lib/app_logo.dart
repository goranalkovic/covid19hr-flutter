import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  final bool isLarge;
  final bool isHuge;
  const AppTitle({
    Key key,
    this.isLarge = false,
    this.isHuge = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.flare_rounded,
          color: Theme.of(context).accentColor,
          size: isHuge
              ? 30
              : isLarge
                  ? 24
                  : 18,
        ),
        SizedBox(width: 6),
        Text(
          'COVID-19',
          style: TextStyle(
            fontFamily: "DMSans",
            fontWeight: FontWeight.normal,
            color: Theme.of(context).textTheme.bodyText1.color,
            fontSize: isHuge
                ? 34
                : isLarge
                    ? 24
                    : 18,
          ),
        ),
        Text(
          'HR',
          style: TextStyle(
            fontFamily: "DMSans",
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.deepPurple
                : Colors.deepPurple[200],
            fontSize: isHuge
                ? 34
                : isLarge
                    ? 24
                    : 18,
          ),
        ),
      ],
    );
  }
}
