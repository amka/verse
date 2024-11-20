import 'dart:io';

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
  ///
  /// Throws:
  ///   - `Exception` if an error occurs during the creation process.
  Future<void> init() async {
    if (!await _dir.exists()) {
      await _dir.create(recursive: true);
    }
  }

  /// Clears the contents of this data folder.
  ///
  /// If the directory exists, it will be deleted recursively, removing all its
  /// contents. This method is useful for resetting or cleaning up data in a folder.
  ///
  /// Returns:
  ///   A `Future<void>` that completes once the deletion operation has finished.
  ///
  /// Throws:
  ///   - `Exception` if an error occurs during the deletion process.
  Future<void> clear() async {
    if (await _dir.exists()) {
      await _dir.delete(recursive: true);
    }
  }

  /// Checks if this data folder is empty.
  ///
  /// Returns:
  ///   A `Future<bool>` that resolves to `true` if the folder is empty, `false` otherwise.
  ///
  /// Throws:
  ///   - `Exception` if an error occurs during the check process.
  Future<bool> empty() async => !await _dir.exists();
}
