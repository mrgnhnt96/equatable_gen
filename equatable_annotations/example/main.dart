import 'package:equatable_annotations/equatable_annotations.dart';
import 'package:equatable/equatable.dart';

part 'main.g.dart';

@generateProps
class ExampleClass extends Equatable {
  const ExampleClass({required this.value, this.ignored, this.optional});

  final String? optional;
  final String value;

  @ignore
  final String? ignored;
}
