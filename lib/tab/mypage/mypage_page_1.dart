import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lip_service_2/login/login_page.dart';
import 'my_posts_page.dart';
import 'liked_posts_page.dart';
import 'liked_products_page.dart'; // 추가
import 'user_info_dialog.dart'; // 추가

class MypagePage1 extends StatefulWidget {
  const MypagePage1({Key? key}) : super(key: key);

  @override
  _MypagePage1State createState() => _MypagePage1State();
}

class _MypagePage1State extends State<MypagePage1> {
  String _name = 'Loading...';
  String _userId = '';
  String _personalColor = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      if (userId != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

        if (userDoc.exists) {
          setState(() {
            _userId = userId;
            _name = userDoc['name'] ?? 'Unknown';
            _personalColor = userDoc['personal_color'] ?? '정보 없음';
          });
        } else {
          setState(() {
            _name = 'User not found';
          });
        }
      } else {
        setState(() {
          _name = 'No user ID found';
        });
      }
    } catch (e) {
      setState(() {
        _name = 'Error loading user data';
      });
    }
  }

  Future<void> _showUserInfo() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      if (userId != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

        if (userDoc.exists) {
          String name = userDoc['name'] ?? 'Unknown';
          String personalColor = userDoc['personal_color'] ?? '정보 없음';

          showDialog(
            context: context,
            builder: (context) => UserInfoDialog(
              userId: userId,
              name: name,
              personalColor: personalColor,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User not found')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user ID found')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading user data')),
      );
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('마이페이지'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '안녕하세요, $_name님!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _showUserInfo, // 내 정보 버튼 클릭 시
              child: Text('내 정보'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyPostsPage()),
                );
              },
              child: Text('내 게시물'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LikedPostsPage()), // 좋아요 한 게시물 페이지로 이동
                );
              },
              child: Text('좋아요 누른 게시물'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LikedProductsPage()), // 찜한 목록 페이지로 이동
                );
              },
              child: Text('찜한 목록'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: _logout,
              child: Text('로그아웃'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.red, // 로그아웃 버튼을 빨간색으로 설정
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
