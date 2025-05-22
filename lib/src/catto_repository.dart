import 'dart:convert';
import 'package:http/http.dart' as http;

/// A repository class that handles data operations for cat memes.
///
/// This class is responsible for fetching random cat memes from a remote API.
/// It serves as the data access layer in the application architecture.
///
/// Example:
/// ```dart
/// final repository = CattoRepository();
/// final catMemeUrl = await repository.fetchRandomCatMeme();
/// ```
class CattoRepository {
  /// The default API endpoint for fetching cat memes.
  ///
  /// Uses TheCatAPI to fetch random cat images in JPG or PNG format
  /// from the "funny" category (category ID 1).
  static const String defaultApiUrl =
      'https://api.thecatapi.com/v1/images/search?mime_types=jpg,png&category_ids=1';

  /// The API endpoint URL to use for fetching cat memes.
  ///
  /// If not provided, defaults to [defaultApiUrl].
  /// Can be customized to use a different API endpoint.
  final String? apiUrl;

  /// Creates a [CattoRepository] instance.
  ///
  /// [apiUrl]: Optional custom API endpoint URL.
  ///           If null, uses [defaultApiUrl].
  CattoRepository({this.apiUrl = defaultApiUrl});

  /// Fetches a random cat meme URL from the API.
  ///
  /// Makes an HTTP GET request to the configured API endpoint and
  /// parses the response to extract the image URL.
  ///
  /// Returns:
  /// - A [Future<String>] that completes with the URL of a random cat meme.
  ///
  /// Throws:
  /// - [Exception] with a descriptive message if:
  ///   - The HTTP request fails (non-200 status code)
  ///   - The response body cannot be parsed
  ///   - The response doesn't contain a valid image URL
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   final memeUrl = await repository.fetchRandomCatMeme();
  ///   print('Fetched cat meme at: $memeUrl');
  /// } catch (e) {
  ///   print('Error fetching cat meme: $e');
  /// }
  /// ```
  Future<String> fetchRandomCatMeme() async {
    final response = await http.get(Uri.parse(apiUrl ?? defaultApiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is List && data.isNotEmpty) {
        return data[0]['url'] as String;
      }
    }

    throw Exception('Failed to load cat meme: '
        '${response.statusCode} - ${response.body}');
  }
}