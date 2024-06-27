import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lip_service_2/tab//search/search_page_2.dart';

class LikedProductsPage extends StatefulWidget {
  const LikedProductsPage({Key? key}) : super(key: key);

  @override
  _LikedProductsPageState createState() => _LikedProductsPageState();
}

class _LikedProductsPageState extends State<LikedProductsPage> {
  String _userId = '';
  List<DocumentSnapshot> likedProducts = [];

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
    _loadLikedProducts();
  }

  Future<void> _loadLikedProducts() async {
    setState(() {
      likedProducts = [];
    });

    QuerySnapshot likeSnapshot = await FirebaseFirestore.instance
        .collection('product_likes')
        .where('userId', isEqualTo: _userId)
        .get();

    List<String> likedProductIds = likeSnapshot.docs.map((doc) => doc['productName'] as String).toList();

    if (likedProductIds.isNotEmpty) {
      QuerySnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where(FieldPath.documentId, whereIn: likedProductIds)
          .get();

      setState(() {
        likedProducts = productSnapshot.docs;
      });
    }
  }

  void _navigateToProductDetail(BuildContext context, DocumentSnapshot product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage2(
          productName: product['productName'],
          productInfo: product['productInfo'],
          productImage: product['productImage'],
          isNetworkImage: Uri.parse(product['productImage']).isAbsolute,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('찜한 목록'),
      ),
      body: likedProducts.isEmpty
          ? Center(child: Text('찜한 제품이 없습니다.'))
          : ListView.builder(
        itemCount: likedProducts.length,
        itemBuilder: (context, index) {
          var product = likedProducts[index];
          return ListTile(
            title: Text(product['productName']),
            subtitle: Text(product['productInfo']),
            leading: product['productImage'] != null
                ? (Uri.parse(product['productImage']).isAbsolute
                ? Image.network(product['productImage'], width: 50, height: 50, fit: BoxFit.cover)
                : Image.asset(product['productImage'], width: 50, height: 50, fit: BoxFit.cover))
                : null,
            onTap: () => _navigateToProductDetail(context, product),
          );
        },
      ),
    );
  }
}
