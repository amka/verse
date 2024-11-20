import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:verse/src/data.dart';
import 'package:verse/src/extensions/list.dart';

class HashObjectCommand extends Command {
  @override
  String get name => 'hash-object';

  @override
  String get description => 'Compute object ID for a file';

  HashObjectCommand() {
    argParser.addOption('file', help: 'File to hash', mandatory: true);
  }

  /// Compute object ID for a file
  ///
  /// This command reads the contents of a file and computes its SHA-1 hash.
  @override
  void run() async {
    if (argResults?.option('file') != null) {
      // Perform the hashing operation here
      final bytes = await File(argResults!.option('file')!).readAsBytes();
      print(DataFolder().hashObject(bytes).toHexString());
    } else {
      print(argParser.usage);
    }
  }
}
