import 'dart:math';

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

    return Container(
      width: 96,
      // color: Colors.red[50],
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
              fontWeight: FontWeight.w400,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (currentNumber == null)
                Shimmer(
                  direction: ShimmerDirection.fromLeftToRight(),
                  color: color,
                  child: SizedBox(
                    height: 32,
                    width: 64,
                  ),
                )
              else
                Text(
                  '${currentNumber.toStringAsFixed(2).replaceAll(".00", "")}',
                  style: TextStyle(
                    fontSize: 30,
                    height: 1.25,
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
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                )
            ],
          ),
          if (delta != null)
            Container(
              width: 36,
              child: Text(
                delta > 0 ? '+$delta' : delta == 0 ? '—' : '$delta',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
          if (delta == null && suffix == null && currentNumber == null)
            Shimmer(
                direction: ShimmerDirection.fromLeftToRight(),
                child: SizedBox(
                  height: 18,
                  width: 20,
                ))
        ],
      ),
    );
  }
}
