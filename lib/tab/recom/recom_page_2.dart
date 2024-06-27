import 'package:flutter/material.dart';
import 'recom_page_3.dart';

class RecomPage2 extends StatefulWidget {
  @override
  _RecomPage2State createState() => _RecomPage2State();
}

class _RecomPage2State extends State<RecomPage2> {
  bool _isWarmTone = false;
  String _tone = '';

  void _navigateToNextPage() {
    _tone = _isWarmTone ? '웜톤' : '쿨톤';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecomPage3(isWarmTone: _isWarmTone, tone: _tone),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('정보 입력'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Text(
              '톤을 선택해주세요',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isWarmTone = true;
                    });
                    _navigateToNextPage();
                  },
                  child: Text('웜톤'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(150, 50),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isWarmTone = false;
                    });
                    _navigateToNextPage();
                  },
                  child: Text('쿨톤'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(150, 50),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
