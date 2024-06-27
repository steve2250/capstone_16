import 'package:flutter/material.dart'; //Material 디자인 패키지
import 'package:cloud_firestore/cloud_firestore.dart'; //Firebase Firestore 패키지
import 'package:shared_preferences/shared_preferences.dart'; //Shared Preferences 패키지
import '../tab/tab_page.dart'; //로그인 시 화면 전환을 위한 페이지 임포트
import 'signup_page.dart'; //회원가입 화면으로의 전환을 위한 페이지 임포트

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _login() async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(_idController.text).get();

      if (userDoc.exists && userDoc['password'] == _passwordController.text) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', _idController.text);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TabPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid ID or Password')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(flex: 1),
              Text(
                '환영합니다!',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 48),
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
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _login,
                child: Text('로그인'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                ),
              ),
              SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                child: Text('회원가입'),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
