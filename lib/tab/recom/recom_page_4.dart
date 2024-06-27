import 'package:flutter/material.dart';
import 'recom_page_5.dart';

class RecomPage4 extends StatelessWidget {
  final bool isWarmTone;
  final String tone;
  final String season;

  const RecomPage4({
    Key? key,
    required this.isWarmTone,
    required this.tone,
    required this.season,
  }) : super(key: key);

  void _navigateToNextPage(BuildContext context, String subSeason) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecomPage5(
          isWarmTone: isWarmTone,
          tone: tone,
          season: season,
          subSeason: subSeason,
        ),
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
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '거의 다 왔어요!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: List<Widget>.generate(
                    5,
                        (index) {
                      String subSeason = ['Soft(Mute)', 'Light', 'Bright', 'Deep(Dark)', 'True'][index];
                      bool isActive = false;

                      if (season == '봄' && ['Light', 'Bright', 'True'].contains(subSeason)) {
                        isActive = true;
                      } else if (season == '여름' && ['Light', 'True', 'Soft(Mute)'].contains(subSeason)) {
                        isActive = true;
                      } else if (season == '가을' && ['Soft(Mute)', 'True', 'Deep(Dark)'].contains(subSeason)) {
                        isActive = true;
                      } else if (season == '겨울' && ['Bright', 'True', 'Deep(Dark)'].contains(subSeason)) {
                        isActive = true;
                      }

                      return ElevatedButton(
                        onPressed: isActive
                            ? () {
                          _navigateToNextPage(context, subSeason);
                        }
                            : null,
                        child: Text(
                          '#$subSeason',
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
