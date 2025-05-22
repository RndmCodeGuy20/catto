import 'package:flutter/material.dart';
import 'catto_controller.dart';
import 'catto_repository.dart';

/// A widget that displays random cat memes
class CattoWidget extends StatefulWidget {
  final double? width;
  final double? height;
  final BoxFit fit;
  final CattoController? controller;
  final String? apiUrl;

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
  late CattoController _controller;
  final ValueNotifier<String?> _imageUrl = ValueNotifier(null);
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        CattoController(repository: CattoRepository(apiUrl: widget.apiUrl ?? ''));
    _loadRandomCatMeme();
  }

  Future<void> _loadRandomCatMeme() async {
    _isLoading.value = true;
    try {
      final url = await _controller.getRandomCatMeme();
      _imageUrl.value = url;
    } catch (e) {
      debugPrint('Failed to load cat meme: $e');
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

  Widget _buildLoading() {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.grey[200],
      child: const Center(child: CircularProgressIndicator()),
    );
  }

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

  Widget _buildImage(String imageUrl) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border:  Border.all(color: Colors.black, width: 1),
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