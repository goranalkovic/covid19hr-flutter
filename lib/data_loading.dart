import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:covid19hr/model.dart';
import 'package:flutter/foundation.dart';

Future<List<DataRecord>> fetchData() async {
  try {
    final response = await http.get(
        'https://api.allorigins.win/get?url=https%3A%2F%2Fwww.koronavirus.hr%2Fjson%2F%3Faction%3Dpodaci');

    // await Future.delayed(Duration(seconds: 10));
    final parsed = await compute(parseData, response.body);
    // final parsed = parseData(response.body);

    return parsed; // processData(parsed.reversed.toList());
  } catch (e) {
    return <DataRecord>[];
  }
}

List<DataRecord> parseData(String responseBody) {
  final contents = jsonDecode(responseBody)['contents'];
  final parsed = jsonDecode(contents).cast<Map<String, dynamic>>();

  return parsed.map<DataRecord>((json) => DataRecord.fromJson(json)).toList();
}

List<DataRecord> processData(List<DataRecord> inputList) {
  final initialRecord = DataRecord(
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

  List<DataRecord> newList = [];

  for (var i = 0; i < input.length; i++) {
    final DateTime tempDate = initialRecord.date.add(Duration(days: i));
    final previousItem = i == 0 ? null : input.elementAt(i - 1);
    final item = input.elementAt(i);

    newList.add(
      DataRecord(
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
