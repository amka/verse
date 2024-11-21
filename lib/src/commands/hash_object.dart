import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:verse/src/data.dart';

class HashObjectCommand extends Command {
  @override
  String get name => 'hash-object';

  @override
  String get description => 'Compute object ID for a file';

  /// Compute object ID for a file
  ///
  /// This command reads the contents of a file and computes its SHA-1 hash.
  @override
  void run() async {
    if (argResults?.arguments == null || argResults!.arguments.isEmpty) {
      print("Usage: $name <object-id>");
      print(argParser.usage);
      return;
    }

    final fileName = argResults?.arguments.first;
    if (fileName != null) {
      // Perform the hashing operation here
      final bytes = await File(fileName).readAsBytes();
      print(
          "Object stored as /objects/${await DataFolder().hashObject(bytes)}");
    } else {
      print(argParser.usage);
    }
  }
}
