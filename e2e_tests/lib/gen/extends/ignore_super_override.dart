import 'package:equatable_annotations/equatable_annotations.dart';
import 'package:equatable/equatable.dart';

part 'ignore_super_override.g.dart';

@generateProps
class IgnoreSuperOverrideParent extends Equatable {
  const IgnoreSuperOverrideParent(this.path);

  final String path;

  @override
  List<Object?> get props => _$props;
}

@generateProps
class IgnoreSuperOverrideChild extends IgnoreSuperOverrideParent {
  const IgnoreSuperOverrideChild(this.paths) : super('');

  final List<String> paths;

  @override
  @ignore
  String get path => paths.isNotEmpty ? paths.first : '';

  @override
  List<Object?> get props => _$props;
}
