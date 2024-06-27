import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // 날짜 포맷팅을 위한 패키지
import 'edit_posting_dialog.dart'; // 게시물 수정 다이얼로그 추가

class CommunityPage2 extends StatefulWidget {
  final String postId;
  final String productName;
  final String productInfo;

  const CommunityPage2({
    Key? key,
    required this.postId,
    required this.productName,
    required this.productInfo,
  }) : super(key: key);

  @override
  _CommunityPage2State createState() => _CommunityPage2State();
}

class _CommunityPage2State extends State<CommunityPage2> {
  final TextEditingController _commentController = TextEditingController();
  String _userId = '';
  String _nickname = '';
  int _likesCount = 0;
  bool _isLiked = false;
  bool _isUserDataLoaded = false; // 유저 데이터 로드 여부를 나타내는 변수 추가
  bool _isMyPost = false; // 내가 작성한 게시물인지 여부를 나타내는 변수 추가
  String _authorNickname = '';
  Timestamp _timestamp = Timestamp.now();
  String _authorName = '';

  @override
  void initState() {
    super.initState();
    _loadUserData().then((_) {
      // 유저 데이터 로드가 완료된 후 좋아요 상태 및 카운트를 로드
      _loadPostData();
      _loadLikesCount();
      _checkIfLiked();
      setState(() {
        _isUserDataLoaded = true; // 유저 데이터 로드 완료
      });
    });
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId') ?? '';
      _nickname = prefs.getString('nickname') ?? '';
    });
  }

  Future<void> _loadPostData() async {
    DocumentSnapshot postSnapshot = await FirebaseFirestore.instance.collection('posts').doc(widget.postId).get();
    if (postSnapshot.exists) {
      setState(() {
        _isMyPost = postSnapshot.get('authorId') == _userId;
        _authorNickname = postSnapshot.get('authorNickname') ?? 'Unknown';
        _timestamp = postSnapshot.get('timestamp') ?? Timestamp.now();
      });

      // 작성자의 이름을 가져오기 위해 users 컬렉션에서 조회
      String authorId = postSnapshot.get('authorId');
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(authorId).get();
      if (userSnapshot.exists) {
        setState(() {
          _authorName = userSnapshot.get('name') ?? 'Unknown';
        });
      }
    }
  }

  Future<void> _loadLikesCount() async {
    DocumentSnapshot postSnapshot = await FirebaseFirestore.instance.collection('posts').doc(widget.postId).get();
    if (postSnapshot.exists) {
      setState(() {
        // likeCount가 존재하지 않을 경우 기본값 0을 사용
        _likesCount = postSnapshot.get('likesCount') ?? 0;
      });
    }
  }

  Future<void> _checkIfLiked() async {
    QuerySnapshot likeSnapshot = await FirebaseFirestore.instance
        .collection('likes')
        .where('userId', isEqualTo: _userId)
        .where('postId', isEqualTo: widget.postId)
        .get();

    if (likeSnapshot.docs.isNotEmpty) {
      setState(() {
        _isLiked = true;
      });
    }
  }

  Future<void> _submitComment() async {
    if (_commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('댓글을 입력하세요.')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('comments').add({
        'content': _commentController.text,
        'nickname': _nickname,
        'postId': widget.postId,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': _userId,
      });

      _commentController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('댓글 작성에 실패했습니다: $e')),
      );
    }
  }

  Future<String> _getUserName(String userId) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userSnapshot.exists) {
      return userSnapshot.get('name') ?? 'Unknown';
    }
    return 'Unknown';
  }

  Future<Map<String, String>> _getCommentAuthors(List<DocumentSnapshot> comments) async {
    Map<String, String> authors = {};
    for (var comment in comments) {
      String userId = comment['userId'];
      if (!authors.containsKey(userId)) {
        authors[userId] = await _getUserName(userId);
      }
    }
    return authors;
  }

  Future<void> _toggleLike() async {
    try {
      final likeRef = FirebaseFirestore.instance.collection('likes').doc('$_userId${widget.postId}');
      final likeDoc = await likeRef.get();

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentReference postRef = FirebaseFirestore.instance.collection('posts').doc(widget.postId);
        DocumentSnapshot postSnapshot = await transaction.get(postRef);

        if (!postSnapshot.exists) {
          throw Exception("Post does not exist!");
        }

        int newLikesCount = (postSnapshot.get('likesCount') ?? 0);

        if (_isLiked) {
          // 이미 좋아요를 누른 상태이면 좋아요 취소
          transaction.delete(likeRef);
          newLikesCount -= 1;
        } else {
          // 좋아요를 누르지 않은 상태이면 좋아요 추가
          transaction.set(likeRef, {
            'userId': _userId,
            'postId': widget.postId,
          });
          newLikesCount += 1;
        }

        transaction.update(postRef, {'likesCount': newLikesCount});

        setState(() {
          _isLiked = !_isLiked;
          _likesCount = newLikesCount;
        });
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('좋아요 처리에 실패했습니다: $e')),
      );
    }
  }

  void _showEditPostDialog() {
    showDialog(
      context: context,
      builder: (context) => EditPostDialog(
        postId: widget.postId,
        initialProductName: widget.productName,
        initialProductInfo: widget.productInfo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime = DateFormat('yyyy-MM-dd HH:mm').format(_timestamp.toDate());

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productName),
        actions: [
          if (_isMyPost)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: _showEditPostDialog,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('작성자: $_authorName', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('작성시간: $formattedTime', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text(widget.productName, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text(widget.productInfo, style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  icon: Icon(_isLiked ? Icons.favorite : Icons.favorite_border),
                  onPressed: _isUserDataLoaded ? _toggleLike : null, // 유저 데이터가 로드된 경우에만 버튼 활성화
                ),
                SizedBox(width: 8),
                Text('$_likesCount likes'),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('comments')
                    .where('postId', isEqualTo: widget.postId)
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Something went wrong: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No comments found'));
                  }

                  final comments = snapshot.data!.docs;

                  return FutureBuilder<Map<String, String>>(
                    future: _getCommentAuthors(comments),
                    builder: (context, authorSnapshot) {
                      if (authorSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (authorSnapshot.hasError) {
                        return Center(child: Text('Something went wrong: ${authorSnapshot.error}'));
                      }

                      final authors = authorSnapshot.data ?? {};

                      return ListView.builder(
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final comment = comments[index];
                          final timestamp = comment['timestamp'] as Timestamp?;
                          final formattedTime = timestamp != null
                              ? DateFormat('yyyy-MM-dd HH:mm').format(timestamp.toDate())
                              : 'Unknown time';
                          final authorName = authors[comment['userId']] ?? 'Unknown';

                          return ListTile(
                            title: Text(authorName),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(formattedTime),
                                SizedBox(height: 4),
                                Text(comment['content'] ?? ''),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: '댓글 입력',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _submitComment,
              child: Text('댓글 등록'),
            ),
          ],
        ),
      ),
    );
  }
}
