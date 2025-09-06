import 'package:build_test/build_test.dart';
import 'package:equatable_gen/equatable_gen.dart';
import 'package:equatable_gen/gen/settings.dart';
import 'package:generator_test/generator_test.dart';
import 'package:test/test.dart';

class GeneratorInput {
  const GeneratorInput(
    this.input,
    this.output, {
    this.settings = const Settings.defaults(),
  });

  GeneratorInput.file(
    String file, {
    Settings settings = const Settings.defaults(),
  }) : this([file], [file], settings: settings);

  final List<String> input;
  final List<String> output;
  final Settings settings;
}

void main() {
  final inputs = [
    GeneratorInput.file(
      'auto_include.dart',
      settings: Settings.defaults(autoInclude: true),
    ),
    GeneratorInput.file(
      'annotated.dart',
      settings: Settings.defaults(),
    ),
    GeneratorInput.file(
      'inherited.dart',
      settings: Settings.defaults(),
    ),
    GeneratorInput.file(
      'mixin_inherited.dart',
      settings: Settings.defaults(),
    ),
  ];

  for (final input in inputs) {
    test('${input.input.first} runs successfully', () async {
      final generator = SuccessGenerator.fromBuilder(
        input.input,
        input.output,
        equatableGenerator,
        onLog: print,
        options: input.settings.toJson(),
      );

      final rw = TestReaderWriter(rootPackage: 'a');
      await rw.testing.loadIsolateSources();
      await generator.test(readerWriter: rw, rootPackage: 'a');
    });
  }
}
