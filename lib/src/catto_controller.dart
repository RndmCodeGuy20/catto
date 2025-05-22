import 'package:catto/src/catto_repository.dart';

class CattoController {
  final CattoRepository repository;

  CattoController({required this.repository});

  /// Gets a random cat meme URL
  Future<String> getRandomCatMeme() async {
    return await repository.fetchRandomCatMeme();
  }
}