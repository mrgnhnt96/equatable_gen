import 'package:equatable_annotations/equatable_annotations.dart';
import 'package:equatable/equatable.dart';

part 'main.g.dart';

@generateProps
class Example1Class extends Equatable {
  Example1Class({required this.value, this.ignored, this.optional});

  final String value;
  final String? optional;

  @ignore
  final String? ignored;

  @override
  List<Object?> get props => _$props;
}

@generateProps
class Example2Class with EquatableMixin {
  const Example2Class({required this.value, this.ignored, this.optional});

  final String value;
  final String? optional;

  @ignore
  final String? ignored;

  @override
  List<Object?> get props => _$props;
}
