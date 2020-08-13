import 'dart:io';
import 'dart:math';
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
import 'package:google_fonts/google_fonts.dart';
import 'package:flinq/flinq.dart';
import 'package:infinity_ui/infinity_ui.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    if (Platform.isAndroid) await InfinityUi.enable();
  }
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

    final lightTextTheme =
        GoogleFonts.sourceSansProTextTheme(ThemeData.light().textTheme);
    final darkTextTheme =
        GoogleFonts.sourceSansProTextTheme(ThemeData.dark().textTheme);

    return MaterialApp(
      title: 'COVID-19 podaci',
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider(
        create: (_) => Covid19Provider(),
        child: Scaffold(body: HomePage()),
      ),
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.deepPurple,
        textTheme: lightTextTheme,
        appBarTheme: AppBarTheme(
          brightness: Brightness.light,
          color: ThemeData.light().cardColor,
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepPurple[200],
        textTheme: darkTextTheme,
        appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
          color: ThemeData.dark().cardColor,
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
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          stretch: true,
          pinned: true,
          centerTitle: true,
          title: AppTitle(),
        ),
        SliverList(
          delegate: SliverChildListDelegate.fixed(
            [
              SizedBox(height: 8),
              //   ButtonBar(
              //     alignment: MainAxisAlignment.center,
              //     children: [
              //       OutlineButton(
              //         onPressed: () => provider.turnOffLoading(),
              //         child: Icon(Icons.stop_rounded),
              //       ),
              //       OutlineButton(
              //         onPressed: () => provider.turnOnLoading(),
              //         child: Icon(Icons.play_arrow_rounded),
              //       ),
              //       OutlineButton(
              //         onPressed: () => provider.clearData(),
              //         child: Icon(Icons.delete_rounded),
              //       ),
              //       OutlineButton(
              //         onPressed: () => provider.updateData(),
              //         child: Icon(Icons.arrow_downward_rounded),
              //       ),
              //       OutlineButton(
              //         onPressed: () => provider.dummyData(),
              //         child: Icon(Icons.format_list_numbered_rounded),
              //       ),
              //     ],
              //   ),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  DailySummary(),
                  DailyStats(),
                ],
              ),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  TitledCard(
                    title: 'Grafički prikaz',
                    child: Chart(),
                    maxWidth:
                        MediaQuery.of(context).size.width < 1200 ? 480 : 640,
                  ),
                  TitledCard(
                    title: 'Tablični prikaz',
                    child: TableView(),
                  ),
                ],
              ),
              Footer(),
              SizedBox(
                height: 12 +
                    (!kIsWeb && Platform.isAndroid
                        ? InfinityUi.navigationBarHeight
                        : 0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LastUpdated extends StatelessWidget {
  const LastUpdated(this.data, this.update, {Key key}) : super(key: key);

  final DateTime data;
  final Function update;

  @override
  Widget build(BuildContext context) {
    String displayedDate =
        data != null ? DateFormat("d. M. HH:mm").format(data) : "";

    return GestureDetector(
      onTap: () => HapticFeedback.lightImpact(),
      onLongPress: () {
        HapticFeedback.heavyImpact();
        if (update != null) update();
      },
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.refresh_rounded,
              color: Colors.grey.withOpacity(0.5),
            ),
            SizedBox(width: 4),
            AnimatedCrossFade(
              crossFadeState: data == null
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: Duration(milliseconds: 300),
              firstChild: Shimmer(
                direction: ShimmerDirection.fromLeftToRight(),
                child: SizedBox(height: 16, width: 60),
              ),
              secondChild: Text(
                displayedDate,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1.color,
                ),
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
    var verticalLineX = useState(0.0);
    var currentIndex = useState(0);

    final f = DateFormat("d. M.");

    DataRecord currentItem =
        hasError ? null : data.elementAt(currentIndex.value);

    processInput(event) {
      if (hasError) return;

      final maxWidth =
          (MediaQuery.of(context).size.width < 1200 ? 480 : 640) - 30;

      final currentX = event.localPosition.dx;

      verticalLineX.value = currentX;

      final step = maxWidth / data.length;

      currentIndex.value = (currentX / step).round().clamp(0, data.length - 1);
    }

    double chartHeight = min(300, MediaQuery.of(context).size.height * 0.5);

    return SizedBox(
      height: 140 + chartHeight,
      child: Column(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.resizeLeftRight,
            onHover: processInput,
            child: GestureDetector(
              onHorizontalDragUpdate: processInput,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Shimmer(
                        enabled: hasError,
                        child: SizedBox(
                            height: chartHeight, width: double.infinity),
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
                      Positioned(
                        top: 0,
                        left: 4,
                        child: Container(
                          color: Theme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(0.9),
                          child: Text(
                            '${hasError ? '—' : f.format(currentItem.date)}',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
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
                            child:
                                Text(hasError ? '' : f.format(data.last.date)),
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
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 24),
            alignment: AlignmentDirectional.centerStart,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              child: Row(
                children: [
                  DailyStatusCard(
                    currentNumber: hasError ? null : currentItem.casesCroatia,
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
                    currentNumber: hasError ? null : currentItem.deathsCroatia,
                    title: 'Umrli',
                    color: deathsColor,
                    delta: hasError ? -1 : currentItem.deltaDeaths,
                    showLineAbove: true,
                  ),
                  DailyStatusCard(
                    currentNumber: hasError ? null : currentItem.activeCroatia,
                    title: 'Aktivni',
                    color: activeColor,
                    delta: hasError ? -1 : currentItem.deltaActive,
                    showLineAbove: true,
                  ),
                ],
              ),
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
      height: 140 + chartHeight,
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
                  width: 68,
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
                                '${dataItem.casesCroatia}',
                                style: tableItem.copyWith(
                                  fontSize: 18,
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
                          width: 68,
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
      title: 'Najnoviji podaci',
      rightOfTitle: LastUpdated(date, () => provider.updateData()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            child: Row(
              children: [
                DailyStatusCard(
                  title: 'Ukupno',
                  currentNumber: casesCroatia,
                  delta: deltaTotal,
                  color: totalColor,
                ),
                DailyStatusCard(
                  title: 'Oporavljeni',
                  currentNumber: recoveriesCroatia,
                  delta: deltaRecoveries,
                  color: recoveriesColor,
                ),
                DailyStatusCard(
                  title: 'Umrli',
                  currentNumber: deathsCroatia,
                  delta: deltaDeaths,
                  color: deathsColor,
                ),
                DailyStatusCard(
                  title: 'Aktivni',
                  currentNumber: activeCroatia,
                  delta: deltaActive,
                  color: activeColor,
                ),
              ],
            ),
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
                ),
                DailyStatusCard(
                  currentNumber:
                      recoveriesRatio == 0 ? null : activeRatio * 100,
                  title: 'Aktivni',
                  suffix: '%',
                ),
                DailyStatusCard(
                  currentNumber:
                      recoveriesRatio == 0 ? null : deathsRatio * 100,
                  title: 'Umrli',
                  suffix: '%',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
