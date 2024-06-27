import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lip_service_2/tab/community/community_page_2.dart';

class LikedPostsPage extends StatefulWidget {
  const LikedPostsPage({Key? key}) : super(key: key);

  @override
  _LikedPostsPageState createState() => _LikedPostsPageState();
}

class _LikedPostsPageState extends State<LikedPostsPage> {
  String _userId = '';
  List<DocumentSnapshot> posts = [];
  List<DocumentSnapshot> filteredPosts = [];
  List<DocumentSnapshot> paginatedPosts = [];
  bool isLoading = false;
  int documentLimit = 6;
  int currentPage = 1;
  int totalFilteredPosts = 0;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId') ?? '';
    });
    getPosts();
  }

  Future<void> getPosts() async {
    setState(() {
      isLoading = true;
    });

    QuerySnapshot likeSnapshot = await FirebaseFirestore.instance
        .collection('likes')
        .where('userId', isEqualTo: _userId)
        .get();

    List<String> likedPostIds = likeSnapshot.docs.map((doc) => doc['postId'] as String).toList();

    if (likedPostIds.isEmpty) {
      setState(() {
        posts = [];
        filteredPosts = [];
        paginatedPosts = [];
        totalFilteredPosts = 0;
        isLoading = false;
      });
      return;
    }

    QuerySnapshot postSnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where(FieldPath.documentId, whereIn: likedPostIds)
        .get();

    posts = postSnapshot.docs;
    filterPosts();

    setState(() {
      isLoading = false;
    });
  }

  void filterPosts() {
    if (searchQuery.isEmpty) {
      filteredPosts = posts;
    } else {
      filteredPosts = posts.where((post) {
        final title = post['title'].toString().toLowerCase();
        final content = post['content'].toString().toLowerCase();
        final query = searchQuery.toLowerCase();
        return title.contains(query) || content.contains(query);
      }).toList();
    }
    totalFilteredPosts = filteredPosts.length;
    getPostsForPage(currentPage);
  }

  void getPostsForPage(int page) {
    setState(() {
      currentPage = page;
      final startIndex = (page - 1) * documentLimit;
      final endIndex = startIndex + documentLimit;
      paginatedPosts = filteredPosts.sublist(
          startIndex, endIndex > filteredPosts.length ? filteredPosts.length : endIndex);
    });
  }

  void onSearch(String query) {
    setState(() {
      searchQuery = query;
      currentPage = 1;
      filterPosts();
    });
  }

  void _navigateToPostDetail(BuildContext context, String postId, String title, String content) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommunityPage2(
          postId: postId,
          productName: title,
          productInfo: content,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalPages = (totalFilteredPosts / documentLimit).ceil();

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('좋아요 누른 게시물'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: onSearch,
                decoration: InputDecoration(
                  labelText: '검색',
                  hintText: '제목 또는 내용 검색',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: paginatedPosts.length,
                itemBuilder: (context, index) {
                  final post = paginatedPosts[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 7,
                      child: ListTile(
                        title: Text(post['title'] ?? 'No Title'),
                        subtitle: Text(post['content'] ?? 'No Content'),
                        onTap: () => _navigateToPostDetail(
                          context,
                          post.id,
                          post['title'] ?? 'No title',
                          post['content'] ?? 'No content',
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (totalPages > 1)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    totalPages,
                        (index) => InkWell(
                      onTap: () => getPostsForPage(index + 1),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          color: currentPage == index + 1 ? Colors.blue : Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
