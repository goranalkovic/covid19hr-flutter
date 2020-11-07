import 'dart:math';

import 'package:covid19hr/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import 'appstate.dart';

class TableView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<Covid19Provider>();

    final data = provider.data;
    double chartHeight = 400;

    return SizedBox(
      // height: 140 + chartHeight,
      child: Column(
        children: [
          Container(
            height: 40,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.withOpacity(0.6),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 48,
                  child: Text('Datum', style: tableHeader),
                ),
                SizedBox(
                  width: 48,
                  child: Text('Ukupno', style: tableHeader),
                ),
                SizedBox(
                  width: 70,
                  child: Text('Oporavljeni', style: tableHeader),
                ),
                SizedBox(
                  width: 48,
                  child: Text('Umrli', style: tableHeader),
                ),
                SizedBox(
                  width: 48,
                  child: Text('Aktivni', style: tableHeader),
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            crossFadeState: provider.loading || provider.data.isEmpty
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: Duration(milliseconds: 300),
            firstChild: Shimmer(
              child: SizedBox(height: 320, width: double.infinity),
            ),
            secondChild: SizedBox(
              height: 100 + chartHeight,
              child: ListView.builder(
                padding: const EdgeInsets.all(0),
                primary: false,
                itemCount: data.length,
                shrinkWrap: true,
                reverse: false,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final dataItem = data.reversed.toList()[index];
                  final f2 = DateFormat('d. M.');

                  String deltaTotal = '';
                  String deltaDeaths = '';
                  String deltaRecoveries = '';
                  String deltaActive = '';

                  deltaTotal = dataItem.deltaTotalDisplay;
                  deltaActive = dataItem.deltaActiveDisplay;
                  deltaDeaths = dataItem.deltaDeathsDisplay;
                  deltaRecoveries = dataItem.deltaRecoveriesDisplay;

                  if (deltaTotal == '0') deltaTotal = '—';
                  if (deltaRecoveries == '0') deltaRecoveries = '—';
                  if (deltaDeaths == '0') deltaDeaths = '—';
                  if (deltaActive == '0') deltaActive = '—';

                  final isToday = index == 0;

                  int dayDiff = dataItem.date
                          .difference(provider.globalRecords.first.date)
                          .inDays +
                      1;

                  return Container(
                    height: 56,
                    margin: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 0,
                    ),
                    decoration: BoxDecoration(
                      color: index % 2 == 0
                          ? Colors.grey.withOpacity(0.05)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                f2.format(dataItem.date),
                                style: isToday
                                    ? tableItem.copyWith(
                                        color: Theme.of(context).accentColor)
                                    : tableItem,
                              ),
                              Opacity(
                                opacity: 0.6,
                                child: Text(
                                  'dan $dayDiff',
                                  style: tableItemFooter.copyWith(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: AlignmentDirectional.centerStart,
                          width: 48,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${dataItem.totalCases}',
                                style: isToday
                                    ? tableItem.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).accentColor,
                                      )
                                    : tableItem.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                              ),
                              Text(
                                '$deltaTotal',
                                style: tableItemFooter,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: AlignmentDirectional.centerStart,
                          width: 70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${dataItem.recoveries}',
                                style: isToday
                                    ? tableItem.copyWith(
                                        color: Theme.of(context).accentColor)
                                    : tableItem,
                              ),
                              Text(
                                '$deltaRecoveries',
                                style: tableItemFooter,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: AlignmentDirectional.centerStart,
                          width: 48,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${dataItem.deaths}',
                                style: isToday
                                    ? tableItem.copyWith(
                                        color: Theme.of(context).accentColor)
                                    : tableItem,
                              ),
                              Text(
                                '$deltaDeaths',
                                style: tableItemFooter,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: AlignmentDirectional.centerStart,
                          width: 48,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${dataItem.activeCases}',
                                style: isToday
                                    ? tableItem.copyWith(
                                        color: Theme.of(context).accentColor)
                                    : tableItem,
                              ),
                              Text(
                                '$deltaActive',
                                style: tableItemFooter,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
