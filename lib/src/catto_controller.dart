import 'package:catto/src/catto_repository.dart';

/// A controller class that manages the business logic for fetching cat memes.
///
/// This class acts as an intermediary between the repository (data layer)
/// and the widgets (presentation layer), handling the flow of cat meme data.
///
/// Example:
/// ```dart
/// final controller = CattoController(
///   repository: CattoRepository(),
/// );
/// final catMemeUrl = await controller.getRandomCatMeme();
/// ```
class CattoController {
  /// The repository responsible for fetching cat meme data.
  final CattoRepository repository;

  /// Creates a [CattoController] with the given [repository].
  ///
  /// The [repository] parameter must not be null.
  CattoController({required this.repository});

  /// Fetches a random cat meme URL from the repository.
  ///
  /// Returns:
  /// - A [Future<String>] that completes with the URL of a random cat meme.
  ///
  /// Throws:
  /// - [Exception] if the meme cannot be fetched (propagated from repository).
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   final url = await controller.getRandomCatMeme();
  ///   print('Got cat meme at: $url');
  /// } catch (e) {
  ///   print('Failed to get cat meme: $e');
  /// }
  /// ```
  Future<String> getRandomCatMeme() async {
    return await repository.fetchRandomCatMeme();
  }
}