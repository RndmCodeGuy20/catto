import 'package:flutter/material.dart';
import 'catto_controller.dart';
import 'catto_repository.dart';

/// A widget that displays random cat memes with interactive functionality.
///
/// This widget handles loading, displaying, and refreshing cat memes from an API.
/// Users can tap the widget to load a new random cat meme.
///
/// Example:
/// ```dart
/// // Basic usage
/// const CattoWidget(
///   width: 300,
///   height: 300,
/// )
///
/// // Custom API usage
/// CattoWidget(
///   apiUrl: 'https://custom.cat.api/endpoint',
///   fit: BoxFit.contain,
/// )
/// ```
class CattoWidget extends StatefulWidget {
  /// The width of the widget. If null, the widget will shrink-wrap its content.
  final double? width;

  /// The height of the widget. If null, the widget will shrink-wrap its content.
  final double? height;

  /// How the image should be inscribed into the available space.
  /// Defaults to [BoxFit.cover].
  final BoxFit fit;

  /// Optional custom controller for advanced usage and testing.
  /// If not provided, a default controller will be created.
  final CattoController? controller;

  /// Optional custom API endpoint URL for fetching cat memes.
  /// If not provided, uses the default Cat API endpoint.
  final String? apiUrl;

  /// Creates a [CattoWidget].
  ///
  /// The [fit] parameter defaults to [BoxFit.cover].
  /// Either provide a [controller] or an [apiUrl], but not both.
  const CattoWidget({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.controller,
    this.apiUrl,
  });

  @override
  _CattoWidgetState createState() => _CattoWidgetState();
}

class _CattoWidgetState extends State<CattoWidget> {
  late final CattoController _controller;
  final ValueNotifier<String?> _imageUrl = ValueNotifier(null);
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        CattoController(repository: CattoRepository(apiUrl: widget.apiUrl));
    _loadRandomCatMeme();
  }

  /// Loads a new random cat meme from the API.
  ///
  /// Handles loading states and errors internally, updating the UI accordingly.
  /// Called automatically on init and when the user taps the widget.
  Future<void> _loadRandomCatMeme() async {
    _isLoading.value = true;
    try {
      final url = await _controller.getRandomCatMeme();
      _imageUrl.value = url;
    } catch (e) {
      debugPrint('Failed to load cat meme: $e');
      _imageUrl.value = null;
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: _imageUrl,
      builder: (context, imageUrl, _) {
        return ValueListenableBuilder<bool>(
          valueListenable: _isLoading,
          builder: (context, isLoading, _) {
            if (isLoading) {
              return _buildLoading();
            }

            if (imageUrl == null) {
              return _buildError();
            }

            return GestureDetector(
              onTap: _loadRandomCatMeme,
              child: _buildImage(imageUrl),
            );
          },
        );
      },
    );
  }

  /// Builds the loading state widget.
  Widget _buildLoading() {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.grey[200],
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  /// Builds the error state widget with retry functionality.
  Widget _buildError() {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red),
          const SizedBox(height: 8),
          const Text('Failed to load cat meme'),
          TextButton(
            onPressed: _loadRandomCatMeme,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  /// Builds the image display widget with border and padding.
  Widget _buildImage(String imageUrl) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Image.network(
        imageUrl,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildLoading();
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildError();
        },
      ),
    );
  }

  @override
  void dispose() {
    _imageUrl.dispose();
    _isLoading.dispose();
    super.dispose();
  }
}