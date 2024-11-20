import 'package:args/command_runner.dart';
import 'package:path/path.dart' show current, join;
import 'data.dart';

class InitCommand extends Command {
  @override
  String get description =>
      'Create an empty Git repository or reinitialize an existing one.';

  @override
  String get name => 'init';

  late DataFolder dataFolder;

  InitCommand() {
    final dataPath = join(current, gitDir);
    dataFolder = DataFolder(path: dataPath);
  }

  /// Create an empty Git repository or reinitialize an existing one.
  ///
  /// This command will create a new directory called `.verse` in the current
  /// working directory if it does not already exist. If the directory already exists,
  /// it will be cleared and reinitialized.
  @override
  Future<void> run() async {
    if (await dataFolder.empty()) {
      dataFolder.init();
      print('Initialized empty verse repository in ${dataFolder.path}');
    } else {
      dataFolder.clear();
      dataFolder.init();
      print('Reinitialized empty verse repository in ${dataFolder.path}');
    }
  }
}
