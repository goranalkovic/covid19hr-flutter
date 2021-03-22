import 'dart:io';
import 'dart:math';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:covid19hr/app_logo.dart';
import 'package:covid19hr/appstate.dart';
import 'package:covid19hr/components/custom_window_button.dart';
import 'package:covid19hr/generic_chart.dart';
import 'package:covid19hr/ui_blocks/day_summary.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'components/settings_view.dart';
import 'components/window_buttons.dart';
import 'styles.dart';
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

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    Function showSettings = () {
      showDialog(
          context: context,
          builder: (context) {
            return ChangeNotifierProvider(
              create: (_) => Covid19Provider(),
              child: AlertDialog(
                titlePadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                content: SizedBox(
                  width: screenWidth.clamp(400.0, 560.0),
                  height: (screenHeight * 0.8).clamp(300.0, 460.0),
                  child: SettingsView(),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Zatvori'),
                  ),
                ],
              ),
            );
          });
    };

    Function showDayView = () {
      showDialog(
          context: context,
          builder: (context) {
            return ChangeNotifierProvider(
              create: (_) => Covid19Provider(),
              child: AlertDialog(
                title: Text('Podaci po danima'),
                titlePadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                content: SizedBox(
                  width: screenWidth.clamp(400.0, 560.0),
                  height: (screenHeight * 0.8).clamp(300.0, 460.0),
                  child: TableView(),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Zatvori'),
                  ),
                ],
              ),
            );
          });
    };

    Function showRegionPicker = () {
      List<String> items = [
        'Hrvatska',
        ...counties.map((String c) => '$c županija'
            .replaceAll('županija županija', 'županija')
            .replaceAll('  ', ' ')
            .replaceAll('Grad Zagreb županija', 'Grad Zagreb'))
      ];
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Regija'),
            titlePadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
            content: SizedBox(
              width: screenWidth.clamp(400.0, 560.0),
              height: (screenHeight * 0.8).clamp(300.0, 460.0),
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  String selectedItem = provider.county ?? 'Hrvatska';
                  String item = items.elementAt(index);

                  String filteredItem = item
                      .replaceAll(' županija', '')
                      .replaceAll('Zagrebačka', 'Zagrebačka ');
                  return ListTile(
                    dense: true,
                    visualDensity: VisualDensity.compact,
                    enableFeedback: true,
                    trailing: selectedItem == filteredItem
                        ? Icon(FluentIcons.checkbox_checked_24_regular)
                        : null,
                    title: Text(item),
                    onTap: item == selectedItem
                        ? null
                        : () {
                            if (item == 'Hrvatska') {
                              provider.setToGlobalData();
                            } else {
                              provider.changeCounty(
                                item
                                    .replaceAll(' županija', '')
                                    .replaceAll('Zagrebačka', 'Zagrebačka '),
                              );
                            }

                            Navigator.of(context).pop();
                          },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Odustani'),
              ),
            ],
          );
        },
      );
    };

    void _scrollCallback() {
      shrinkTopItems.value = scrollControl.offset > 1;
    }

    useEffect(() {
      scrollControl.addListener(_scrollCallback);
      return () => scrollControl.removeListener(_scrollCallback);
    }, [scrollControl]);

    bool isDesktop =
        !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);

    List<Widget> titleBarActions = [
      Expanded(child: MoveWindow(child: AppTitle())),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FluentIcons.location_16_regular,
            size: 16,
            color: contrastingColor.withOpacity(0.7),
          ),
          SizedBox(width: 4),
          Text(
            provider.county ?? 'Hrvatska',
            style: TextStyle(
              fontSize: 12,
              color: contrastingColor.withOpacity(0.7),
              fontFamily: Theme.of(context).textTheme.bodyText1.fontFamily,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(width: 12),
          Icon(
            FluentIcons.calendar_ltr_16_regular,
            size: 16,
            color: contrastingColor.withOpacity(0.7),
          ),
          SizedBox(width: 4),
          Text(
            DateFormat("d. M. H:mm").format(provider.data.last.date),
            style: TextStyle(
              fontSize: 12,
              color: contrastingColor.withOpacity(0.7),
              fontFamily: Theme.of(context).textTheme.bodyText1.fontFamily,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      SizedBox(width: 10),
      TitleBarSeparator(),
      CustomWindowButton(
        icon: FluentIcons.arrow_clockwise_20_regular,
        onPressed: provider.loading ? null : () => provider.updateData(),
      ),
      CustomWindowButton(
        icon: FluentIcons.location_20_regular,
        onPressed: showRegionPicker,
      ),
      CustomWindowButton(
        icon: FluentIcons.apps_list_20_regular,
        onPressed: showDayView,
      ),
      CustomWindowButton(
        icon: FluentIcons.settings_20_regular,
        onPressed: showSettings,
      ),
      WindowButtons(),
    ];

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 10,
        automaticallyImplyLeading: false,
        title: isDesktop
            ? WindowTitleBarBox(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: titleBarActions,
                ),
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: titleBarActions,
              ),
        centerTitle: !isDesktop,
        elevation: 2,
        shadowColor: Theme.of(context).shadowColor.withOpacity(0.2),
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

class TitleBarSeparator extends StatelessWidget {
  const TitleBarSeparator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 1,
      color: buttonColors.iconNormal.withOpacity(0.2),
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}
