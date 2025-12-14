import 'package:equatable_annotations/equatable_annotations.dart';
import 'package:equatable/equatable.dart';

part 'basic.g.dart';

@generateProps
class Basic with EquatableMixin {
  const Basic(this.one, {required this.two, this.three});

  final String one;
  final String two;
  final String? three;

  @override
  List<Object?> get props => _$props;
}
