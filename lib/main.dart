import 'dart:io';

import 'package:ads/ads.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:lotto/provider/history_bloc.dart';
import 'model/history_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  int _episodeNum = 880;
  Ads appAds;

  final String appId = Platform.isAndroid
      ? 'ca-app-pub-2558645202827085~8690630192'
      : '';

  final String bannerUnitId = Platform.isAndroid
      ? 'ca-app-pub-2558645202827085/6996057533'
      : '';

  int next(int min, int max) => min + _random.nextInt(max - min);


  @override
  void initState() {
    appAds = Ads(
      appId,
      bannerUnitId: bannerUnitId,
      childDirected: false,
      testDevices: ['Samsung_Galaxy_SII_API_26:5554'],
      testing: true,
    );

    appAds.showBannerAd();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_episodeNum회차 번호',
              style: TextStyle(fontSize: 32.0),
            ),
            StreamBuilder<History>(
              stream: _historyBloc.history$,
              builder: (context, snapshot) {
                print('${snapshot.data}');
                return !snapshot.hasData
                    ? CircularProgressIndicator()
                    : Container(
                        child: Row(
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
                            Expanded(
                              child: Center(),
                            ),
                          ],
                        ),
                      );
              },
            ),
            Divider(
              thickness: 2.0,
              height: 48,
            ),
            Text(
              '로또 행운 번호',
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
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
