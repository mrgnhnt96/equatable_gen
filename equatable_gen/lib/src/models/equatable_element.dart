// ignore_for_file: deprecated_member_use

import 'package:analyzer/dart/element/element2.dart';
import 'package:change_case/change_case.dart';
import 'package:equatable_gen/src/element_extensions.dart';
import 'package:equatable_gen/src/enums/equatable_type.dart';

class EquatableElement {
  EquatableElement({
    required this.element,
    required this.hasAnnotation,
    required this.props,
    required bool hasPropsField,
    required this.isAutoInclude,
  }) : shouldCreateExtension =
           (isAutoInclude || hasAnnotation) && hasPropsField;

  final ClassElement2 element;
  final bool hasAnnotation;
  final List<FieldElement2> props;
  final bool shouldCreateExtension;
  final bool isAutoInclude;

  String get name => element.name3 ?? element.displayName;

  String get sanitizedName => name.replaceAll(RegExp('^_+'), '').toPascalCase();

  EquatableType get type => element.equatableType;

  bool get hasPropsField => element.getField2('props') != null;
}
