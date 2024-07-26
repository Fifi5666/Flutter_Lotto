import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(LottoApp());
}

class LottoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lotto App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LottoHomePage(),
    );
  }
}

class LottoHomePage extends StatefulWidget {
  @override
  _LottoHomePageState createState() => _LottoHomePageState();
}

class _LottoHomePageState extends State<LottoHomePage> {
  List<List<int>> _allNumbers = [];
  List<int> _currentNumbers = [];
  bool _isGenerating = false;

  void _generateNumbers() async {
    if (_allNumbers.length >= 5) return;
    _currentNumbers = _getLottoNumbers();
    _isGenerating = true;

    for (int i = 0; i < _currentNumbers.length; i++) {
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        _allNumbers = List.from(_allNumbers);
        if (_allNumbers.isEmpty || _allNumbers.last.length == 6) {
          _allNumbers.add([]);
        }
        _allNumbers.last.add(_currentNumbers[i]);
      });
    }

    _isGenerating = false;
  }

  void _resetNumbers() {
    setState(() {
      _allNumbers = [];
      _currentNumbers = [];
    });
  }

  List<int> _getLottoNumbers() {
    List<int> numbers = List.generate(45, (index) => index + 1);
    numbers.shuffle();
    return numbers.take(6).toList()..sort();
  }

  Color _getBallColor(int number) {
    if (number <= 10) {
      return Color.fromARGB(255, 255, 207, 47);
    } else if (number <= 20) {
      return Colors.lightBlue;
    } else if (number <= 30) {
      return Colors.red;
    } else if (number <= 40) {
      return Colors.grey;
    } else {
      return Colors.lightGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lotto 당일만'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '당신을 일등으로 만들어드립니다',
              style: GoogleFonts.diphylleia(textStyle: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),),
            ),
            SizedBox(height: 20),
            _allNumbers.isEmpty
                ? Text(
                    '-',
                    style: Theme.of(context).textTheme.headlineMedium,
                  )
                : Column(
                    children: _allNumbers.map((numbers) {
                       return Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                          child: Wrap(
                            spacing: 10,
                            children: numbers.map((number) {
                              return Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: _getBallColor(number),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  number.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                       );
                    }).toList(),
                  ),
            SizedBox(height: 20),
            _isGenerating
                ? CircularProgressIndicator()
                : (_allNumbers.length < 5
                    ? ElevatedButton(
                        onPressed: _generateNumbers,
                        child: Text('추첨'),
                      )
                    : ElevatedButton(
                        onPressed: _resetNumbers,
                        child: Text('다시 하기'),
                      )),
          ],
        ),
      ),
    );
  }
}
