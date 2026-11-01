import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:radar/core/camera/preview_geometry.dart';

void main() {
  group('uprightAspectRatio', () {
    test('uses the short side over the long side', () {
      expect(
        uprightAspectRatio(previewSize: const Size(1280, 720)),
        closeTo(720 / 1280, 1e-9),
      );
      expect(
        uprightAspectRatio(previewSize: const Size(720, 1280)),
        closeTo(720 / 1280, 1e-9),
      );
    });

    test('inverts a landscape aspect ratio', () {
      expect(
        uprightAspectRatio(aspectRatio: 16 / 9),
        closeTo(9 / 16, 1e-9),
      );
    });

    test('keeps an already portrait aspect ratio', () {
      expect(
        uprightAspectRatio(aspectRatio: 3 / 4),
        closeTo(0.75, 1e-9),
      );
    });

    test('falls back when nothing is known', () {
      expect(uprightAspectRatio(), kFallbackPortraitAspectRatio);
      expect(
        uprightAspectRatio(aspectRatio: double.nan),
        kFallbackPortraitAspectRatio,
      );
    });

    test('ignores invalid preview dimensions and aspect ratios', () {
      expect(
        uprightAspectRatio(
          previewSize: const Size(0, 720),
          aspectRatio: 16 / 9,
        ),
        closeTo(9 / 16, 1e-9),
      );
      expect(
        uprightAspectRatio(aspectRatio: double.infinity),
        kFallbackPortraitAspectRatio,
      );
      expect(uprightAspectRatio(aspectRatio: -1), kFallbackPortraitAspectRatio);
    });
  });

  test('uprightPreviewAspectRatio falls back without a camera', () {
    expect(
      uprightPreviewAspectRatio(null),
      kFallbackPortraitAspectRatio,
    );
  });
}
