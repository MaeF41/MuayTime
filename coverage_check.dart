import 'dart:io';

void main(List<String> args) {
  final minCoverage = double.parse(args[0]);

  String? input = stdin.readLineSync();
  // example of input:   lines......: 20.0% (1541 of 7704 lines)

  RegExp exp = RegExp(r'(100.0)|\d\d.\d');
  RegExpMatch? match = exp.firstMatch(input!);

  if (match == null) {
    stderr.writeln('\x1B[31mCould not find coverage percentage in input: $input');
    exit(1);
  }

  final coverage = double.parse(match[0]!);

  if (coverage < minCoverage) {
    stderr.writeln('\x1B[31mCoverage is $coverage%, which is less than $minCoverage%');
    exit(1);
  }

  stdout.writeln('🎉🎉🎉 100% test coverage.. nice work.. all coverage are belong to us!!!');
}
