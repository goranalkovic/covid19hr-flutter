import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:covid19hr/app_logo.dart';
import 'package:covid19hr/appstate.dart';
import 'package:covid19hr/footer.dart';
import 'package:covid19hr/model.dart';
import 'package:covid19hr/status_card.dart';
import 'package:covid19hr/styles.dart';
import 'package:covid19hr/titled_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flinq/flinq.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

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
                    padding: const EdgeInsets.only(top: 32),
                    alignment: Alignment.center,
                    child: AppTitle(isHuge: true)),
                DailySummary(),
                TitledCard(
                  child: Chart(),
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    DailyStats(),
                    TitledCard(
                      title: 'Tablični prikaz',
                      child: TableView(),
                    ),
                  ],
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

class Chart extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<Covid19Provider>();
    final List<DataRecord> data = provider.records;

    final hasError = provider.loading || provider.records.isEmpty;
    var verticalLineX =
        useState(hasError ? 0.0 : MediaQuery.of(context).size.width - 30);
    var currentIndex = useState(hasError ? 0 : data.length - 1);
    var currentTouchX = useState(0.0);

    final f = DateFormat("d. M.");
    final f2 = DateFormat("HH:mm");

    DataRecord currentItem =
        hasError ? null : data.elementAt(currentIndex.value);

    // void processMouseInput(event) {
    //   if (hasError) return;

    //   const margin = 20;

    //   final maxWidth =
    //       (MediaQuery.of(context).size.width < 1200 ? 480 : 640) - 30 - margin;

    //   final currentX = event.localPosition.dx;

    //   verticalLineX.value = currentX;

    //   final step = (maxWidth - margin) / data.length;

    //   currentIndex.value = (currentX / step).round().clamp(0, data.length - 1);
    // }

    void processTouchInput(DragUpdateDetails event) {
      if (hasError) return;

      const margin = 0;

      int maxWidth = (MediaQuery.of(context).size.width.toInt()) - 30 - margin;

      currentTouchX.value += event.delta.dx;

      currentTouchX.value = currentTouchX.value.clamp(0, maxWidth).toDouble();

      verticalLineX.value = currentTouchX.value;

      final step = (maxWidth - margin) / data.length;

      var newValue =
          (currentTouchX.value / step).round().clamp(0, data.length - 1);

      if (newValue != currentIndex.value) {
        currentIndex.value = newValue;

        if (newValue == 0 || newValue == data.length - 1) {
          HapticFeedback.lightImpact();
        }
      }
    }

    double chartHeight = 400;
    int numOfLines = 20;

    int delta = hasError
        ? 1
        : (data[data.length - 1].casesCroatia / numOfLines).round();

    return SizedBox(
      // height: 140.0 + chartHeight,
      child: Column(
        children: [
          // MouseRegion(
          //   cursor: SystemMouseCursors.resizeLeftRight,
          //   onHover: processMouseInput,
          // child:
          GestureDetector(
            onHorizontalDragUpdate: processTouchInput,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    for (double i = 0; i < numOfLines; i++)
                      Positioned(
                        top: (chartHeight / numOfLines) * i,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 1,
                          color: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .color
                              .withOpacity(0.05),
                        ),
                      ),
                    for (double i = 0; i < numOfLines; i++)
                      Positioned(
                        left: 0,
                        top: (chartHeight / numOfLines) * i - 1,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            // color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          child: Text(
                            hasError
                                ? ''
                                : '${data[data.length - 1].casesCroatia - (delta * i).round()}',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .color
                                  .withOpacity(0.15),
                              fontWeight: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? FontWeight.w200
                                  : FontWeight.w500,
                              fontSize: 11,
                              fontFeatures: [FontFeature.tabularFigures()],
                            ),
                          ),
                        ),
                      ),
                    Shimmer(
                      enabled: hasError,
                      child:
                          SizedBox(height: chartHeight, width: double.infinity),
                    ),
                    Container(
                      height: chartHeight,
                      child: Sparkline(
                        data: hasError
                            ? [0, 0]
                            : data
                                .map((e) => e.casesCroatia.toDouble())
                                .toList(),
                        fillMode: FillMode.below,
                        lineColor: totalColor,
                        sharpCorners: false,
                        fillGradient: new LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            totalColor.withOpacity(0.5),
                            totalColor.withOpacity(0.0)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: hasError
                          ? 0
                          : data.mapList((e) => e.recoveriesCroatia).max /
                              data[data.length - 1].casesCroatia *
                              chartHeight,
                      child: Sparkline(
                        data: hasError
                            ? [0, 0]
                            : data
                                .map((e) => e.recoveriesCroatia.toDouble())
                                .toList(),
                        fillMode: FillMode.below,
                        lineColor: recoveriesColor,
                        sharpCorners: false,
                        fillGradient: new LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            recoveriesColor.withOpacity(0.5),
                            recoveriesColor.withOpacity(0.0)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: hasError
                          ? 0
                          : data.mapList((e) => e.activeCroatia).max /
                              data[data.length - 1].casesCroatia *
                              chartHeight,
                      child: Sparkline(
                        data: hasError
                            ? [0, 0]
                            : data
                                .map((e) => e.activeCroatia.toDouble())
                                .toList(),
                        fillMode: FillMode.below,
                        lineColor: activeColor,
                        sharpCorners: false,
                        fillGradient: new LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            activeColor.withOpacity(0.5),
                            activeColor.withOpacity(0.0)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: hasError
                          ? 0
                          : data.mapList((e) => e.deathsCroatia).max /
                              data[data.length - 1].casesCroatia *
                              chartHeight,
                      child: Sparkline(
                        data: hasError
                            ? [0, 0]
                            : data
                                .map((e) => e.deathsCroatia.toDouble())
                                .toList(),
                        fillMode: FillMode.below,
                        lineColor: deathsColor,
                        sharpCorners: false,
                        fillGradient: new LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            deathsColor.withOpacity(0.5),
                            deathsColor.withOpacity(0.0)
                          ],
                        ),
                      ),
                    ),
                    // Positioned(
                    //   top: 0,
                    //   left: 4,
                    //   child: Container(
                    //     color: Theme.of(context)
                    //         .scaffoldBackgroundColor
                    //         .withOpacity(0.9),
                    //     child: Text(
                    //       '${hasError ? '—' : f.format(currentItem.date)}',
                    //       style: TextStyle(
                    //         fontSize: 20,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                Container(
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .color
                        .withOpacity(0.02),
                  ),
                  margin: const EdgeInsets.only(top: 8),
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 4),
                        alignment: AlignmentDirectional.centerStart,
                        child: Opacity(
                          opacity: 0.4,
                          child:
                              Text(hasError ? '' : f.format(data.first.date)),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(right: 4),
                        alignment: AlignmentDirectional.centerEnd,
                        child: Opacity(
                          opacity: 0.4,
                          child: Text(hasError ? '' : f.format(data.last.date)),
                        ),
                      ),
                      Positioned(
                        left: verticalLineX.value
                            .clamp(0, MediaQuery.of(context).size.width - 60)
                            .toDouble(),
                        top: 0,
                        child: Container(
                          height: 24,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .color
                                .withOpacity(0.8),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 0,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                offset: Offset(0, 1),
                                spreadRadius: 1,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(2),
                            border: Border.all(
                              color:
                                  Theme.of(context).textTheme.bodyText1.color,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 23),
            alignment: AlignmentDirectional.centerStart,
            child: Column(
              children: [
                // if (MediaQuery.of(context).size.width <= 600)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.ideographic,
                  children: [
                    Text(
                      '${hasError ? '—' : f.format(currentItem.date)}',
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      '${hasError ? '—' : f2.format(currentItem.date)}',
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
                // if (MediaQuery.of(context).size.width <= 600)
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  // color: Colors.red,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    runSpacing: 20,
                    children: [
                      // if (MediaQuery.of(context).size.width > 600)
                      //   DailyStatusCard(
                      //     currentValue:
                      //         '${hasError ? '—' : f.format(currentItem.date)}',
                      //     title: "Dan",
                      //     showLineAbove: true,
                      //     color: Colors.transparent,
                      //     deltaTxt: hasError ? '' : f2.format(currentItem.date),
                      //   ),
                      DailyStatusCard(
                        currentNumber:
                            hasError ? null : currentItem.casesCroatia,
                        title: 'Ukupno',
                        color: totalColor,
                        delta: hasError ? -1 : currentItem.deltaTotal,
                        showLineAbove: true,
                      ),
                      DailyStatusCard(
                        currentNumber:
                            hasError ? null : currentItem.recoveriesCroatia,
                        title: 'Oporavljeni',
                        color: recoveriesColor,
                        delta: hasError ? -1 : currentItem.deltaRecoveries,
                        showLineAbove: true,
                      ),
                      DailyStatusCard(
                        currentNumber:
                            hasError ? null : currentItem.activeCroatia,
                        title: 'Aktivni',
                        color: activeColor,
                        delta: hasError ? -1 : currentItem.deltaActive,
                        showLineAbove: true,
                      ),
                      DailyStatusCard(
                        currentNumber:
                            hasError ? null : currentItem.deathsCroatia,
                        title: 'Umrli',
                        color: deathsColor,
                        delta: hasError ? -1 : currentItem.deltaDeaths,
                        showLineAbove: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TableView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<Covid19Provider>();
    List<DataRecord> data = [];

    if (!provider.loading && provider.records.isNotEmpty) {
      data = [...provider.records];
    }

    double chartHeight = min(300, MediaQuery.of(context).size.height * 0.5);

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
            crossFadeState: provider.loading || provider.records.isEmpty
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

                  return Container(
                    height: 60,
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 0,
                    ),
                    decoration: BoxDecoration(
                      color: isToday
                          ? Theme.of(context).primaryColor.withOpacity(0.05)
                          : index % 2 == 0
                              ? Colors.grey.withOpacity(0.05)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: 48,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                f2.format(dataItem.date),
                                style: tableItem,
                              ),
                              Text(
                                '#${data.length - index}',
                                style: tableItemFooter.copyWith(fontSize: 12),
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
                                '${dataItem.casesCroatia}',
                                style: tableItem.copyWith(
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
                                '${dataItem.recoveriesCroatia}',
                                style: tableItem,
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
                                '${dataItem.deathsCroatia}',
                                style: tableItem,
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
                                '${dataItem.activeCroatia}',
                                style: tableItem,
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

class DailySummary extends StatelessWidget {
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

    if (!provider.loading && provider.records.isNotEmpty) {
      final item = provider.records.last;
      date = item.date;
      casesCroatia = item.casesCroatia;
      recoveriesCroatia = item.recoveriesCroatia;
      deathsCroatia = item.deathsCroatia;
      activeCroatia = item.activeCroatia;
      deltaTotal = item.deltaTotal;
      deltaRecoveries = item.deltaRecoveries;
      deltaDeaths = item.deltaDeaths;
      deltaActive = item.deltaActive;
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
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<Covid19Provider>();
    DataRecord item;

    double recoveriesRatio = 0;
    double deathsRatio = 0;
    double activeRatio = 0;

    if (!provider.loading && provider.records.isNotEmpty) {
      item = provider.records.last;
      recoveriesRatio = item.recoveriesCroatia / item.casesCroatia;
      deathsRatio = item.deathsCroatia / item.casesCroatia;
      activeRatio = item.activeCroatia / item.casesCroatia;
    }
    final width = min(360, MediaQuery.of(context).size.width - 60).toDouble();

    return TitledCard(
      title: 'Podjela slučajeva',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Stack(
              children: [
                Shimmer(
                  enabled: provider.loading || provider.records.isEmpty,
                  direction: ShimmerDirection.fromLeftToRight(),
                  child: SizedBox(width: width, height: 10),
                ),
                Container(
                  width: width,
                  height: 10,
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 600),
                        curve: Curves.decelerate,
                        height: 10,
                        width: width * recoveriesRatio,
                        color: recoveriesColor,
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 600),
                        curve: Curves.decelerate,
                        height: 10,
                        width: width * activeRatio,
                        color: activeColor,
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 600),
                        curve: Curves.decelerate,
                        height: 10,
                        width: width * deathsRatio,
                        color: deathsColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            child: Row(
              children: [
                DailyStatusCard(
                  currentNumber:
                      recoveriesRatio == 0 ? null : recoveriesRatio * 100,
                  title: 'Oporavljeni',
                  suffix: '%',
                  color: recoveriesColor,
                ),
                DailyStatusCard(
                  currentNumber:
                      recoveriesRatio == 0 ? null : activeRatio * 100,
                  title: 'Aktivni',
                  suffix: '%',
                  color: activeColor,
                ),
                DailyStatusCard(
                  currentNumber:
                      recoveriesRatio == 0 ? null : deathsRatio * 100,
                  title: 'Umrli',
                  suffix: '%',
                  color: deathsColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
