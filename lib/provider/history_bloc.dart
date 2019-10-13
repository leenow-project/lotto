import 'dart:convert';

import 'package:lotto/model/history_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

class HistoryBloc {
  final _historySubject = BehaviorSubject<History>();

  HistoryBloc(String episode) {
    fetch(episode);
  }

  void fetch(String episode) async {
    var history = await getHistoryData(episode);
    _historySubject.add(history);
  }

  void dispose() {
    _historySubject.close();
  }

  Stream<History> get history$ => _historySubject.stream;

  final String baseUrl = 'https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=';

  Future<History> getHistoryData(String episode) async {
    final response = await http.get('$baseUrl$episode');
    if (response.statusCode == 200) {
      return History.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load getHistoryData');
    }
  }
}

