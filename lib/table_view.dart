import 'package:covid19hr/model.dart';
import 'package:covid19hr/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import 'appstate.dart';

class TableViewSource extends DataTableSource {
  final List<GlobalDataRecord> data;
  final BuildContext context;

  TableViewSource(this.data, this.context);

  @override
  DataRow getRow(int index) {
    // TODO: implement getRow
    return getTableViewRow(
      data[index],
      data.first.date,
      context,
      index: data.length - index,
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}

class TableView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<Covid19Provider>();

    final data = provider.data;

    // final firstDate = provider.globalRecords.first.date;

    NumberFormat formatter = NumberFormat('###,###,###');

    return AnimatedCrossFade(
      crossFadeState: provider.loading || provider.data.isEmpty
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      duration: Duration(milliseconds: 300),
      firstChild: Shimmer(
        child: SizedBox(height: 320, width: double.infinity),
      ),
      secondChild: ListView.builder(
        padding: const EdgeInsets.all(0),
        primary: false,
        itemCount: data.length,
        shrinkWrap: true,
        reverse: false,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final dataItem = data.reversed.toList()[index];

          return Container(
            color: index % 2 == 0
                ? Theme.of(context).dividerColor.withOpacity(0.02)
                : Colors.transparent,
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 18.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 68,
                  child: Text(
                    DateFormat("d. M.").format(dataItem.date),
                    style: tableItem,
                  ),
                ),
                SizedBox(
                  width: 84,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatter.format(dataItem.totalCases),
                        style: tableItem.copyWith(fontSize: 15),
                      ),
                      Text(
                        dataItem.deltaTotalDisplay,
                        style: tableItemFooter,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 84,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatter.format(dataItem.recoveries),
                        style: tableItem,
                      ),
                      Text(
                        dataItem.deltaRecoveriesDisplay,
                        style: tableItemFooter,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 84,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatter.format(dataItem.activeCases),
                        style: tableItem,
                      ),
                      Text(
                        dataItem.deltaActiveDisplay,
                        style: tableItemFooter,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 84,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatter.format(dataItem.deaths),
                        style: tableItem,
                      ),
                      Text(
                        dataItem.deltaDeathsDisplay,
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
    );
  }
}

DataRow getTableViewRow(
    GlobalDataRecord dI, DateTime firstDate, BuildContext context,
    {int index}) {
  final dataItem = GenericDataRecord.fromGlobal(dI);
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

  final isToday = false; //index == 0;

  int dayDiff = dataItem.date.difference(firstDate).inDays + 1;

  return DataRow(
    cells: [
      DataCell(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              f2.format(dataItem.date),
              style: isToday
                  ? tableItem.copyWith(color: Theme.of(context).accentColor)
                  : tableItem,
            ),
            Opacity(
              opacity: 0.6,
              child: Text(
                'dan ${index ?? dayDiff}',
                style: tableItemFooter.copyWith(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
      DataCell(Column(
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
      )),
      DataCell(Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${dataItem.recoveries}',
            style: isToday
                ? tableItem.copyWith(color: Theme.of(context).accentColor)
                : tableItem,
          ),
          Text(
            '$deltaRecoveries',
            style: tableItemFooter,
          ),
        ],
      )),
      DataCell(Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${dataItem.deaths}',
            style: isToday
                ? tableItem.copyWith(color: Theme.of(context).accentColor)
                : tableItem,
          ),
          Text(
            '$deltaDeaths',
            style: tableItemFooter,
          ),
        ],
      )),
      DataCell(Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${dataItem.activeCases}',
            style: isToday
                ? tableItem.copyWith(color: Theme.of(context).accentColor)
                : tableItem,
          ),
          Text(
            '$deltaActive',
            style: tableItemFooter,
          ),
        ],
      )),
    ],
  );
}
