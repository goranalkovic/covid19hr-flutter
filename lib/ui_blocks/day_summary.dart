import 'package:covid19hr/components/day_case_ratios.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../appstate.dart';
import '../model.dart';
import '../components/day_stats.dart';

class DaySummary extends StatelessWidget {
  final bool isShrunk;

  DaySummary({this.isShrunk = false});
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<Covid19Provider>();

    GenericDataRecord currentItem;

    if (!provider.loading && provider.data.isNotEmpty) {
      if (provider.county == null) {
        currentItem = GenericDataRecord.fromGlobal(provider.globalRecords.last);
      } else {
        currentItem = GenericDataRecord.fromCounty(
            provider.countyRecords.last.records.firstWhere(
                (CountyDataRecord r) => r.countyName == provider.county),
            provider.countyRecords.last.date);
      }
    }

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: isShrunk ? 24 : 32,
              runSpacing: isShrunk ? 0 : 20,
              children: [
                DayStats(
                  item: currentItem,
                  isCollapsed: isShrunk,
                ),
                if (!isShrunk ||
                    isShrunk && MediaQuery.of(context).size.width > 900)
                  DayCaseRatios(
                    isCollapsed: isShrunk,
                    item: currentItem,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
