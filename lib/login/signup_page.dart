import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController(); // 사용자 ID 입력
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _signUp() async {
    try {
      // Firestore에 사용자 정보 저장
      await _firestore.collection('users').doc(_idController.text).set({
        'name': _nameController.text,
        'id': _idController.text,
        'password': _passwordController.text,
        'nickname': _nicknameController.text,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign up: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      body: SingleChildScrollView( // 스크롤 가능하게 하기 위해
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 48),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: '이름 입력',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _idController,
              decoration: InputDecoration(
                labelText: '아이디 입력',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: '비밀번호 입력',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _nicknameController,
              decoration: InputDecoration(
                labelText: '닉네임 입력',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _signUp,
              child: Text('회원가입'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // 버튼 높이
              ),
            ),
          ],
        ),
      ),
    );
  }
}
