import 'package:args/command_runner.dart';

class PullCommand extends Command {
  // The [name] and [description] properties must be defined by every
  // subclass.
  @override
  final name = "pull";
  @override
  final description = "Record changes to the repository.";

  var headers = {};

  PullCommand() {
    // we can add command specific arguments here.
    // [argParser] is automatically created by the parent class.
    argParser.addFlag('all', abbr: 'a');
  }

  @override
  void run() {
    // [argResults] is set before [run()] is called and contains the flags/options
    // passed to this command.
  }
}
