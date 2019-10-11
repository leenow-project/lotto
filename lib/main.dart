import 'package:flutter/material.dart';
import 'dart:math';

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
  List<int> nums = [0, 0, 0, 0, 0, 0];
  List<int> tempNums = [];
  final _random = new Random();

  int next(int min, int max) => min + _random.nextInt(max - min);

  @override
  void initState() {
    _shackNumber();
  }

  _shackNumber() {
    tempNums = [];
    for (int i = 0; i < 6; i++) {
      int randomNum = next(1, 45);

      if (tempNums.indexOf(randomNum) == -1) {
        tempNums.add(randomNum);
      } else {
        i = i - 1;
      }
    }
    tempNums.sort();

    setState(() {
      nums = tempNums;
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
              '로또 당첨 번호',
              style: TextStyle(
                fontSize: 32.0
              ),
            ),
            Row(
              children: <Widget>[
                _pickNumberWidget(nums[0]),
                _pickNumberWidget(nums[1]),
                _pickNumberWidget(nums[2]),
                _pickNumberWidget(nums[3]),
                _pickNumberWidget(nums[4]),
                _pickNumberWidget(nums[5]),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _shackNumber,
        tooltip: 'Increment',
        child: Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _pickNumberWidget(int number) {
    return Expanded(
      child: Center(
        child: Container(
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
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '$number',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
