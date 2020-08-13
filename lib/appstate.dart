import 'package:covid19hr/data_loading.dart';
import 'package:covid19hr/model.dart';
import 'package:flutter/foundation.dart';

class Covid19Provider extends ChangeNotifier {
  List<DataRecord> _records = [];
  bool _loading = false;

  List<DataRecord> get records => _records;

  bool get loading => _loading;

  updateData() async {
    _loading = true;
    notifyListeners();

    final fetched = await fetchData();
    final processed = processData(fetched);
    _records = [...processed];

    _loading = false;

    notifyListeners();
  }

  clearData() {
    _records = [];
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

  dummyData() {
    _records = [
      DataRecord(
          date: DateTime.now().subtract(Duration(days: 1)),
          casesCroatia: 90,
          recoveriesCroatia: 5,
          deathsCroatia: 1,
          deltaTotal: 0,
          deltaActive: 0,
          deltaDeaths: 0,
          deltaRecoveries: 0),
      DataRecord(
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
