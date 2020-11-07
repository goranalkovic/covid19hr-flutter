import 'dart:io';
import 'dart:ui';
import 'package:covid19hr/app_logo.dart';
import 'package:covid19hr/appstate.dart';
import 'package:covid19hr/footer.dart';
import 'package:covid19hr/generic_chart.dart';
import 'package:covid19hr/model.dart';
import 'package:covid19hr/status_card.dart';
import 'package:covid19hr/styles.dart';
import 'package:covid19hr/table_view.dart';
import 'package:covid19hr/titled_card.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if (!kIsWeb) {
  //   if (Platform.isAndroid) await InfinityUi.enable();
  // }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    if (!kIsWeb) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarIconBrightness: brightness,
        statusBarBrightness: brightness,
        systemNavigationBarIconBrightness: brightness,
      ));

      if (Platform.isIOS || Platform.isAndroid && !kIsWeb) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
        ));
      }
    }

    TextTheme lightTextTheme =
        ThemeData.light().textTheme.apply(fontFamily: 'Inter');
    TextTheme darkTextTheme =
        ThemeData.dark().textTheme.apply(fontFamily: 'Inter');

    return MaterialApp(
      // themeMode: ThemeMode.dark,
      title: 'COVID-19 podaci',
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider(
        create: (_) => Covid19Provider(),
        child: Scaffold(
          body: HomePage(),
        ),
      ),
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.white,
        accentColor: Colors.deepPurple,
        textTheme: lightTextTheme,
        appBarTheme: AppBarTheme(
          brightness: Brightness.light,
          color: Colors.white,
          elevation: 0,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepPurple[400],
        accentColor: Colors.deepPurple[300],
        scaffoldBackgroundColor: Color(0xff202020),
        textTheme: darkTextTheme,
        appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
          color: Color(0xff202020),
          elevation: 0,
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    totalColor = isDark ? totalColorDark : totalColorLight;
    recoveriesColor = isDark ? recoveriesColorDark : recoveriesColorLight;
    deathsColor = isDark ? deathsColorDark : deathsColorLight;
    activeColor = isDark ? activeColorDark : activeColorLight;

    return ChangeNotifierProvider(
      create: (_) => Covid19Provider(),
      child: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<Covid19Provider>();

    return RefreshIndicator(
      displacement: 80,
      onRefresh: () => provider.updateData(),
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate.fixed(
              [
                if (!kIsWeb)
                  if (Platform.isAndroid)
                    SizedBox(
                      height: MediaQuery.of(context).viewPadding.top,
                    ),
                Container(
                  padding: const EdgeInsets.only(top: 32, left: 32, right: 32),
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runSpacing: 14,
                    children: [
                      AppTitle(isHuge: true),
                      OutlineButton(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        highlightedBorderColor: Theme.of(context).accentColor,
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
                                .replaceAll(
                                    'Grad Zagreb županija', 'Grad Zagreb'))
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              FluentIcons.globe_location_24_regular,
                              color: Theme.of(context).accentColor,
                            ),
                            SizedBox(width: 8),
                            Text(
                              provider.county == null
                                  ? 'Hrvatska'
                                  : '${provider.county} županija'
                                      .replaceAll(
                                          'Grad Zagreb županija', 'Grad Zagreb')
                                      .replaceAll('Zagrebačka  županija',
                                          'Zagrebačka županija'),
                              style: TextStyle(
                                fontFamily: 'DMSans',
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(width: 2),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                DailySummary(county: provider.county),
                TitledCard(
                  child: GenericChart(),
                  maxWidth: MediaQuery.of(context).size.width * 0.6,
                ),
                // TitledCard(
                //   title: 'Podjela slučajeva',
                //   child: Center(child: DailyStats()),
                // ),
                TitledCard(
                  title: 'Tablični prikaz',
                  child: TableView(),
                ),
                Footer(),
                SizedBox(height: 12.0),
                if (!kIsWeb)
                  if (Platform.isAndroid)
                    SizedBox(
                      height: MediaQuery.of(context).viewPadding.bottom,
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LastUpdated extends StatelessWidget {
  const LastUpdated(this.data, this.update, {Key key}) : super(key: key);

  final DateTime data;
  final Function update;

  @override
  Widget build(BuildContext context) {
    String displayedDate = data != null ? DateFormat("d. M.").format(data) : "";
    String displayedTime = data != null ? DateFormat("HH:mm").format(data) : "";

    return GestureDetector(
      // onTap: () => HapticFeedback.lightImpact(),
      // onLongPressStart: (_) => HapticFeedback.lightImpact(),
      // onTap: () => HapticFeedback.lightImpact(),
      // onLongPress: update,
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon(
            //   Icons.refresh_rounded,
            //   color: Colors.grey.withOpacity(0.5),
            // ),
            // SizedBox(width: 4),
            AnimatedCrossFade(
              crossFadeState: data == null
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: Duration(milliseconds: 300),
              firstChild: Shimmer(
                direction: ShimmerDirection.fromLeftToRight(),
                child: SizedBox(height: 24, width: 120),
              ),
              secondChild: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.ideographic,
                children: [
                  // Text(
                  //   displayedDate,
                  //   style: TextStyle(
                  //     color: Theme.of(context).textTheme.bodyText1.color,
                  //     fontSize: 20,
                  //   ),
                  // ),
                  // Text(
                  //   displayedTime,
                  //   style: TextStyle(
                  //     color: Theme.of(context)
                  //         .textTheme
                  //         .bodyText1
                  //         .color
                  //         .withOpacity(0.4),
                  //     fontSize: 14,
                  //   ),
                  // ),
                  Text(
                    displayedDate,
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    displayedTime,
                    style: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .color
                          .withOpacity(0.5),
                      fontFamily: 'DMSans',
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DailySummary extends StatelessWidget {
  final county;

  DailySummary({this.county});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<Covid19Provider>();
    int casesCroatia;
    int recoveriesCroatia;
    int deathsCroatia;
    int activeCroatia;
    int deltaTotal = -1;
    int deltaRecoveries = -1;
    int deltaDeaths = -1;
    int deltaActive = -1;
    DateTime date;

    if (!provider.loading && provider.data.isNotEmpty) {
      if (county == null) {
        final item = provider.globalRecords.last;
        date = item.date;
        casesCroatia = item.casesCroatia;
        recoveriesCroatia = item.recoveriesCroatia;
        deathsCroatia = item.deathsCroatia;
        activeCroatia = item.activeCroatia;
        deltaTotal = item.deltaTotal;
        deltaRecoveries = item.deltaRecoveries;
        deltaDeaths = item.deltaDeaths;
        deltaActive = item.deltaActive;
      } else {
        final item = provider.countyRecords.last.records
            .firstWhere((CountyDataRecord r) => r.countyName == county);
        date = provider.countyRecords.last.date;
        casesCroatia = item.totalCases;
        recoveriesCroatia = item.recoveries;
        deathsCroatia = item.deaths;
        activeCroatia = item.activeCases;
        deltaTotal = item.deltaTotal;
        deltaRecoveries = item.deltaRecoveries;
        deltaDeaths = item.deltaDeaths;
        deltaActive = item.deltaActive;
      }
    }

    return TitledCard(
      maxWidth: MediaQuery.of(context).size.width < 1200 ? 480 : 640,
      // title: 'Zadnji podaci',
      // rightOfTitle: LastUpdated(date, () => provider.updateData()),
      child: Column(
        children: [
          LastUpdated(date, () => provider.updateData()),
          SizedBox(height: 24),
          Wrap(
            alignment: WrapAlignment.center,
            runSpacing: 24,
            children: [
              DailyStatusCard(
                title: 'Ukupno',
                currentNumber: casesCroatia,
                delta: deltaTotal,
                color: totalColor,
                isLarge: MediaQuery.of(context).size.width >= 560,
              ),
              DailyStatusCard(
                title: 'Oporavljeni',
                currentNumber: recoveriesCroatia,
                delta: deltaRecoveries,
                color: recoveriesColor,
                isLarge: MediaQuery.of(context).size.width >= 840,
              ),
              DailyStatusCard(
                title: 'Aktivni',
                currentNumber: activeCroatia,
                delta: deltaActive,
                color: activeColor,
                isLarge: MediaQuery.of(context).size.width >= 840,
              ),
              DailyStatusCard(
                title: 'Umrli',
                currentNumber: deathsCroatia,
                delta: deltaDeaths,
                color: deathsColor,
                isLarge: MediaQuery.of(context).size.width >= 840,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DailyStats extends StatelessWidget {
  final GenericDataRecord item;

  const DailyStats({Key key, @required this.item}) : super(key: key);

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

      if (recoveriesRatio + activeRatio + deathsRatio > 1) {
        recoveriesRatio -= ((recoveriesRatio + activeRatio + deathsRatio) - 1);
      }
    }
    final width = MediaQuery.of(context).size.width < 500 ? 380.0 : 440.0;

    double recoveriesWidth = (recoveriesRatio * width).roundToDouble();
    double deathsWidth = (deathsRatio * width).roundToDouble();
    double activeWidth = (activeRatio * width).roundToDouble();

    if (recoveriesRatio == 0 && deathsRatio == 0) {
      activeRatio = 1;
      activeWidth = width;
    }

    if (recoveriesWidth + deathsWidth + activeWidth > width) {
      recoveriesWidth = recoveriesWidth -
          ((recoveriesWidth + deathsWidth + activeWidth) - width);
      recoveriesWidth -= 10;
    }

    final style = TextStyle(
      fontFamily: 'Inter',
      fontSize: 14,
      letterSpacing: -1,
      fontFeatures: [
        FontFeature.tabularFigures(),
      ],
      fontWeight: FontWeight.w500,
    );

    return TitledCard(
      // title: 'Podjela slučajeva',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            width: width + 10,
            child: Stack(
              children: [
                Shimmer(
                  enabled: provider.loading || provider.globalRecords.isEmpty,
                  direction: ShimmerDirection.fromLeftToRight(),
                  child: SizedBox(width: width, height: 10),
                ),
                Container(
                  height: 10,
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 600),
                        curve: Curves.decelerate,
                        height: 10,
                        width: recoveriesWidth,
                        decoration: BoxDecoration(
                          color: recoveriesColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 600),
                        curve: Curves.decelerate,
                        height: 10,
                        width: activeWidth,
                        decoration: BoxDecoration(
                          color: activeColor,
                          borderRadius: BorderRadius.only(
                            topLeft:
                                Radius.circular(recoveriesRatio > 0 ? 0 : 5),
                            bottomLeft:
                                Radius.circular(recoveriesRatio > 0 ? 0 : 5),
                            topRight: Radius.circular(deathsRatio > 0 ? 0 : 5),
                            bottomRight:
                                Radius.circular(deathsRatio > 0 ? 0 : 5),
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 600),
                        curve: Curves.decelerate,
                        height: 10,
                        width: deathsWidth,
                        decoration: BoxDecoration(
                          color: deathsColor,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: width,
            child: Row(
              children: [
                Chip(
                  label: Text(
                    '${recoveriesRatio == 0 ? 'Nema oporavljenih' : (recoveriesRatio * 100).toStringAsFixed(2)}${recoveriesRatio == 0 ? '' : '%'}',
                    style: style.copyWith(color: recoveriesColor),
                  ),
                  backgroundColor: recoveriesColor.withOpacity(0.02),
                ),
                Spacer(),
                Chip(
                  label: Text(
                    '${recoveriesRatio == 0 ? 100 : (activeRatio * 100).toStringAsFixed(2)}%',
                    style: style.copyWith(color: activeColor),
                  ),
                  backgroundColor: activeColor.withOpacity(0.02),
                ),
                SizedBox(width: 8),
                Chip(
                  label: Text(
                    '${deathsRatio == 0 ? 'Nema umrlih' : (deathsRatio * 100).toStringAsFixed(2)}${deathsRatio == 0 ? '' : '%'}',
                    style: style.copyWith(color: deathsColor),
                  ),
                  backgroundColor: deathsColor.withOpacity(0.02),
                ),
              ],
            ),
          ),
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   physics: BouncingScrollPhysics(),
          //   child: Row(
          //     children: [
          //       DailyStatusCard(
          //         currentNumber:
          //             recoveriesRatio == 0 ? null : recoveriesRatio * 100,
          //         title: 'Oporavljeni',
          //         suffix: '%',
          //         color: recoveriesColor,
          //       ),
          //       DailyStatusCard(
          //         currentNumber:
          //             recoveriesRatio == 0 ? null : activeRatio * 100,
          //         title: 'Aktivni',
          //         suffix: '%',
          //         color: activeColor,
          //       ),
          //       DailyStatusCard(
          //         currentNumber:
          //             recoveriesRatio == 0 ? null : deathsRatio * 100,
          //         title: 'Umrli',
          //         suffix: '%',
          //         color: deathsColor,
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
