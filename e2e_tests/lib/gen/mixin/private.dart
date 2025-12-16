import 'package:equatable_annotations/equatable_annotations.dart';
import 'package:equatable/equatable.dart';

part 'private.g.dart';

@generateProps
class Private with EquatableMixin {
  const Private(this._one, {required String two, String? three})
    : _two = two, _three = three;

  final String _one;
  final String _two;
  final String? _three;

  @override
  List<Object?> get props => _$props;
}
