import 'dart:math';
import 'dart:ui';

import 'package:covid19hr/styles.dart';
import 'package:expandable_slider/expandable_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:intl/intl.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:provider/provider.dart';
import 'package:flinq/flinq.dart';

import 'appstate.dart';
import 'components/status_blocks.dart';
import 'model.dart';

class GenericChart extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<Covid19Provider>();

    final hasError = provider.loading || provider.data.isEmpty;

    final data = provider.data;

    var swapDelta = useState(true);

    var currentIndex = useState(-1);
    var showVerticalLine = useState(false);

    if (!provider.loading && currentIndex.value == -1) {
      currentIndex.value = data.length - 1;
    }

    final f = DateFormat("d. M.");
    final f2 = DateFormat("HH:mm");

    if (!provider.loading && currentIndex.value > data.length - 1) {
      currentIndex.value = data.length - 1;
    }

    GenericDataRecord currentItem =
        hasError ? null : data.elementAt(currentIndex.value);

    double chartHeight =
        (MediaQuery.of(context).size.height / 1.7).clamp(300.0, 840.0);
    int numOfLines = sqrt(chartHeight).toInt();

    int delta =
        hasError ? 1 : (data[data.length - 1].totalCases / numOfLines).round();

    final sliderExpanded = useState(false);

    return LayoutBuilder(builder: (context, constraints) {
      double maxWidth = constraints.maxWidth;

      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 16.0,
            bottom: 24.0,
          ),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  for (double i = 0; i < numOfLines; i++)
                    Positioned(
                      top: (chartHeight / numOfLines) * i,
                      child: Container(
                        width: maxWidth,
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
                            fontWeight:
                                Theme.of(context).brightness == Brightness.dark
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
                      fillGradient: LinearGradient(
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
                      fillGradient: LinearGradient(
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
                          : data.map((e) => e.activeCases.toDouble()).toList(),
                      fillMode: FillMode.below,
                      lineColor: activeColor,
                      sharpCorners: false,
                      fillGradient: LinearGradient(
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
                      fillGradient: LinearGradient(
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
                    left: (currentIndex.value / (data.length - 1)) *
                        (maxWidth - 1),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.decelerate,
                      color: showVerticalLine.value == true
                          ? Theme.of(context).textTheme.bodyText1.color
                          : Theme.of(context)
                              .textTheme
                              .bodyText1
                              .color
                              .withOpacity(0.2),
                      width: 1,
                      height: showVerticalLine.value
                          ? chartHeight
                          : (chartHeight / numOfLines),
                    ),
                  ),
                ],
              ),
              SizedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 16),
                    Stack(
                      children: [
                        Positioned(
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.ideographic,
                            children: [
                              Container(
                                width: 80,
                                alignment: Alignment.centerRight,
                                child: Text(
                                  hasError ? '' : f.format(currentItem.date),
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(
                                    fontFeatures: [
                                      FontFeature.proportionalFigures()
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 6),
                              Container(
                                width: 80,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  hasError ? '' : f2.format(currentItem.date),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                          fontFeatures: [
                                        FontFeature.proportionalFigures()
                                      ],
                                          color: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .color),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedOpacity(
                                opacity: sliderExpanded.value ? 0.05 : 1,
                                duration: Duration(milliseconds: 250),
                                child: Text(
                                  hasError ? '' : f.format(data.first.date),
                                ),
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        (maxWidth - 80).clamp(100.0, 600.0)),
                                child: Expanded(
                                  child: ExpandableSlider(
                                    min: 0,
                                    max: data.length - 1.toDouble(),
                                    value: currentIndex.value.toDouble(),
                                    onChanged: (newValue) =>
                                        currentIndex.value = newValue.toInt(),
                                    onChangeStart: (_) {
                                      showVerticalLine.value = true;
                                    },
                                    onChangeEnd: (_) {
                                      showVerticalLine.value = false;
                                    },
                                    // divisions: data.length,
                                    estimatedValueStep: 1,
                                    snapCenterScrollCurve: Curves.decelerate,
                                    expansionCurve: Curves.decelerate,
                                    shrinkageCurve: Curves.decelerate,
                                    // activeColor: Theme.of(context).dividerColor,
                                    // inactiveColor: Theme.of(context).dividerColor,
                                    expandsOnDoubleTap: true,
                                    expandsOnScale: true,
                                    expandsOnLongPress: true,
                                    onShrinkageStart: () =>
                                        sliderExpanded.value = false,
                                    onExpansionStart: () =>
                                        sliderExpanded.value = true,
                                  ),
                                ),
                              ),
                              AnimatedOpacity(
                                opacity: sliderExpanded.value ? 0.05 : 1,
                                duration: Duration(milliseconds: 250),
                                child: Text(
                                  hasError ? '' : f.format(data.last.date),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Wrap(
                      runAlignment: WrapAlignment.center,
                      runSpacing: 20,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      children: [
                        getCurrentDataRowItem(
                          context,
                          'Ukupno',
                          currentItem?.totalCases,
                          currentItem?.deltaTotal,
                          totalColor,
                          isCollapsed: true,
                          isDeltaCollapsed: false,
                          isDeltaSwapped: swapDelta.value,
                        ),
                        getCurrentDataRowItem(
                          context,
                          'Aktivni',
                          currentItem?.activeCases,
                          currentItem?.deltaActive,
                          activeColor,
                          isCollapsed: true,
                          isDeltaCollapsed: false,
                          isDeltaSwapped: swapDelta.value,
                        ),
                        getCurrentDataRowItem(
                          context,
                          'Oporavljeni',
                          currentItem?.recoveries,
                          currentItem?.deltaRecoveries,
                          recoveriesColor,
                          isCollapsed: true,
                          isDeltaCollapsed: false,
                          isDeltaSwapped: swapDelta.value,
                        ),
                        getCurrentDataRowItem(
                          context,
                          'Umrli',
                          currentItem?.deaths,
                          currentItem?.deltaDeaths,
                          deathsColor,
                          isCollapsed: true,
                          isDeltaCollapsed: false,
                          isDeltaSwapped: swapDelta.value,
                        ),
                      ],
                    ),
                    // Container(
                    //   margin: const EdgeInsets.only(top: 4),
                    //   width: 420,
                    //   child: CheckboxListTile(
                    //     value: swapDelta.value,
                    //     onChanged: (v) => swapDelta.value = v,
                    //     controlAffinity: ListTileControlAffinity.leading,
                    //     title: Text('Zamijeni ukupan broj s dnevnom promjenom'),
                    //   ),
                    // )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
