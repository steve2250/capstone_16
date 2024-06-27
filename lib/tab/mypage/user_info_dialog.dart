import 'package:flutter/material.dart';
import 'password_change_dialog.dart'; // 추가

class UserInfoDialog extends StatelessWidget {
  final String userId;
  final String name;
  final String personalColor;

  const UserInfoDialog({
    Key? key,
    required this.userId,
    required this.name,
    required this.personalColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('내 정보'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ID: $userId'),
          SizedBox(height: 8),
          Text('이름: $name'),
          SizedBox(height: 8),
          Text('퍼스널 컬러: $personalColor'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => PasswordChangeDialog(userId: userId),
            );
          },
          child: Text(
            '비밀번호 변경',
            style: TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('확인'),
        ),
      ],
    );
  }
}
