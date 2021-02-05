import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:covid19hr/model.dart';
import 'package:flutter/foundation.dart';

Future<AppData> fetchData() async {
  try {
    final response = await http.get(Uri.parse(
        'https://api.allorigins.win/get?url=https%3A%2F%2Fwww.koronavirus.hr%2Fjson%2F%3Faction%3Dpodaci'));
    final response2 = await http.get(Uri.parse(
        'https://api.allorigins.win/get?url=https%3A%2F%2Fwww.koronavirus.hr%2Fjson%2F%3Faction%3Dpo_danima_zupanijama'));

    // await Future.delayed(Duration(seconds: 10));
    final parsed = await compute(parseGlobalData, response.body);
    final parsed2 = await compute(parseCountyData, response2.body);
    // final parsed = parseData(response.body);
    return new AppData(
      globalData: parsed,
      countyData: parsed2,
    ); // processData(parsed.reversed.toList());
  } catch (e) {
    return AppData();
  }
}

List<CountyData> parseCountyData(String responseBody) {
  final contents = jsonDecode(responseBody)['contents'];
  final parsed = jsonDecode(contents).cast<Map<String, dynamic>>();

  return parsed.map<CountyData>((json) => CountyData.fromJson(json)).toList();
}

List<GlobalDataRecord> parseGlobalData(String responseBody) {
  final contents = jsonDecode(responseBody)['contents'];
  final parsed = jsonDecode(contents).cast<Map<String, dynamic>>();

  return parsed
      .map<GlobalDataRecord>((json) => GlobalDataRecord.fromJson(json))
      .toList();
}

List<GlobalDataRecord> processGlobalData(List<GlobalDataRecord> inputList) {
  final initialRecord = GlobalDataRecord(
    casesCroatia: 1,
    deathsCroatia: 0,
    recoveriesCroatia: 0,
    date: DateTime.parse('2020-02-25 08:00'),
    casesWorld: 0,
    deathsWorld: 0,
    recoveriesWorld: 0,
    deltaActive: 0,
    deltaDeaths: 0,
    deltaRecoveries: 0,
    deltaTotal: 0,
    rzero: 0,
  );

  final input = [initialRecord, ...inputList.reversed];

  List<GlobalDataRecord> newList = [];

  for (var i = 0; i < input.length; i++) {
    final DateTime tempDate = initialRecord.date.add(Duration(days: i));
    final previousItem = i == 0 ? null : input.elementAt(i - 1);
    final item = input.elementAt(i);

    newList.add(
      GlobalDataRecord(
          deltaTotal: previousItem != null
              ? item.casesCroatia - previousItem.casesCroatia
              : 0,
          deltaRecoveries: previousItem != null
              ? item.recoveriesCroatia - previousItem.recoveriesCroatia
              : 0,
          deltaDeaths: previousItem != null
              ? item.deathsCroatia - previousItem.deathsCroatia
              : 0,
          deltaActive: previousItem != null
              ? item.activeCroatia - previousItem.activeCroatia
              : 0,
          rzero: previousItem != null
              ? item.casesCroatia / previousItem.casesCroatia
              : 0,
          casesCroatia: item.casesCroatia,
          casesWorld: item.casesWorld,
          deathsCroatia: item.deathsCroatia,
          deathsWorld: item.deathsWorld,
          recoveriesCroatia: item.recoveriesCroatia,
          recoveriesWorld: item.recoveriesWorld,
          date: DateTime.parse(
              '${tempDate.year}-${tempDate.month.toString().padLeft(2, '0')}-${tempDate.day.toString().padLeft(2, '0')} ${item.date.hour.toString().padLeft(2, '0')}:${item.date.minute.toString().padLeft(2, '0')}')),
    );
  }

  return newList;
}

List<CountyData> processCountyData(List<CountyData> inputList) {
  List<CountyData> newList = [];

  for (CountyData item in inputList.reversed) {
    final i = inputList.reversed.toList().indexOf(item);
    CountyData previousItem =
        i == 0 ? null : inputList.reversed.toList().elementAt(i - 1);

    CountyData newItem =
        CountyData(date: item.date, records: <CountyDataRecord>[]);

    for (CountyDataRecord record in item.records) {
      CountyDataRecord previousRecord = previousItem == null
          ? null
          : previousItem.records.firstWhere(
              (CountyDataRecord r) => r.countyName == record.countyName);

      newItem.records.add(
        CountyDataRecord(
          activeCases: record.activeCases,
          countyName: record.countyName,
          deaths: record.deaths,
          totalCases: record.totalCases,
          deltaTotal: previousItem != null && previousRecord != null
              ? record.totalCases - previousRecord.totalCases
              : 0,
          deltaActive: previousItem != null && previousRecord != null
              ? record.activeCases - previousRecord.activeCases
              : 0,
          deltaDeaths:
              previousItem != null ? record.deaths - previousRecord.deaths : 0,
          deltaRecoveries: previousItem != null && previousRecord != null
              ? record.recoveries - previousRecord.recoveries
              : 0,
        ),
      );
    }

    newList.add(newItem);
  }

  return newList;
}
