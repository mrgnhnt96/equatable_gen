// ignore: implementation_imports
import 'package:equatable/equatable.dart';
import 'package:equatable_annotations/equatable_annotations.dart';
import 'package:source_gen/source_gen.dart' show TypeChecker;

const TypeChecker equatableChecker = TypeChecker.typeNamed(
  Equatable,
  inPackage: 'equatable',
  inSdk: false,
);
const TypeChecker equatableMixinChecker = TypeChecker.typeNamed(
  EquatableMixin,
  inPackage: 'equatable',
  inSdk: false,
);
final TypeChecker ignoreChecker = TypeChecker.typeNamed(
  ignore.runtimeType,
  inPackage: 'equatable_annotations',
  inSdk: false,
);
final TypeChecker includeChecker = TypeChecker.typeNamed(
  include.runtimeType,
  inPackage: 'equatable_annotations',
  inSdk: false,
);
final TypeChecker generatePropsChecker = TypeChecker.typeNamed(
  generateProps.runtimeType,
  inPackage: 'equatable_annotations',
  inSdk: false,
);
