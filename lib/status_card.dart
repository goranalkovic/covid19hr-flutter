import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class DailyStatusCard extends StatelessWidget {
  const DailyStatusCard({
    Key key,
    @required this.currentNumber,
    @required this.title,
    this.color,
    this.delta,
    this.suffix,
    this.showLineAbove = false,
  }) : super(key: key);

  final num currentNumber;
  final int delta;
  final String title;
  final String suffix;
  final Color color;
  final bool showLineAbove;

  @override
  Widget build(BuildContext context) {
    final defaultColor = Theme.of(context).textTheme.bodyText1.color;

    final String deltaDisplay = delta == null
        ? ''
        : (delta > 0
            ? '+$delta'
            : delta == 0
                ? '—'
                : '$delta');

    return Container(
      width: 96,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showLineAbove)
            Container(
              width: 24,
              height: 3,
              color: color ?? Theme.of(context).textTheme.bodyText1.color,
              margin: const EdgeInsets.only(bottom: 6),
            ),
          Text(
            title,
            style: TextStyle(
              color: color ?? defaultColor,
              fontFamily: "DMSans",
              fontSize: 15,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedCrossFade(
                crossFadeState: currentNumber == null
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: Duration(milliseconds: 300),
                reverseDuration: Duration(milliseconds: 180),
                firstChild: Shimmer(
                  direction: ShimmerDirection.fromLeftToRight(),
                  color: color,
                  child: SizedBox(width: 76, height: 36),
                ),
                secondChild: Text(
                  '${(currentNumber ?? 0).toStringAsFixed(2).replaceAll(".00", "")}',
                  style: TextStyle(
                    fontSize: 27,
                    height: 1.25,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -2,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
              ),
              if (suffix != null)
                Container(
                  padding: const EdgeInsets.only(
                    top: 6,
                    left: 2,
                  ),
                  child: Text(
                    suffix,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                )
            ],
          ),
          if (delta != null)
            AnimatedCrossFade(
              crossFadeState:
                  delta < 0 && suffix == null && currentNumber == null
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
              duration: Duration(milliseconds: 500),
              firstChild: Shimmer(
                direction: ShimmerDirection.fromLeftToRight(),
                color: color,
                child: SizedBox(height: 18, width: 36),
              ),
              secondChild: Container(
                width: 36,
                child: Text(
                  deltaDisplay,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
