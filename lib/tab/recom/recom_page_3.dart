import 'package:flutter/material.dart';
import 'recom_page_4.dart';

class RecomPage3 extends StatefulWidget {
  final bool isWarmTone;
  final String tone;

  const RecomPage3({Key? key, required this.isWarmTone, required this.tone}) : super(key: key);

  @override
  _RecomPage3State createState() => _RecomPage3State();
}

class _RecomPage3State extends State<RecomPage3> {
  late bool _isWarmToneActive;
  late bool _isCoolToneActive;
  String _season = '';

  @override
  void initState() {
    super.initState();
    _isWarmToneActive = widget.isWarmTone;
    _isCoolToneActive = !widget.isWarmTone;
  }

  void _navigateToNextPage(String season) {
    _season = season;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecomPage4(isWarmTone: widget.isWarmTone, tone: widget.tone, season: _season),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('정보 입력'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Text(
                '계절을 선택해주세요',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 24),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: (MediaQuery.of(context).size.width / 2 - 28) / 50,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _isWarmToneActive ? () {
                    _navigateToNextPage('봄');
                  } : null,
                  child: Text('봄'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
                ElevatedButton(
                  onPressed: _isWarmToneActive ? () {
                    _navigateToNextPage('가을');
                  } : null,
                  child: Text('가을'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
                ElevatedButton(
                  onPressed: _isCoolToneActive ? () {
                    _navigateToNextPage('여름');
                  } : null,
                  child: Text('여름'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
                ElevatedButton(
                  onPressed: _isCoolToneActive ? () {
                    _navigateToNextPage('겨울');
                  } : null,
                  child: Text('겨울'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
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
