import 'package:flutter/material.dart';
import 'search_page_2.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lip_service_2/services/api_service.dart';

class SearchPage1 extends StatefulWidget {
  @override
  _SearchPage1State createState() => _SearchPage1State();
}

class _SearchPage1State extends State<SearchPage1> {
  final ApiService apiService = ApiService();
  List<Map<String, String>> recommendations = [];

  @override
  void initState() {
    super.initState();
    _fetchRecommendations();
  }

  Future<void> _fetchRecommendations() async {
    String personalColorInfo = 'Warm undertone, fair skin'; // Example data
    try {
      List<Map<String, String>> products = await apiService.fetchLipstickRecommendations(personalColorInfo);

      List<Map<String, String>> productList = [];
      for (var product in products) {
        String imageUrl = await apiService.fetchImageUrl(product['name']!);
        productList.add({'name': product['name']!, 'description': product['description']!, 'image': imageUrl});
      }

      setState(() {
        recommendations = productList;
      });
    } catch (e) {
      print('Error fetching recommendations: $e');
      setState(() {
        recommendations = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> categories = [
      {
        'name': 'Top 1',
        'description': 'Description for top 1',
        'image': 'assets/images/lip1.png'
      },
      {
        'name': 'Top 2',
        'description': 'Description for top 2',
        'image': 'assets/images/lip2.png'
      },
      {
        'name': 'Top 3',
        'description': 'Description for top 3',
        'image': 'assets/images/lip3.png'
      },
      {
        'name': 'Top 4',
        'description': 'Description for top 4',
        'image': 'assets/images/lip4.png'
      },
      {
        'name': 'Top 5',
        'description': 'Description for top 5',
        'image': 'assets/images/lip5.png'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('제품 쇼핑'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  labelText: '제품을 입력하세요',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text("오늘의 추천"),
            Container(
              padding: EdgeInsets.all(16),
              height: 300,
              child: recommendations.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recommendations.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    width: 160,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchPage2(
                              productName: recommendations[index]['name']!,
                              productInfo: recommendations[index]['description']!,
                              productImage: recommendations[index]['image']!,
                              isNetworkImage: true,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Image.network(
                                recommendations[index]['image']!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                recommendations[index]['name']!,
                                style: TextStyle(fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Text("카테고리별 랭킹"),
            Container(
              padding: EdgeInsets.all(16),
              height: 300,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    width: 160,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchPage2(
                              productName: categories[index]['name']!,
                              productInfo: categories[index]['description']!,
                              productImage: categories[index]['image']!,
                              isNetworkImage: false,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Image.asset(
                                categories[index]['image']!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                categories[index]['name']!,
                                style: TextStyle(fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
