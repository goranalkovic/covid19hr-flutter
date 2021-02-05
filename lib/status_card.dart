import 'dart:ui';

import 'package:covid19hr/appstate.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import 'package:provider/provider.dart';

class DailyStatusCard extends StatelessWidget {
  const DailyStatusCard({
    Key key,
    @required this.title,
    this.currentNumber,
    this.currentValue,
    this.color,
    this.delta,
    this.deltaTxt,
    this.suffix,
    this.showLineAbove = false,
    this.isLarge = true,
  }) : super(key: key);

  final num currentNumber;
  final String currentValue;
  final int delta;
  final String deltaTxt;
  final String title;
  final String suffix;
  final Color color;
  final bool showLineAbove;
  final bool isLarge;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<Covid19Provider>();

    final defaultColor = Theme.of(context).textTheme.bodyText1.color;

    final String deltaDisplay = provider.loading
        ? ''
        : delta == null && deltaTxt == null
            ? ''
            : deltaTxt == null
                ? (delta > 0
                    ? '+$delta'
                    : delta == 0
                        ? '—'
                        : '$delta')
                : deltaTxt;

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // if (showLineAbove)
          //   Container(
          //     width: 24,
          //     height: 3,
          //     color: color ?? Theme.of(context).textTheme.bodyText1.color,
          //     margin: const EdgeInsets.only(bottom: 6),
          //   ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color ?? defaultColor,
              fontFamily: "DMSans",
              fontSize: isLarge ? 15 : 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedCrossFade(
                crossFadeState: currentNumber == null && currentValue == null
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: Duration(milliseconds: 300),
                reverseDuration: Duration(milliseconds: 180),
                firstChild: Shimmer(
                  direction: ShimmerDirection.fromLeftToRight(),
                  color: color,
                  child: SizedBox(
                      width: isLarge ? 106 : 76, height: isLarge ? 66 : 36),
                ),
                secondChild: currentNumber == null
                    ? (currentValue == null
                        ? Container()
                        : Text(
                            currentValue,
                            style: TextStyle(
                              fontSize: isLarge ? 44 : 27,
                              height: 1.25,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -2,
                              fontFeatures: [FontFeature.tabularFigures()],
                            ),
                          ))
                    : Text(
                        '${(currentNumber ?? 0).toStringAsFixed(2).replaceAll(".00", "")}',
                        style: TextStyle(
                          fontSize: isLarge ? 44 : 27,
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
          if (delta != null || deltaTxt != null)
            AnimatedCrossFade(
              crossFadeState: provider.loading == true
                  //  ||
                  //         ((delta != null && delta < 0) &&
                  //             suffix == null &&
                  //             currentNumber == null)
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: Duration(milliseconds: 500),
              firstChild: Shimmer(
                direction: ShimmerDirection.fromLeftToRight(),
                color: color,
                child: SizedBox(
                  height: isLarge ? 24 : 18,
                  width: isLarge ? 80 : 56,
                ),
              ),
              secondChild: Container(
                child: Text(
                  deltaDisplay,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: isLarge ? 24 : 14,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
