import 'package:equatable_annotations/equatable_annotations.dart';
import 'package:equatable/equatable.dart';

part 'ignore.g.dart';

@generateProps
class Ignore with EquatableMixin {
  const Ignore(this.one, {required this.two, this.three});

  @ignore
  final String one;
  final String two;
  final String? three;

  @override
  List<Object?> get props => _$props;
}
