// ignore_for_file: deprecated_member_use

library;

import 'dart:async' show FutureOr;

import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:equatable_gen/gen/settings.dart';
import 'package:equatable_gen/src/visitors/class_visitor.dart';
import 'package:equatable_gen/src/writers/write_file.dart';
import 'package:source_gen/source_gen.dart';

/// For class marked with @generateProps annotation will be generated properties list List<Object>
/// to use it as value for List<Object> props of Equatable object.
/// If mixin=true so a mixin with overrides 'List<Object> get props' will be additionally generated.
final class EquatableGenerator extends Generator {
  EquatableGenerator(this.settings);

  final Settings settings;

  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) {
    final visitor = ClassVisitor(settings);

    library.element.accept2(visitor);

    final emitter = DartEmitter(useNullSafetySyntax: true);

    final generated = writeFile(visitor.nodes);

    final output = generated.map((e) => e.accept(emitter)).join('\n');

    return DartFormatter(
      languageVersion: DartFormatter.latestLanguageVersion,
    ).format(output);
  }
}
