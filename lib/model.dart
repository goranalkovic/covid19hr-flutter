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

class DataRecord {
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

  String get deltaTotalDisplay =>
      deltaTotal == 0 ? '0' : deltaTotal > 0 ? '+$deltaTotal' : '$deltaTotal';

  String get deltaDeathsDisplay => deltaDeaths == 0
      ? '0'
      : deltaDeaths > 0 ? '+$deltaDeaths' : '$deltaDeaths';

  String get deltaRecoveriesDisplay => deltaRecoveries == 0
      ? '0'
      : deltaRecoveries > 0 ? '+$deltaRecoveries' : '$deltaRecoveries';

  String get deltaActiveDisplay => deltaActive == 0
      ? '0'
      : deltaActive > 0 ? '+$deltaActive' : '$deltaActive';

  final DateTime date;

  DataRecord(
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

  factory DataRecord.fromJson(Map<String, dynamic> json) {
    return DataRecord(
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
