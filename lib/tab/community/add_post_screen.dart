import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPostScreen extends StatefulWidget {
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String _userId = '';
  String _nickname = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId') ?? '';
      _nickname = prefs.getString('nickname') ?? '';
    });
  }

  Future<void> _submitPost() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('제목과 내용을 입력하세요.')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('posts').add({
        'title': _titleController.text,
        'content': _contentController.text,
        'authorId': _userId,
        'authorNickname': _nickname,
        'likesCount': 0, // 추가
        'timestamp': FieldValue.serverTimestamp(),
      });

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('게시물 작성에 실패했습니다: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시물 작성'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: '제목'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: '내용'),
              maxLines: 10,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitPost,
              child: Text('게시물 등록'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
