import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'community_page_2.dart';
import 'add_post_screen.dart';

class CommunityPage1 extends StatefulWidget {
  const CommunityPage1({Key? key}) : super(key: key);

  @override
  _CommunityPage1State createState() => _CommunityPage1State();
}

class _CommunityPage1State extends State<CommunityPage1> {
  List<DocumentSnapshot> posts = [];
  List<DocumentSnapshot> displayedPosts = [];
  bool isLoading = false;
  int documentLimit = 6;
  int currentPage = 1;
  int totalPosts = 0;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    getPosts();
  }

  Future<void> getPosts() async {
    setState(() {
      isLoading = true;
    });

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .get();

    posts = querySnapshot.docs;
    totalPosts = posts.length;
    applySearch();

    setState(() {
      isLoading = false;
    });
  }

  void applySearch() {
    List<DocumentSnapshot> filteredPosts;

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

    totalPosts = filteredPosts.length;
    displayedPosts = filteredPosts.take(documentLimit).toList();
  }

  void getPostsForPage(int page) {
    setState(() {
      currentPage = page;
      final startIndex = (page - 1) * documentLimit;
      final endIndex = startIndex + documentLimit;
      displayedPosts = posts.skip(startIndex).take(documentLimit).toList();
    });
  }

  void onSearch(String query) {
    setState(() {
      searchQuery = query;
      currentPage = 1;
      applySearch();
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalPages = (totalPosts / documentLimit).ceil();

    return Scaffold(
      appBar: AppBar(
        title: Text('Community'),
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
              itemCount: displayedPosts.length,
              itemBuilder: (context, index) {
                final post = displayedPosts[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 10,
                    child: ListTile(
                      title: Text(post['title']),
                      subtitle: Text(post['content']),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommunityPage2(
                              postId: post.id,
                              productName: post['title'],
                              productInfo: post['content'],
                            ),
                          ),
                        );
                      },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPostScreen()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
