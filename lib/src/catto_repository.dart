import 'dart:convert';
import 'package:http/http.dart' as http;

class CattoRepository {
  static const String defaultApiUrl = 'https://api.thecatapi.com/v1/images/search?mime_types=jpg,png&category_ids=1';

  final String? apiUrl;

  CattoRepository({this.apiUrl = defaultApiUrl});

  /// Fetches a random cat meme from the API
  Future<String> fetchRandomCatMeme() async {
    final response = await http.get(Uri.parse(defaultApiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is List && data.isNotEmpty) {
        return data[0]['url'] as String;
      }
    }

    throw Exception('Failed to load cat meme');
  }
}