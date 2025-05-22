// import 'package:flutter_test/flutter_test.dart';
// import 'package:http/http.dart' as http;
// import 'package:http/testing.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:catto/src/catto_repository.dart';
//
// import 'cat_meme_repository_test.mocks.dart';
//
// @GenerateMocks([http.Client])
// void main() {
//   late CattoRepository repository;
//   late MockClient mockClient;
//
//   setUp(() {
//     mockClient = MockClient(
//       m
//     );
//     repository = CatMemeRepository(apiUrl: 'https://test.url');
//   });
//
//   group('fetchRandomCatMeme', () {
//     test('returns a URL when the API call is successful', () async {
//       // Mock the API response
//       when(mockClient.get(Uri.parse('https://test.url')))
//           .thenAnswer((_) async => http.Response(
//           '[{"url": "https://example.com/cat1.jpg"}]', 200));
//
//       // Replace the client in the repository
//       repository.client = mockClient;
//
//       // Call the method
//       final result = await repository.fetchRandomCatMeme();
//
//       // Verify the result
//       expect(result, 'https://example.com/cat1.jpg');
//     });
//
//     test('throws an exception when the API call fails', () async {
//       // Mock a failed API response
//       when(mockClient.get(Uri.parse('https://test.url')))
//           .thenAnswer((_) async => http.Response('Not Found', 404));
//
//       // Replace the client in the repository
//       repository.client = mockClient;
//
//       // Call the method and expect an exception
//       expect(() => repository.fetchRandomCatMeme(), throwsException);
//     });
//
//     test('throws an exception when the response is empty', () async {
//       // Mock an empty response
//       when(mockClient.get(Uri.parse('https://test.url')))
//           .thenAnswer((_) async => http.Response('[]', 200));
//
//       // Replace the client in the repository
//       repository.client = mockClient;
//
//       // Call the method and expect an exception
//       expect(() => repository.fetchRandomCatMeme(), throwsException);
//     });
//
//     test('throws an exception when the response is malformed', () async {
//       // Mock a malformed response
//       when(mockClient.get(Uri.parse('https://test.url')))
//           .thenAnswer((_) async => http.Response('invalid json', 200));
//
//       // Replace the client in the repository
//       repository.client = mockClient;
//
//       // Call the method and expect an exception
//       expect(() => repository.fetchRandomCatMeme(), throwsException);
//     });
//   });
// }