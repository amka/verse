import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:verse/src/data.dart';

class CatObjectCommand extends Command {
  @override
  String get name => 'cat-object';

  @override
  String get description => 'Display the contents of an object.';

  @override
  void run() {
    if (argResults?.arguments == null || argResults!.arguments.isEmpty) {
      print("Usage: $name <object-id>");
      print(argParser.usage);
      return;
    }

    // Get the object ID from the arguments (first argument after 'cat-object'
    final objectId = argResults?.arguments.first;
    if (objectId != null) {
      try {
        DataFolder().catObject(objectId).then((data) {
          print(utf8.decode(data));
        });
      } on FileSystemException catch (e) {
        print("Cannot read object $objectId: ${e.message}");
      }
    }
  }
}
