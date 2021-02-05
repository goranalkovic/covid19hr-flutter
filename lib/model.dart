import 'package:intl/intl.dart';

class AppData {
  List<GlobalDataRecord> globalData;
  List<CountyData> countyData;

  AppData({
    this.globalData,
    this.countyData,
  });
}

/*
 {
          SlucajeviSvijet: null,
          SlucajeviHrvatska: 1,
          UmrliSvijet: null,
          UmrliHrvatska: 0,
          IzlijeceniSvijet: null,
          IzlijeceniHrvatska: 0,
          Datum: "2020-02-25 08:00",
        }
 */

class GlobalDataRecord {
  int casesWorld;
  int casesCroatia;

  int deathsWorld;
  int deathsCroatia;

  int recoveriesWorld;
  int recoveriesCroatia;

  int deltaTotal;
  int deltaDeaths;
  int deltaRecoveries;
  int deltaActive;

  double rzero;

  int get activeCroatia => casesCroatia - deathsCroatia - recoveriesCroatia;
  int get activeWorld => casesWorld - deathsWorld - recoveriesWorld;

  String get deltaTotalDisplay => deltaTotal == 0
      ? '0'
      : deltaTotal > 0
          ? '+$deltaTotal'
          : '$deltaTotal';

  String get deltaDeathsDisplay => deltaDeaths == 0
      ? '0'
      : deltaDeaths > 0
          ? '+$deltaDeaths'
          : '$deltaDeaths';

  String get deltaRecoveriesDisplay => deltaRecoveries == 0
      ? '0'
      : deltaRecoveries > 0
          ? '+$deltaRecoveries'
          : '$deltaRecoveries';

  String get deltaActiveDisplay => deltaActive == 0
      ? '0'
      : deltaActive > 0
          ? '+$deltaActive'
          : '$deltaActive';

  final DateTime date;

  GlobalDataRecord(
      {this.casesWorld,
      this.casesCroatia,
      this.deathsWorld,
      this.deathsCroatia,
      this.recoveriesWorld,
      this.recoveriesCroatia,
      this.date,
      this.deltaActive,
      this.deltaDeaths,
      this.deltaRecoveries,
      this.deltaTotal,
      this.rzero});

  factory GlobalDataRecord.fromJson(Map<String, dynamic> json) {
    return GlobalDataRecord(
      casesWorld: json['SlucajeviSvijet'] as int,
      casesCroatia: json['SlucajeviHrvatska'] as int,
      deathsWorld: json['UmrliSvijet'] as int,
      deathsCroatia: json['UmrliHrvatska'] as int,
      recoveriesWorld: json['IzlijeceniSvijet'] as int,
      recoveriesCroatia: json['IzlijeceniHrvatska'] as int,
      date: DateTime.parse(json['Datum']),
    );
  }
}

/*

{"broj_zarazenih":1170,"broj_umrlih":24,"broj_aktivni":226,"Zupanija":"Bjelovarsko-bilogorska"}

 */

class CountyDataRecord {
  String countyName;
  int totalCases;
  int activeCases;
  int deaths;
  int get recoveries => totalCases - activeCases - deaths;

  int deltaTotal;
  int deltaActive;
  int deltaDeaths;
  int deltaRecoveries;

  double rzero;

  String toString() =>
      'CountyDataRecord - $countyName - total $totalCases, active $activeCases, deaths: $deaths';

  String get deltaTotalDisplay => deltaTotal == 0
      ? '0'
      : deltaTotal > 0
          ? '+$deltaTotal'
          : '$deltaTotal';

  String get deltaActiveDisplay => deltaActive == 0
      ? '0'
      : deltaActive > 0
          ? '+$deltaActive'
          : '$deltaActive';

  String get deltaDeathsDisplay => deltaDeaths == 0
      ? '0'
      : deltaDeaths > 0
          ? '+$deltaDeaths'
          : '$deltaDeaths';

  String get deltaRecoveriesDisplay => deltaRecoveries == 0
      ? '0'
      : deltaRecoveries > 0
          ? '+$deltaRecoveries'
          : '$deltaRecoveries';

  CountyDataRecord({
    this.countyName,
    this.totalCases,
    this.activeCases,
    this.deltaActive,
    this.deltaTotal,
    this.rzero,
    this.deaths,
    this.deltaDeaths,
    this.deltaRecoveries,
  });

  factory CountyDataRecord.fromJson(Map<String, dynamic> json) {
    return CountyDataRecord(
      totalCases: json['broj_zarazenih'] as int,
      deaths: json['broj_umrlih'] as int,
      activeCases: json['broj_aktivni'] as int,
      countyName: json['Zupanija'],
    );
  }
}

NumberFormat formatter = NumberFormat('###,###,###');

/*
{"Datum":"2020-11-07 08:21","PodaciDetaljno":[...] }
 */

class CountyData {
  final DateTime date;
  final List<CountyDataRecord> records;

  CountyData({this.date, this.records});

  factory CountyData.fromJson(Map<String, dynamic> json) {
    return CountyData(
        date: DateTime.parse(json['Datum']),
        records: (json['PodaciDetaljno'] as List)
            .map((i) => CountyDataRecord.fromJson(i))
            .toList());
  }
}

class GenericDataRecord {
  DateTime date;

  int totalCases;
  int activeCases;
  int deaths;
  int recoveries;

  int deltaTotal;
  int deltaActive;
  int deltaDeaths;
  int deltaRecoveries;

  double rzero;

  String get deltaTotalDisplay => deltaTotal == 0
      ? '0'
      : deltaTotal > 0
          ? '+${formatter.format(deltaTotal)}'
          : '${formatter.format(deltaTotal)}';

  String get deltaDeathsDisplay => deltaDeaths == 0
      ? '0'
      : deltaDeaths > 0
          ? '+${formatter.format(deltaDeaths)}'
          : '${formatter.format(deltaDeaths)}';

  String get deltaRecoveriesDisplay => deltaRecoveries == 0
      ? '0'
      : deltaRecoveries > 0
          ? '+${formatter.format(deltaRecoveries)}'
          : '${formatter.format(deltaRecoveries)}';

  String get deltaActiveDisplay => deltaActive == 0
      ? '0'
      : deltaActive > 0
          ? '+${formatter.format(deltaActive)}'
          : '${formatter.format(deltaActive)}';

  GenericDataRecord(
      {this.date,
      this.totalCases,
      this.activeCases,
      this.deaths,
      this.recoveries,
      this.deltaTotal,
      this.deltaActive,
      this.deltaDeaths,
      this.deltaRecoveries,
      this.rzero});

  factory GenericDataRecord.fromGlobal(GlobalDataRecord record) {
    return GenericDataRecord(
      date: record.date,
      totalCases: record.casesCroatia,
      activeCases: record.activeCroatia,
      deaths: record.deathsCroatia,
      recoveries: record.recoveriesCroatia,
      deltaTotal: record.deltaTotal,
      deltaActive: record.deltaActive,
      deltaRecoveries: record.deltaRecoveries,
      deltaDeaths: record.deltaDeaths,
      rzero: record.rzero,
    );
  }

  factory GenericDataRecord.fromCounty(CountyDataRecord record, DateTime date) {
    return GenericDataRecord(
      date: date,
      totalCases: record.totalCases,
      activeCases: record.activeCases,
      deaths: record.deaths,
      recoveries: record.recoveries,
      deltaTotal: record.deltaTotal,
      deltaActive: record.deltaActive,
      deltaRecoveries: record.deltaRecoveries,
      deltaDeaths: record.deltaDeaths,
      rzero: record.rzero,
    );
  }
}
