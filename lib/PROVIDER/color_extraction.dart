import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class ArtworkColorProvider extends ChangeNotifier {
  PaletteGenerator? _paletteGenerator;
  PaletteGenerator? get paletteGenerator => _paletteGenerator;

  Color  _dominantColor = Colors.black;
  Color? get dominantColor => _dominantColor;

  Future<void> extractArtworkColors(Uint8List? artworkData, bool isDarkMode) async {
    if (artworkData == null) {
      _dominantColor = isDarkMode ? Colors.black : Colors.grey.withOpacity(0.5);
      notifyListeners();
      return;
    }

    _paletteGenerator = await PaletteGenerator.fromImageProvider(
      MemoryImage(artworkData),
      size: const Size(250, 250),
      maximumColorCount: 20,
    );

    if (_paletteGenerator != null) {
      Color? dominantColor = _paletteGenerator!.dominantColor?.color;
      if (dominantColor != null) {
        // Calculate luminance
        double luminance = dominantColor.computeLuminance();

        // Adjust opacity based on luminance
        double opacity = luminance > 0.5 ? 0.2 : 0.8;

        // Apply opacity to the color
        _dominantColor = dominantColor.withOpacity(opacity);
      } else {
        _dominantColor = isDarkMode ? Colors.black : Colors.grey.withOpacity(0.5);
      }
    } else {
      _dominantColor = isDarkMode ? Colors.black : Colors.grey.withOpacity(0.5);
    }

    notifyListeners();
  }
}