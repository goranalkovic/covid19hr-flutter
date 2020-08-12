import 'package:covid19hr/status_card.dart';
import 'package:covid19hr/styles.dart';
import 'package:covid19hr/titled_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          elevation: 0,
          stretch: true,
          pinned: true,
          bottom: PreferredSize(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.refresh_rounded,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  SizedBox(width: 4),
                  Shimmer(
                    direction: ShimmerDirection.fromLeftToRight(),
                    child: SizedBox(
                      width: 120,
                      height: 14,
                    ),
                  ),
                ],
              ),
            ),
            preferredSize: Size.fromHeight(40),
          ),
          title: Row(
            children: [
              Icon(
                Icons.flare_rounded,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.deepPurple
                    : Colors.deepPurple[100],
              ),
              SizedBox(width: 6),
              Text(
                'COVID-19 podaci',
                style: TextStyle(
                  fontFamily:
                      GoogleFonts.sourceCodeProTextTheme().bodyText1.fontFamily,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyText1.color,
                ),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).cardColor,
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: 12),
        ),

        SliverToBoxAdapter(
          child: TitledCard(
            title: 'Najnoviji podaci',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    DailyStatusCard(
                      title: 'Ukupno',
                      currentNumber: null,
                      delta: null,
                      color: totalColor,
                    ),
                    DailyStatusCard(
                      title: 'Oporavljeni',
                      currentNumber: null,
                      delta: null,
                      color: recoveriesColor,
                    ),
                    DailyStatusCard(
                      title: 'Umrli',
                      currentNumber: null,
                      delta: null,
                      color: deathsColor,
                    ),
                    DailyStatusCard(
                      title: 'Aktivni',
                      currentNumber: null,
                      delta: null,
                      color: activeColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: TitledCard(
            title: 'Podjela slučaja',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Shimmer(
                    direction: ShimmerDirection.fromLeftToRight(),
                    child: Container(
                      width: 360,
                      height: 10,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    DailyStatusCard(
                      currentNumber: null,
                      title: 'Oporavljeni',
                      suffix: '%',
                    ),
                    DailyStatusCard(
                      currentNumber: null,
                      title: 'Aktivni',
                      suffix: '%',
                    ),
                    DailyStatusCard(
                      currentNumber: null,
                      title: 'Umrli',
                      suffix: '%',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: TitledCard(
            title: 'Grafički prikaz',
            child: Shimmer(
              direction: ShimmerDirection.fromLeftToRight(),
              child: SizedBox(
                height: 300,
                width: double.infinity,
              ),
            ),
          ),
        ),
        // SliverToBoxAdapter(
        //   child: Container(
        //     width: 500,
        //     height: 400,
        //     child: ,
        //   ),
        // ),
        SliverToBoxAdapter(
          child: TitledCard(
            title: 'Tablični prikaz',
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
                        width: 68,
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
                SizedBox(
                  height: 320,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemCount: 6,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final isToday = index == 0;

                      return Container(
                        height: 60,
                        margin: const EdgeInsets.symmetric(vertical: 2),
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
                              width: 68,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Shimmer(
                                    direction:
                                        ShimmerDirection.fromLeftToRight(),
                                    child: SizedBox(
                                      height: 32,
                                      width: 72,
                                    ),
                                  ),
                                  Shimmer(
                                    direction:
                                        ShimmerDirection.fromLeftToRight(),
                                    child: SizedBox(
                                      height: 24,
                                      width: 36,
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
                                  Shimmer(
                                    direction:
                                        ShimmerDirection.fromLeftToRight(),
                                    child: SizedBox(
                                      height: 32,
                                      width: 72,
                                    ),
                                  ),
                                  Shimmer(
                                    direction:
                                        ShimmerDirection.fromLeftToRight(),
                                    child: SizedBox(
                                      height: 24,
                                      width: 36,
                                    ),
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
                                  Shimmer(
                                    direction:
                                        ShimmerDirection.fromLeftToRight(),
                                    child: SizedBox(
                                      height: 32,
                                      width: 72,
                                    ),
                                  ),
                                  Shimmer(
                                    direction:
                                        ShimmerDirection.fromLeftToRight(),
                                    child: SizedBox(
                                      height: 24,
                                      width: 36,
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
                                  Shimmer(
                                    direction:
                                        ShimmerDirection.fromLeftToRight(),
                                    child: SizedBox(
                                      height: 32,
                                      width: 72,
                                    ),
                                  ),
                                  Shimmer(
                                    direction:
                                        ShimmerDirection.fromLeftToRight(),
                                    child: SizedBox(
                                      height: 24,
                                      width: 36,
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
                                  Shimmer(
                                    direction:
                                        ShimmerDirection.fromLeftToRight(),
                                    child: SizedBox(
                                      height: 24,
                                      width: 30,
                                    ),
                                  ),
                                  Shimmer(
                                    direction:
                                        ShimmerDirection.fromLeftToRight(),
                                    child: SizedBox(
                                      height: 12,
                                      width: 24,
                                    ),
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
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(6),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 20,
              children: [
                Text(
                  'Podaci preuzeti s javnog dostupnog API-ja Nacionalnog stožera',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.6,
                    color: Colors.grey,
                  ),
                ),
                Text('Copyright © Goran Alković, 2020')
              ],
            ),
          ),
        ),
      ],
    );
  }
}
