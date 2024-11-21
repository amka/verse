import 'dart:convert';
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
    path ??= join(Directory.current.path, gitDir);
    _dir = Directory(path);
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

  /// Store data in the Objects folder.
  ///
  /// Returns:
  ///   A `Future<String>` that resolves to the SHA-1 digest of the data.
  Future<String> hashObject(List<int> data,
      {String objectType = 'blob'}) async {
    final objectId = sha1.convert(data).toString();

    // Add type and null terminator
    data = List.from(utf8.encode(objectType))
      ..add(0x00)
      ..addAll(data);

    await File(join(_dir.path, 'objects', objectId)).writeAsBytes(data);
    return objectId;
  }

  /// Retrieve data from the Objects folder.
  ///
  /// Returns:
  ///   A `Future<List<int>>` that resolves to the data.
  /// Throws:
  ///   - `FileSystemException` if the file does not exist.
  Future<List<int>> getObject(String digest, {String? expected}) async {
    final bytes = await File(join(_dir.path, 'objects', digest)).readAsBytes();
    final typeTerminator = bytes.indexOf(0x00);
    if (typeTerminator == -1) {
      throw FileSystemException('Invalid object type');
    }
    final type = String.fromCharCodes(bytes.sublist(0, typeTerminator));
    if (expected != null && type != expected) {
      throw FileSystemException(
          'Unexpected object type: expected $expected, got $type');
    }
    return bytes.sublist(typeTerminator + 1);
  }

  Future<String> writeTree(String path) async {
    final dir = Directory(path);

    final dirItems = await dir.list(followLinks: false).toList();
    List<Map<String, String>> entries = [];

    for (final entry in dirItems) {
      // print('Entry: ${entry.path}');

      // Skip Verse folder
      if (isIgnored(entry.path)) {
        // print('Skipping ${entry.path}');
        continue;
      }

      final name = basename(entry.path);
      if (entry is File) {
        // Write blob
        final type = 'blob';
        final objectId =
            await hashObject(await entry.readAsBytes(), objectType: type);
        entries.add({'oid': objectId, 'name': name, 'type': type});
      } else if (entry is Directory) {
        final type = 'tree';
        // print('> Enteting directrory ${entry.path}');
        final objectId = await writeTree(entry.path);
        entries.add({'oid': objectId, 'name': name, 'type': type});
      }
    }

    entries.sort((a, b) => a['name']!.compareTo(b['name']!));
    final tree = entries
        .map<String>(
            (entry) => '${entry['type']!} ${entry['oid']!} ${entry['name']!}')
        .join('\n');
    return hashObject(utf8.encode(tree), objectType: 'tree');
  }

  bool isIgnored(String path) =>
      ignored.any((ignoredPath) => path.contains(ignoredPath));

  List<String> get ignored => [
        ".verse",
        ".git",
        '.dart_tool',
      ];
}
