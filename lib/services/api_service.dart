import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final String openAiApiKey = dotenv.env['OPENAI_API_KEY']!;
  final String googleApiKey = dotenv.env['GOOGLE_CUSTOM_SEARCH_API_KEY']!;
  final String searchEngineId = dotenv.env['SEARCH_ENGINE_ID']!;

  Future<List<Map<String, String>>> fetchLipstickRecommendations(String personalColorInfo) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $openAiApiKey',
      },
      body: json.encode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {
            'role': 'system',
            'content': 'You are a helpful assistant.'
          },
          {
            'role': 'user',
            'content': '$personalColorInfo 에 맞는 립스틱를 5개 추천해줘. 답변은 해당 양식에 맞춰줘 양식: 제품명 - 제품설명'
          }
        ],
        'max_tokens': 100,
      }),
    );

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(utf8.decode(response.bodyBytes));
      final recommendations = (decodedResponse['choices'][0]['message']['content'] as String).trim().split('\n');
      return recommendations.map((item) {
        final parts = item.split(' - ');
        return {
          'name': parts[0].trim(),
          'description': parts.length > 1 ? parts[1].trim() : ''
        };
      }).toList();
    } else {
      throw Exception('Failed to fetch recommendations');
    }
  }

  Future<String> fetchImageUrl(String productName) async {
    final response = await http.get(
      Uri.parse('https://www.googleapis.com/customsearch/v1?q=$productName&searchType=image&key=$googleApiKey&cx=$searchEngineId'),
    );

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(utf8.decode(response.bodyBytes));
      final items = decodedResponse['items'] as List<dynamic>;
      if (items.isNotEmpty) {
        final firstItem = items[0] as Map<String, dynamic>;
        return firstItem['link'] as String;
      } else {
        throw Exception('No image found');
      }
    } else {
      throw Exception('Failed to fetch image URL');
    }
  }
}
