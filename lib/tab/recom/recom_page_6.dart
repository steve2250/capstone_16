import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:lip_service_2/tab//tab_page.dart';

class RecomPage6 extends StatelessWidget {
  const RecomPage6({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('정보 입력'),
      ),
      body: SingleChildScrollView(
        child: Center( // Center 위젯을 추가하여 내용을 중앙에 정렬
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '감사합니다!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  '입력해주신 정보를 바탕으로',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  '제품을 추천해드릴게요.',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Lottie.asset(
                  'assets/check_animation.json',
                  width: 300,
                  height: 300,
                  fit: BoxFit.fill,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TabPage(initialIndex: 1), // SearchPage1의 인덱스 전달
                      ),
                    );
                  },
                  child: Text(
                    '제품 보러가기',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // 버튼 색상
                    foregroundColor: Colors.white, // 텍스트 색상
                    minimumSize: Size(400, 50), // 버튼의 최소 사이즈 설정
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // 버튼의 둥근 모서리
                    ),
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
