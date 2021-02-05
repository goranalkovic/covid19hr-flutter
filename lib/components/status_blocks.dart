import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import '../appstate.dart';

DataRow getCurrentDataRow(BuildContext context, String title, int numberOfCases,
    int delta, Color categoryColor,
    {bool isTotal = false}) {
  final provider = context.watch<Covid19Provider>();
  NumberFormat formatter = NumberFormat('###,###,###');

  final String deltaDisplay = (provider.loading || delta == null)
      ? ''
      : (delta > 0)
          ? '+${formatter.format(delta)}'
          : delta == 0
              ? '—'
              : '${formatter.format(delta)}';

  final String numOfCases = (provider.loading || numberOfCases == null)
      ? ''
      : formatter.format(numberOfCases);

  return DataRow(
    cells: [
      DataCell(
        Text(
          title,
          style: TextStyle(
            color: categoryColor,
            fontSize: 15,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
            fontFamily: 'DMSans',
          ),
        ),
      ),
      DataCell(
        Text(
          '$numOfCases',
          style: TextStyle(
            fontSize: isTotal ? 20 : 16,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            // fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
      ),
      DataCell(
        Text(
          '$deltaDisplay',
          style: TextStyle(
            color: Colors.grey,
            fontSize: isTotal ? 18 : 15,
          ),
        ),
      ),
    ],
  );
}

TableRow getCurrentTableRow(BuildContext context, String title,
    int numberOfCases, int delta, Color categoryColor,
    {bool isTotal = false, bool reverse = false}) {
  final provider = context.watch<Covid19Provider>();
  NumberFormat formatter = NumberFormat('###,###,###');

  final String deltaDisplay = (provider.loading || delta == null)
      ? ''
      : (delta > 0)
          ? '+${formatter.format(delta)}'
          : delta == 0
              ? '—'
              : '${formatter.format(delta)}';

  final String numOfCases = (provider.loading || numberOfCases == null)
      ? ''
      : formatter.format(numberOfCases);

  return TableRow(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: TableCell(
          child: Text(
            title,
            style: TextStyle(
              color: categoryColor,
              fontSize: isTotal ? 19 : 16,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
              fontFamily: 'DMSans',
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: TableCell(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              '${reverse ? numOfCases : deltaDisplay}',
              style: TextStyle(
                fontSize: isTotal ? 24 : 18,
                fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
                // fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: TableCell(
          child: Text(
            '${reverse ? deltaDisplay : numOfCases}',
            style: TextStyle(
              color:
                  Theme.of(context).textTheme.bodyText1.color.withOpacity(0.5),
              fontSize: isTotal ? 24 : 18,
            ),
          ),
        ),
      ),
    ],
  );
}

Widget getCurrentDataRowItem(BuildContext context, String title,
    int numberOfCases, int delta, Color categoryColor,
    {bool isTotal = false,
    bool isCollapsed = false,
    bool isDeltaCollapsed = true,
    bool isDeltaSwapped = false}) {
  final provider = context.watch<Covid19Provider>();
  NumberFormat formatter = NumberFormat('###,###,###');

  final String deltaDisplay = (provider.loading || delta == null)
      ? ''
      : (delta > 0)
          ? '+${formatter.format(delta)}'
          : delta == 0
              ? '—'
              : '${formatter.format(delta)}';

  final String numOfCases = (provider.loading || numberOfCases == null)
      ? ''
      : formatter.format(numberOfCases);

  return AnimatedContainer(
    duration: Duration(milliseconds: 300),
    curve: Curves.decelerate,
    width: isCollapsed ? 120 : 200,
    height: (isCollapsed ? 60.0 : 105.0) + (isDeltaCollapsed ? 0.0 : 14.0),
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    margin: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      border: Border.all(
        // color: Theme.of(context).dividerColor.withOpacity(0.08),
        color: categoryColor.withOpacity(0.4),
      ),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: categoryColor,
            fontSize: isCollapsed ? 14 : 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'DMSans',
          ),
        ),
        Text(
          isDeltaSwapped ? numOfCases : deltaDisplay,
          style: TextStyle(
            // fontSize: isTotal ? 40 : 32,
            fontSize: isCollapsed ? 20 : 38,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.normal,
            // fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
        Spacer(),
        AnimatedContainer(
          duration: Duration(milliseconds: 100),
          height: (isCollapsed ? 0.0 : 18.0) + (isDeltaCollapsed ? 0.0 : 12.0),
          child: Text(
            isDeltaSwapped ? deltaDisplay : numOfCases,
            style: TextStyle(
              color: Colors.grey,
              // fontSize: isTotal ? 20 : 18,
              fontSize: !isDeltaCollapsed ? 12 : 18,
            ),
          ),
        )
      ],
    ),
  );
}

Widget getDailyStatBlock(String title, double ratio, Color color,
    {bool isCollapsed = false}) {
  return AnimatedContainer(
    duration: Duration(milliseconds: 300),
    curve: Curves.decelerate,
    width: isCollapsed ? 110 : 200,
    height: isCollapsed ? 60 : 105,
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    margin: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      border: Border.all(
        color: color.withOpacity(0.4),
      ),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: isCollapsed ? 14 : 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'DMSans',
          ),
        ),
        Row(
          textBaseline: TextBaseline.alphabetic,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          children: [
            Text(
              '${(ratio * 100).toStringAsFixed(1)}',
              style: TextStyle(fontSize: isCollapsed ? 20 : 38),
            ),
            Text(
              '%',
              style: TextStyle(fontSize: isCollapsed ? 18 : 24),
            ),
          ],
        ),
        Spacer(),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.decelerate,
          height: isCollapsed ? 0 : 8,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: ratio,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              backgroundColor: color.withOpacity(0.16),
              minHeight: 8,
            ),
          ),
        ),
        AnimatedContainer(
          height: isCollapsed ? 0 : 3,
          duration: Duration(milliseconds: 300),
        ),
      ],
    ),
  );
}
