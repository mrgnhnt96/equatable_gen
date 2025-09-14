library;

import 'package:build/build.dart';
import 'package:equatable_gen/gen/settings.dart';
import 'package:equatable_gen/src/generator.dart';
import 'package:source_gen/source_gen.dart';

/// The entry point for the equatable_gen generator.
Builder equatableGenerator(BuilderOptions options) {
  final settings = Settings.fromJson(options.config);

  return SharedPartBuilder([EquatableGenerator(settings)], 'equatable_gen');
}
