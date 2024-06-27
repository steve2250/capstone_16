import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'recom_page_6.dart'; // 추가

class RecomPage5 extends StatelessWidget {
  final bool isWarmTone;
  final String tone;
  final String season;
  final String subSeason;

  const RecomPage5({
    Key? key,
    required this.isWarmTone,
    required this.tone,
    required this.season,
    required this.subSeason,
  }) : super(key: key);

  Future<void> _savePersonalColor(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(userId).update({
          'personal_color': '$season$tone #$subSeason',
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('퍼스널 컬러가 저장되었습니다!')),
        );

        // 저장 후 RecomPage6로 이동
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RecomPage6()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('저장 실패: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('사용자 정보를 불러올 수 없습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final personalColor = '$tone $season $subSeason';
    String imagePath = 'assets/images/default.png'; // 기본 이미지 경로
    String additionalText = '기본 텍스트';

    // 퍼스널 컬러 결과에 따라 이미지 경로 설정
    if (season == '봄' && subSeason == 'Light') {
      imagePath = 'assets/images/SpWlight.png';
      additionalText = '봄웜톤에 화이트 컬러가 더해진 톤으로, 명도가 높고 대비가 낮아 부드러운 톤을 가지고 있습니다. 채도가 높은 컬러가 받지 않는다면 봄웜 라이트일 확률이 높아요.';
    } else if (season == '봄' && subSeason == 'Bright') {
      imagePath = 'assets/images/SpWbright.png';
      additionalText = '밝은 톤의 봄 웜톤으로, 피부 톤이 밝고 대비도 상대적으로 강합니다. 채도가 높고 비비드한 컬러가 잘 어울리는 특징을 가지고 있습니다.';
    } else if (season == '봄' && subSeason == 'True') {
      imagePath = 'assets/images/SpWtrue.png';
      additionalText = '정석적인 봄 웜톤으로, 옐로우와 오렌지 베이스의 봄 웜톤 컬러는 전반적으로 모두 잘어울려 컬러 선택의 폭이 넓습니다.';
    } else if (season == '여름' && subSeason == 'Light') {
      imagePath = 'assets/images/SuClight.png';
      additionalText = '비비드한 색감의 트루톤에 흰색이 섞인 톤이에요. 흰색이 섞였기 때문에 대체로 맑은 느낌을 주면서 채도가 낮고 밝은 파스텔 톤과 잘 어울립니다.';
    } else if (season == '여름' && subSeason == 'True') {
      imagePath = 'assets/images/SuCtrue.png';
      additionalText = '트루 톤은 원색이 잘 어울려요. 라이트와 소프트 톤 사이의 무난한 중간색으로서 모든 쿨톤 색이 잘 어울린다.가장 색상 선택의 스펙트럼이 넓은 톤입니다.';
    } else if (season == '여름' && subSeason == 'Soft(Mute)') {
      imagePath = 'assets/images/SuCmute.png';
      additionalText = '회색이 섞여 차분한 느낌을 줘요, 뮤트 톤의 사람들은 너무 밝기만 한 것보다 탁하고 그레이 톤이 잘 어울립니다.';
    } else if (season == '가을' && subSeason == 'Soft(Mute)') {
      imagePath = 'assets/images/FaWmute.png';
      additionalText = '트루톤에 회색빛이 더해진 컬러로 조금 더 부드럽고 채도가 낮아요.';
    } else if (season == '가을' && subSeason == 'True') {
      imagePath = 'assets/images/FaWtrue.png';
      additionalText = '가을웜톤의 주를 이루며 명도가 낮고 채도가 높은 것이 특징으로 컬러 스펙트럼이 가장 넓어요';
    } else if (season == '가을' && subSeason == 'Deep(Dark)') {
      imagePath = 'assets/images/FaWdeep.png';
      additionalText = '블랙이 더해져 조금 더 어둡고 깊은 컬러가 잘 어울려요.';
    } else if (season == '겨울' && subSeason == 'Bright') {
      imagePath = 'assets/images/WiCbright.png';
      additionalText = '선명하고 시원한 컬러에 봄 웜톤의 화사함을 더한 겨울쿨 브라이트, 밝고 생생한 컬러가 어울리고 비비드 한 원색이나 네온컬러처럼 인공적으로 느껴지는 컬러가 특징입니다.';
    } else if (season == '겨울' && subSeason == 'True') {
      imagePath = 'assets/images/WiCtrue.png';
      additionalText = '대체적으로 선명하고 눈에 띄는 컬러가 잘 받으며 채도가 낮은색은 어울리지않는다. 차가운 느낌의 쿨 채도 컬러라면 상대적으로 넓게 커버 가능해요.';
    } else if (season == '겨울' && subSeason == 'Deep(Dark)') {
      imagePath = 'assets/images/WiCdark.png';
      additionalText = '전체적으로 채도가 높고 명도가 낮아 깊고 안정감 있는 컬러가 잘 어울립니다. 블랙&화이트 처럼 밝은컬러와 어두운 컬러의 명도대비가 큰 스타일링이 잘 어울려요.';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('퍼스널 컬러 결과'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '당신의 퍼스널 컬러는...',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              Text(
                '$season$tone #$subSeason 입니다!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              Image.asset(
                imagePath,
                height: 200, // 이미지 높이
                width: 200, // 이미지 너비
                fit: BoxFit.cover,
              ),
              SizedBox(height: 16),
              Text(
                additionalText,
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => _savePersonalColor(context),
                child: Text('결과 저장하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
