import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Stores violation snapshots on the device.
///
/// Images are only ever written for violations; ordinary counted vehicles are
/// numbers and metadata, never pictures.
class MediaStore {
  MediaStore(this.rootDirectory);

  final Directory rootDirectory;

  static const String imagesFolder = 'violations';

  /// Opens the default location inside the app documents directory.
  static Future<MediaStore> openDefault() async {
    final docs = await getApplicationDocumentsDirectory();
    final store = MediaStore(docs);
    await store.ensureDirectories();
    return store;
  }

  Directory get imagesDirectory =>
      Directory(p.join(rootDirectory.path, imagesFolder));

  Future<void> ensureDirectories() async {
    if (!await imagesDirectory.exists()) {
      await imagesDirectory.create(recursive: true);
    }
  }

  /// Writes a JPEG and returns its absolute path.
  Future<String> saveJpeg(Uint8List bytes, {required String name}) async {
    await ensureDirectories();
    final file = File(p.join(imagesDirectory.path, '$name.jpg'));
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  Future<void> deleteImage(String? path) async {
    if (path == null) return;
    final file = File(path);
    if (await file.exists()) {
      try {
        await file.delete();
      } on FileSystemException {
        // Already gone or locked; nothing to do.
      }
    }
  }

  /// Total size of the violation images, shown in settings.
  Future<int> imagesSizeBytes() async {
    final dir = imagesDirectory;
    if (!await dir.exists()) return 0;
    var total = 0;
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File) {
        total += await entity.length();
      }
    }
    return total;
  }

  /// Removes images that are no longer referenced by the database.
  Future<int> deleteOrphans(Set<String> referencedPaths) async {
    final dir = imagesDirectory;
    if (!await dir.exists()) return 0;
    var deleted = 0;
    await for (final entity in dir.list()) {
      if (entity is File && !referencedPaths.contains(entity.path)) {
        await entity.delete();
        deleted += 1;
      }
    }
    return deleted;
  }
}
