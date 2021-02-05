import 'dart:ui';
import 'package:covid19hr/app_logo.dart';
import 'package:covid19hr/appstate.dart';
import 'package:covid19hr/generic_chart.dart';
import 'package:covid19hr/ui_blocks/day_summary.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';

import 'components/settings_view.dart';
import 'table_view.dart';

class DesktopHome extends HookWidget {
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

    var shrinkTopItems = useState(false);

    var scrollControl = useScrollController(keepScrollOffset: true);

    void _scrollCallback() {
      shrinkTopItems.value = scrollControl.offset > 1;
    }

    useEffect(() {
      scrollControl.addListener(_scrollCallback);
      return () => scrollControl.removeListener(_scrollCallback);
    }, [scrollControl]);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: AppTitle(isLarge: true),
        centerTitle: true,
        elevation: 2,
        shadowColor: Theme.of(context).shadowColor.withOpacity(0.2),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
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
                Row(
                  children: [
                    OutlineButton(
                      onPressed: () => showDialog(
                          context: context,
                          builder: (context) {
                            return ChangeNotifierProvider(
                              create: (_) => Covid19Provider(),
                              child: AlertDialog(
                                title: Text('Podaci po danima'),
                                content: SizedBox(
                                  width: 600,
                                  height: 500,
                                  child: TableView(),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text('Zatvori'),
                                  ),
                                ],
                              ),
                            );
                          }),
                      child: Row(
                        children: [
                          Icon(
                            FluentIcons.timeline_24_regular,
                            color: Theme.of(context).accentColor,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Po danima',
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
                          color:
                              Theme.of(context).accentColor.withOpacity(0.2)),
                    ),
                    SizedBox(width: 8),
                    OutlineButton(
                      onPressed: () => showDialog(
                          context: context,
                          builder: (context) {
                            return ChangeNotifierProvider(
                              create: (_) => Covid19Provider(),
                              child: AlertDialog(
                                content: SizedBox(
                                  width: 500,
                                  height: 450,
                                  child: SettingsView(),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text('Zatvori'),
                                  ),
                                ],
                              ),
                            );
                          }),
                      child: Row(
                        children: [
                          Icon(
                            FluentIcons.settings_24_regular,
                            color: Theme.of(context).accentColor,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Postavke',
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
                          color:
                              Theme.of(context).accentColor.withOpacity(0.2)),
                    ),
                  ],
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
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        controller: scrollControl,
        child: Column(
          children: [
            DaySummary(isShrunk: shrinkTopItems.value),
            GenericChart(),
          ],
        ),
      ),
    );
  }
}
