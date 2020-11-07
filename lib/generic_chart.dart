import 'dart:ui';

import 'package:covid19hr/status_card.dart';
import 'package:covid19hr/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:intl/intl.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:provider/provider.dart';
import 'package:flinq/flinq.dart';

import 'appstate.dart';
import 'main.dart';
import 'model.dart';

class GenericChart extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<Covid19Provider>();

    final hasError = provider.loading || provider.data.isEmpty;

    final data = provider.data;

    var verticalLineX =
        useState(hasError ? 0.0 : MediaQuery.of(context).size.width - 30);
    var currentIndex = useState(0);
    var currentTouchX = useState(0.0);

    final f = DateFormat("d. M.");
    final f2 = DateFormat("HH:mm");

    if (currentIndex.value >= data.length) {
      currentIndex.value = 0;
    }

    GenericDataRecord currentItem =
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

      if (currentIndex.value >= data.length) newValue = 0;

      if (newValue != currentIndex.value) {
        currentIndex.value = newValue;

        if (newValue == 0 || newValue == data.length - 1) {
          HapticFeedback.lightImpact();
        }
      }
    }

    double chartHeight = 400;
    int numOfLines = 20;

    int delta =
        hasError ? 1 : (data[data.length - 1].totalCases / numOfLines).round();

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
                                : '${data[data.length - 1].totalCases - (delta * i).round()}',
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
                            : data.map((e) => e.totalCases.toDouble()).toList(),
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
                          : data.mapList((e) => e.recoveries).max /
                              data[data.length - 1].totalCases *
                              chartHeight,
                      child: Sparkline(
                        data: hasError
                            ? [0, 0]
                            : data.map((e) => e.recoveries.toDouble()).toList(),
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
                          : data.mapList((e) => e.activeCases).max /
                              data[data.length - 1].totalCases *
                              chartHeight,
                      child: Sparkline(
                        data: hasError
                            ? [0, 0]
                            : data
                                .map((e) => e.activeCases.toDouble())
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
                          : data.mapList((e) => e.deaths).max /
                              data[data.length - 1].totalCases *
                              chartHeight,
                      child: Sparkline(
                        data: hasError
                            ? [0, 0]
                            : data.map((e) => e.deaths.toDouble()).toList(),
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
                        currentNumber: hasError ? null : currentItem.totalCases,
                        title: 'Ukupno',
                        color: totalColor,
                        delta: hasError ? -1 : currentItem.deltaTotal,
                        showLineAbove: true,
                      ),
                      DailyStatusCard(
                        currentNumber: hasError ? null : currentItem.recoveries,
                        title: 'Oporavljeni',
                        color: recoveriesColor,
                        delta: hasError ? -1 : currentItem.deltaRecoveries,
                        showLineAbove: true,
                      ),
                      DailyStatusCard(
                        currentNumber:
                            hasError ? null : currentItem.activeCases,
                        title: 'Aktivni',
                        color: activeColor,
                        delta: hasError ? -1 : currentItem.deltaActive,
                        showLineAbove: true,
                      ),
                      DailyStatusCard(
                        currentNumber: hasError ? null : currentItem.deaths,
                        title: 'Umrli',
                        color: deathsColor,
                        delta: hasError ? -1 : currentItem.deltaDeaths,
                        showLineAbove: true,
                      ),
                    ],
                  ),
                ),
                DailyStats(item: currentItem),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
