import 'package:covid19hr/model.dart';
import 'package:flutter/material.dart';

import '../styles.dart';
import './status_blocks.dart';

class DayStats extends StatelessWidget {
  final bool isCollapsed;
  final GenericDataRecord item;

  const DayStats({
    Key key,
    @required this.item,
    this.isCollapsed = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var firstTwo = [
      getCurrentDataRowItem(
        context,
        'Ukupno',
        item?.totalCases,
        item?.deltaTotal,
        totalColor,
        isTotal: true,
        isCollapsed: isCollapsed,
      ),
      getCurrentDataRowItem(
        context,
        'Oporavljeni',
        item?.recoveries,
        item?.deltaRecoveries,
        recoveriesColor,
        isCollapsed: isCollapsed,
      ),
    ];

    var secondTwo = [
      getCurrentDataRowItem(
        context,
        'Umrli',
        item?.deaths,
        item?.deltaDeaths,
        deathsColor,
        isCollapsed: isCollapsed,
      ),
      getCurrentDataRowItem(
        context,
        'Aktivni',
        item?.activeCases,
        item?.deltaActive,
        activeColor,
        isCollapsed: isCollapsed,
      ),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.decelerate,
          height: isCollapsed ? 0 : 26,
          child: Text(
            'Najnoviji podaci',
            style: TextStyle(fontSize: 20),
          ),
        ),
        SizedBox(height: 16),
        Wrap(
          children: [
            ...firstTwo,
            if (MediaQuery.of(context).size.width > 890)
              ...secondTwo
            else if (MediaQuery.of(context).size.width > 420)
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: secondTwo,
              )
            else
              Wrap(
                children: secondTwo,
              ),
          ],
        ),
      ],
    );
  }
}
