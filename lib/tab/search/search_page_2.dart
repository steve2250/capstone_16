import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage2 extends StatefulWidget {
  final String productName;
  final String productInfo;
  final String productImage;
  final bool isNetworkImage;

  const SearchPage2({
    Key? key,
    required this.productName,
    required this.productInfo,
    required this.productImage,
    required this.isNetworkImage,
  }) : super(key: key);

  @override
  _SearchPage2State createState() => _SearchPage2State();
}

class _SearchPage2State extends State<SearchPage2> {
  int _productLikesCount = 0;
  bool _isProductLiked = false;
  String _userId = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadProductLikesCount();
    _checkIfProductLiked();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId') ?? '';
    });
  }

  Future<void> _loadProductLikesCount() async {
    DocumentSnapshot productSnapshot = await FirebaseFirestore.instance.collection('products').doc(widget.productName).get();
    if (productSnapshot.exists) {
      setState(() {
        _productLikesCount = productSnapshot.get('productLikesCount') ?? 0;
      });
    }
  }

  Future<void> _checkIfProductLiked() async {
    DocumentSnapshot likeSnapshot = await FirebaseFirestore.instance.collection('product_likes').doc('$_userId${widget.productName}').get();
    if (likeSnapshot.exists) {
      setState(() {
        _isProductLiked = true;
      });
    }
  }

  Future<void> _toggleProductLike() async {
    final productRef = FirebaseFirestore.instance.collection('products').doc(widget.productName);
    final likeRef = FirebaseFirestore.instance.collection('product_likes').doc('$_userId${widget.productName}');

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot productSnapshot = await transaction.get(productRef);

        if (!productSnapshot.exists) {
          transaction.set(productRef, {
            'productName': widget.productName,
            'productInfo': widget.productInfo,
            'productImage': widget.productImage,
            'productLikesCount': _isProductLiked ? 0 : 1,
          });
        } else {
          final data = productSnapshot.data() as Map<String, dynamic>;
          int currentLikesCount = data['productLikesCount'] ?? 0;
          int newLikesCount = currentLikesCount + (_isProductLiked ? -1 : 1);
          transaction.update(productRef, {'productLikesCount': newLikesCount});
        }
      });

      if (_isProductLiked) {
        await likeRef.delete();
      } else {
        await likeRef.set({
          'userId': _userId,
          'productName': widget.productName,
        });
      }

      setState(() {
        _isProductLiked = !_isProductLiked;
        _productLikesCount += _isProductLiked ? 1 : -1;
      });
    } catch (e) {
      print('Error updating like status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productName),
        actions: [
          IconButton(
            icon: Icon(_isProductLiked ? Icons.favorite : Icons.favorite_border),
            onPressed: _toggleProductLike,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: 400.0,
              width: double.infinity,
              child: widget.isNetworkImage
                  ? Image.network(widget.productImage, fit: BoxFit.cover)
                  : Image.asset(widget.productImage, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.productName,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  widget.productInfo,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 16),
                Text('$_productLikesCount likes'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
