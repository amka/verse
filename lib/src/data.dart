import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart';

const String gitDir = '.verse';

class DataFolder {
  /// The directory object representing the data folder.
  late Directory _dir;

  /// The path to the data folder.
  String get path => _dir.path;

  /// Creates a new instance of the `DataFolder` class.
  ///
  /// The `path` parameter is optional and specifies the path to the data folder.
  /// If not provided, the current directory will be used.
  DataFolder({String? path}) {
    _dir = path != null ? Directory(path) : Directory.current;
  }

  /// Initializes the data folder.
  ///
  /// If the directory does not exist, it will be created recursively. This method
  /// is useful for ensuring that the necessary storage location is available for
  /// storing data.
  ///
  /// Returns:
  ///   A `Future<void>` that completes once the creation operation has finished.
  Future<void> init() async {
    if (!await _dir.exists()) {
      await _dir.create(recursive: true);
      await Directory(join(_dir.path, 'objects')).create(recursive: true);
    }
  }

  /// Clears the contents of this data folder.
  ///
  /// If the directory exists, it will be deleted recursively, removing all its
  /// contents. This method is useful for resetting or cleaning up data in a folder.
  ///
  /// Returns:
  ///   A `Future<void>` that completes once the deletion operation has finished.
  Future<void> clear() async {
    if (await _dir.exists()) {
      await _dir.delete(recursive: true);
    }
  }

  /// Checks if this data folder is empty.
  ///
  /// Returns:
  ///   A `Future<bool>` that resolves to `true` if the folder is empty, `false` otherwise.
  Future<bool> empty() async => !await _dir.exists();

  /// Hashes the given data using the SHA-1 algorithm.
  ///
  /// Returns:
  ///   A `List<int>` containing the SHA-1 hash of the given data.
  List<int> hashObject(List<int> data) {
    final digest = sha1.convert(data);
    return digest.bytes;
  }
}
