import 'dart:ui';
import 'package:covid19hr/app_logo.dart';
import 'package:covid19hr/appstate.dart';
import 'package:covid19hr/generic_chart.dart';
import 'package:covid19hr/ui_blocks/day_summary.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';

import 'components/settings_view.dart';
import 'table_view.dart';

class MobileHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<Covid19Provider>();

    Map<DateTime, double> totalCasesTest = {};
    Map<DateTime, double> activeCasesTest = {};
    Map<DateTime, double> recoveriesTest = {};
    Map<DateTime, double> deathsTest = {};

    for (var item in provider.globalRecords) {
      totalCasesTest[item.date] = item.casesCroatia.toDouble();
      activeCasesTest[item.date] = item.activeCroatia.toDouble();
      recoveriesTest[item.date] = item.recoveriesCroatia.toDouble();
      deathsTest[item.date] = item.deathsCroatia.toDouble();
    }

    // var currDate = provider.county == null
    //     ? provider.globalRecords.last.date ?? DateTime.now()
    //     : provider.countyRecords.last.date ?? DateTime.now();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(FluentIcons.arrow_sync_24_regular),
        //   isExtended: true,
        //   onPressed: provider.loading ? null : () => provider.updateData(),
        //   backgroundColor: Theme.of(context).accentColor,
        //   elevation: 0,
        //   hoverElevation: 0,
        //   hoverColor: totalColor,
        // ),
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlineButton(
                  onPressed: () => showMaterialScrollPicker(
                    context: context,
                    title: 'Odaberite područje',
                    confirmText: 'Odaberi',
                    cancelText: 'Odustani',
                    items: [
                      'Hrvatska',
                      ...counties.map((String c) => '$c županija'
                          .replaceAll('županija županija', 'županija')
                          .replaceAll('  ', ' ')
                          .replaceAll('Grad Zagreb županija', 'Grad Zagreb'))
                    ],
                    selectedItem: provider.county ?? 'Hrvatska',
                    showDivider: false,
                    onChanged: (value) => value == 'Hrvatska'
                        ? provider.setToGlobalData()
                        : provider.changeCounty(value
                            .replaceAll(' županija', '')
                            .replaceAll('Zagrebačka', 'Zagrebačka ')
                            .replaceAll('Krapinsko-zagorska',
                                'Krapinsko-zagorska županija')),
                    headerColor: Theme.of(context).accentColor,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        FluentIcons.location_24_regular,
                        color: Theme.of(context).accentColor,
                      ),
                      SizedBox(width: 4),
                      Text(
                        provider.county == null
                            ? 'Hrvatska'
                            : '${provider.county}'
                                .replaceAll('Grad Zagreb', 'Grad Zagreb')
                                .replaceAll(
                                    'Zagrebačka  ', 'Zagrebačka županija'),
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  borderSide: BorderSide(
                      color: Theme.of(context).accentColor.withOpacity(0.2)),
                ),
                RaisedButton(
                  elevation: 0,
                  disabledElevation: 0,
                  color: Theme.of(context).accentColor,
                  textColor: Colors.white,
                  onPressed:
                      provider.loading ? null : () => provider.updateData(),
                  child: Row(
                    children: [
                      Icon(
                        FluentIcons.arrow_counterclockwise_24_regular,
                        // color: Theme.of(context).accentColor,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Osvježi podatke',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  // borderSide: BorderSide(
                  //     color: Theme.of(context).accentColor.withOpacity(0.2)),
                ),
              ],
            ),
          ),
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: AppTitle(isLarge: true),
          centerTitle: true,
          elevation: 2,
          shadowColor: Theme.of(context).shadowColor.withOpacity(0.2),
          bottom: TabBar(
            isScrollable: true,
            automaticIndicatorColorAdjustment: false,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: UnderlineTabIndicator(
                borderSide:
                    BorderSide(color: Theme.of(context).accentColor, width: 2)),
            physics: BouncingScrollPhysics(),
            tabs: [
              Tab(
                text: 'Najnovije',
                icon: Icon(FluentIcons.shifts_activity_24_regular),
              ),
              Tab(
                text: 'Graf',
                icon: Icon(FluentIcons.data_area_24_regular),
              ),
              // Tab(
              //   text: 'Trend',
              //   icon: Icon(FluentIcons.arrow_trending_24_regular),
              // ),
              Tab(
                text: 'Po danima',
                icon: Icon(FluentIcons.timeline_24_regular),
              ),
              Tab(
                text: 'Postavke',
                icon: Icon(FluentIcons.settings_24_regular),
              ),
            ],
          ),
        ),
        body: TabBarView(
          physics: BouncingScrollPhysics(),
          children: [
            DaySummary(),
            GenericChart(),
            // Icon(FluentIcons.timer_24_regular),
            TableView(),
            SettingsView(),
          ],
        ),
      ),
    );
  }
}
