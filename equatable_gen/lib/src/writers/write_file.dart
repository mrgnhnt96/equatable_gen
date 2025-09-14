import 'package:code_builder/code_builder.dart';
import 'package:equatable_gen/src/models/equatable_element.dart';
import 'package:equatable_gen/src/writers/write_extension.dart';

List<Spec> writeFile(List<EquatableElement> equatables) {
  final extensions = equatables.map(writeExtension);

  return [...extensions];
}
