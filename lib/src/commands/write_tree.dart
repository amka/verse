import 'package:args/command_runner.dart';
import 'package:verse/src/data.dart';

class WriteTreeCommand extends Command {
  @override
  String get name => 'write-tree';
  @override
  String get description => 'Write a tree object from the current index.';

  @override
  Future<void> run() async {
    await DataFolder().writeTree('.');
  }
}
