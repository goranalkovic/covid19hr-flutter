import 'dart:ui';

import 'package:covid19hr/model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../appstate.dart';
import '../styles.dart';
import 'status_blocks.dart';

class DayCaseRatios extends StatelessWidget {
  final GenericDataRecord item;
  final bool isCollapsed;

  const DayCaseRatios({Key key, @required this.item, this.isCollapsed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<Covid19Provider>();

    double recoveriesRatio = 0;
    double deathsRatio = 0;
    double activeRatio = 0;

    if (!provider.loading && item != null) {
      recoveriesRatio = item.recoveries / item.totalCases;
      deathsRatio = item.deaths / item.totalCases;
      activeRatio = item.activeCases / item.totalCases;

      if ((recoveriesRatio + activeRatio + deathsRatio) > 1) {
        recoveriesRatio -= ((recoveriesRatio + activeRatio + deathsRatio) - 1);
      }
    }

    return Column(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.decelerate,
          height: isCollapsed ? 0 : 26,
          child: Text(
            'Raspodjela slučajeva',
            style: TextStyle(fontSize: 20),
          ),
        ),
        SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            getDailyStatBlock(
              'Oporavljeni',
              recoveriesRatio,
              recoveriesColor,
              isCollapsed: isCollapsed,
            ),
            getDailyStatBlock(
              'Umrli',
              deathsRatio,
              deathsColor,
              isCollapsed: isCollapsed,
            ),
            getDailyStatBlock(
              'Aktivni',
              activeRatio,
              activeColor,
              isCollapsed: isCollapsed,
            ),
          ],
        ),
      ],
    );
  }
}
