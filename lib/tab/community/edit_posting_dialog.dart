import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditPostDialog extends StatefulWidget {
  final String postId;
  final String initialProductName;
  final String initialProductInfo;

  const EditPostDialog({
    Key? key,
    required this.postId,
    required this.initialProductName,
    required this.initialProductInfo,
  }) : super(key: key);

  @override
  _EditPostDialogState createState() => _EditPostDialogState();
}

class _EditPostDialogState extends State<EditPostDialog> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productInfoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _productNameController.text = widget.initialProductName;
    _productInfoController.text = widget.initialProductInfo;
  }

  Future<void> _updatePost() async {
    try {
      await FirebaseFirestore.instance.collection('posts').doc(widget.postId).update({
        'productName': _productNameController.text,
        'productInfo': _productInfoController.text,
      });
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('게시물이 수정되었습니다.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('게시물 수정에 실패했습니다: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('게시물 수정'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _productNameController,
            decoration: InputDecoration(labelText: '제목'),
          ),
          SizedBox(height: 8),
          TextField(
            controller: _productInfoController,
            decoration: InputDecoration(labelText: '내용'),
            maxLines: 10,
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
          onPressed: _updatePost,
          child: Text('수정'),
        ),
      ],
    );
  }
}
