import 'package:args/command_runner.dart';

import 'package:verse/verse.dart';

const String version = '0.0.1';

void printUsage(CommandRunner runner) {
  print('Usage: verse <flags> [arguments]');
  print(runner.usage);
}

void main(List<String> arguments) {
  final runner = CommandRunner(
      'verse', 'A dart implementation of distributed version control.')
    ..addCommand(InitCommand())
    ..addCommand(PullCommand())
    ..addCommand(HashObjectCommand());

  try {
    runner.run(arguments);
    // bool verbose = false;

    // // Act on the arguments provided.
    // print('Positional arguments: ${results.rest}');
    // if (verbose) {
    //   print('[VERBOSE] All arguments: ${results.arguments}');
    // }
  } catch (e) {
    // Print usage information if an invalid argument was provided.
    // print(e.toString);
    // print('');
    printUsage(runner);
  }
}
