import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:lotto/provider/history_bloc.dart';
import 'model/history_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '당신에게 행운을 빕니다.'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  HistoryBloc _historyBloc;
  List<int> _nums = [0, 0, 0, 0, 0, 0];
  List<int> _tempNums = [];
  final _random = new Random();

  int basicEpisodeNum = 893;
  String _episodeNum = '893';
  String _currentEpisode = '893';

//  Ads appAds;

  List<DropdownMenuItem<String>> _dropDownMenuItems;

  final String appId = Platform.isAndroid
      ? 'ca-app-pub-4196993510412288~2795605371'
      : 'ca-app-pub-4196993510412288~8645029551';

  final String bannerUnitId = Platform.isAndroid
      ? 'ca-app-pub-4196993510412288/9169442036'
      : 'ca-app-pub-4196993510412288/6827716700';

  int next(int min, int max) => min + _random.nextInt(max - min);

  @override
  // ignore: must_call_super
  void initState() {
    DateTime basicDate = DateTime(2020, 1, 11, 21);
    DateTime nowDate = DateTime.now();

    final differenceWeek = (nowDate.difference(basicDate).inDays / 7).floor();

    _episodeNum = (basicEpisodeNum + differenceWeek).toString();
    _currentEpisode = (basicEpisodeNum + differenceWeek).toString();

    print('difference: $differenceWeek');

    _dropDownMenuItems = getDropDownMenuItems();

    BannerAd myBanner = BannerAd(
      adUnitId: bannerUnitId,
      size: AdSize.smartBanner,
      listener: (MobileAdEvent event) {
        print("BannerAd event is $event");
      },
    );

    myBanner
      ..load()
      ..show(
        anchorOffset: 0.0,
        horizontalCenterOffset: 0.0,
        // Banner Position
        anchorType: AnchorType.bottom,
      );

    _historyBloc = HistoryBloc(_episodeNum);
    _shackNumber();
  }

  @override
  void dispose() {
    _historyBloc.dispose();
    super.dispose();
  }

  _shackNumber() {
    _tempNums = [];
    for (int i = 0; i < 6; i++) {
      int randomNum = next(1, 45);

      if (_tempNums.indexOf(randomNum) == -1) {
        _tempNums.add(randomNum);
      } else {
        i = i - 1;
      }
    }
    _tempNums.sort();

    setState(() {
      _nums = _tempNums;
    });
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 1; i < int.parse(_episodeNum) + 1; i++) {
      items.add(new DropdownMenuItem(value: '$i', child: new Text('$i')));
    }
    return items;
  }

  void changedDropDownItem(String selectEpisode) {
    setState(() {
      _currentEpisode = selectEpisode;
      _historyBloc.fetch(_currentEpisode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 8.0),
                  child: Text(
                    '로또 회차 선택',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.black54),
                  ),
                ),
                DropdownButton(
                  value: '$_currentEpisode',
                  items: _dropDownMenuItems,
                  onChanged: changedDropDownItem,
                ),
              ],
            ),
            Text(
              '$_currentEpisode회차 당첨 번호',
              style: TextStyle(fontSize: 32.0),
            ),
            StreamBuilder<History>(
              stream: _historyBloc.history$,
              builder: (context, snapshot) {
                print('${snapshot.data}');
                return !snapshot.hasData
                    ? CircularProgressIndicator()
                    : Container(
                        child: Column(
                        children: <Widget>[
                          Container(
                            child: Text(
                              '${snapshot.data.drwNoDate}',
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                            margin: EdgeInsets.only(bottom: 8.0),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Center(),
                              ),
                              _pickNumberWidget(snapshot.data.drwtNo1),
                              _pickNumberWidget(snapshot.data.drwtNo2),
                              _pickNumberWidget(snapshot.data.drwtNo3),
                              _pickNumberWidget(snapshot.data.drwtNo4),
                              _pickNumberWidget(snapshot.data.drwtNo5),
                              _pickNumberWidget(snapshot.data.drwtNo6),
                              Icon(Icons.add),
                              _pickNumberWidget(snapshot.data.bnusNo),
                              Expanded(
                                child: Center(),
                              ),
                            ],
                          ),
                        ],
                      ));
              },
            ),
            Divider(
              thickness: 2.0,
              height: 96,
            ),
            Text(
              '로또 행운 번호 생성',
              style: TextStyle(fontSize: 32.0),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Center(),
                ),
                _pickNumberWidget(_nums[0]),
                _pickNumberWidget(_nums[1]),
                _pickNumberWidget(_nums[2]),
                _pickNumberWidget(_nums[3]),
                _pickNumberWidget(_nums[4]),
                _pickNumberWidget(_nums[5]),
                Expanded(
                  child: Center(),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            FloatingActionButton(
              onPressed: _shackNumber,
              tooltip: 'Increment',
              child: Icon(Icons.refresh),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pickNumberWidget(int number) {
    return Center(
      child: Container(
        width: 48,
        decoration: BoxDecoration(
          color: number >= 40
              ? Colors.green
              : number >= 30
                  ? Colors.grey
                  : number >= 20
                      ? Colors.red
                      : number >= 10 ? Colors.blue : Colors.orange,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: Text(
              '$number',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
