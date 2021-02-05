import 'package:covid19hr/data_loading.dart';
import 'package:covid19hr/model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Covid19Provider extends ChangeNotifier {
  List<GlobalDataRecord> _globalRecords = [];
  List<CountyData> _countyRecords = [];
  bool _loading = false;
  String _county;
  ThemeMode _themeMode = ThemeMode.system;

  List<GlobalDataRecord> get globalRecords => _globalRecords;
  List<CountyData> get countyRecords => _countyRecords;
  String get county => _county;
  ThemeMode get themeMode => _themeMode;

  List<GenericDataRecord> get data {
    List<GenericDataRecord> tempList = [];

    if (_county == null) {
      for (var record in _globalRecords) {
        tempList.add(GenericDataRecord.fromGlobal(record));
      }
    } else {
      for (var item in _countyRecords) {
        tempList.add(GenericDataRecord.fromCounty(
            item.records
                .firstWhere((CountyDataRecord r) => r.countyName == _county),
            item.date));
      }
    }

    return tempList;
  }

  bool get loading => _loading;

  updateData() async {
    HapticFeedback.heavyImpact();
    _loading = true;
    notifyListeners();

    final fetched = await fetchData();
    final processedGlobal = processGlobalData(fetched.globalData);
    final processedCounty = processCountyData(fetched.countyData);
    _globalRecords = [...processedGlobal];
    _countyRecords = [...processedCounty];

    _loading = false;
    HapticFeedback.lightImpact();
    notifyListeners();
  }

  changeThemeMode(ThemeMode newMode) {
    _themeMode = newMode;
    notifyListeners();
  }

  clearData() {
    _globalRecords = [];
    notifyListeners();
  }

  turnOnLoading() {
    _loading = true;
    notifyListeners();
  }

  turnOffLoading() {
    _loading = false;
    notifyListeners();
  }

  changeCounty(String newCounty) {
    _county = newCounty;
    notifyListeners();
  }

  setToGlobalData() {
    _county = null;
    notifyListeners();
  }

  dummyData() {
    _globalRecords = [
      GlobalDataRecord(
          date: DateTime.now().subtract(Duration(days: 1)),
          casesCroatia: 90,
          recoveriesCroatia: 5,
          deathsCroatia: 1,
          deltaTotal: 0,
          deltaActive: 0,
          deltaDeaths: 0,
          deltaRecoveries: 0),
      GlobalDataRecord(
          date: DateTime.now(),
          casesCroatia: 100,
          recoveriesCroatia: 20,
          deathsCroatia: 3,
          deltaTotal: 10,
          deltaActive: 7,
          deltaDeaths: 2,
          deltaRecoveries: 15),
    ];
    notifyListeners();
  }

  Covid19Provider() {
    updateData();
  }
}

List<String> counties = [
  "Bjelovarsko-bilogorska",
  "Brodsko-posavska",
  "Dubrovačko-neretvanska",
  "Grad Zagreb",
  "Istarska",
  "Karlovačka",
  "Koprivničko-križevačka",
  "Krapinsko-zagorska županija",
  "Ličko-senjska",
  "Međimurska",
  "Osječko-baranjska",
  "Požeško-slavonska",
  "Primorsko-goranska",
  "Šibensko-kninska",
  "Sisačko-moslavačka",
  "Splitsko-dalmatinska",
  "Varaždinska",
  "Virovitičko-podravska",
  "Vukovarsko-srijemska",
  "Zadarska",
  "Zagrebačka "
];
