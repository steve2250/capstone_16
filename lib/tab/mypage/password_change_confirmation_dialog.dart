import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PasswordChangeConfirmationDialog extends StatelessWidget {
  final String userId;
  final String newPassword;
  final Function onCancel;

  const PasswordChangeConfirmationDialog({
    Key? key,
    required this.userId,
    required this.newPassword,
    required this.onCancel,
  }) : super(key: key);

  Future<void> _changePassword(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'password': newPassword});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('비밀번호가 변경되었습니다.')),
      );
      Navigator.of(context).pop(); // 비밀번호 변경 확인 다이얼로그 닫기
      Navigator.of(context).pop(); // 비밀번호 변경 다이얼로그 닫기
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('비밀번호 변경에 실패했습니다: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('비밀번호 변경 확인'),
      content: Text('비밀번호를 변경하시겠습니까?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // 확인 메시지 다이얼로그 닫기
            onCancel(); // 비밀번호 변경 다이얼로그 닫기
          },
          child: Text('아니오'),
        ),
        TextButton(
          onPressed: () {
            _changePassword(context);
          },
          child: Text('예'),
        ),
      ],
    );
  }
}
