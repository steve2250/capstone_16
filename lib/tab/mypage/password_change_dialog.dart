import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'password_change_confirmation_dialog.dart'; // 추가

class PasswordChangeDialog extends StatefulWidget {
  final String userId;

  const PasswordChangeDialog({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  _PasswordChangeDialogState createState() => _PasswordChangeDialogState();
}

class _PasswordChangeDialogState extends State<PasswordChangeDialog> {
  final TextEditingController _passwordController = TextEditingController();

  void _confirmPasswordChange() {
    String newPassword = _passwordController.text.trim();

    if (newPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('비밀번호를 입력하세요.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => PasswordChangeConfirmationDialog(
        userId: widget.userId,
        newPassword: newPassword, // 새 비밀번호를 전달
        onCancel: () {
          Navigator.of(context).pop(); // 비밀번호 변경 다이얼로그 닫기
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('비밀번호 변경'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: '새 비밀번호'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('취소'),
        ),
        TextButton(
          onPressed: _confirmPasswordChange,
          child: Text('변경'),
        ),
      ],
    );
  }
}
