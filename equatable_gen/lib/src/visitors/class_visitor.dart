import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/dart/element/visitor2.dart';
import 'package:equatable_gen/gen/settings.dart';
import 'package:equatable_gen/src/checkers/checkers.dart';
import 'package:equatable_gen/src/element_extensions.dart';
import 'package:equatable_gen/src/models/equatable_element.dart';

class ClassVisitor extends RecursiveElementVisitor2<void> {
  ClassVisitor(this.settings);

  final Settings settings;
  final List<EquatableElement> nodes = [];

  @override
  void visitClassElement(ClassElement2 element) {
    if (!element.usesEquatable) {
      return;
    }

    if (!settings.autoInclude) {
      bool canInclude = true;

      for (final exclude in settings.include) {
        if (element.name3 case final String name
            when RegExp(exclude).hasMatch(name)) {
          canInclude = true;
          break;
        }
      }

      if (!canInclude && includeChecker.hasAnnotationOfExact(element)) {
        canInclude = true;
      }

      if (!canInclude) {
        return;
      }
    } else {
      for (final exclude in settings.exclude) {
        if (element.name3 case final String name
            when RegExp(exclude).hasMatch(name)) {
          return;
        }
      }
    }

    final annotation = generatePropsChecker.firstAnnotationOfExact(element);

    final props = <FieldElement2>[];

    ClassElement2? clazz = element;
    var isSuper = false;

    do {
      if (clazz == null) {
        break;
      }

      props.addAll(clazz.fields2
          .where((e) => _includeField(e, settings, isSuper: isSuper)));
      clazz = clazz.supertype?.element3 as ClassElement2?;
      isSuper = true;
    } while (clazz != null);

    final equatableElement = EquatableElement(
      element: element,
      hasAnnotation: annotation != null,
      props: props,
      hasPropsField: element.getField2('props') != null,
      isAutoInclude: settings.autoInclude,
    );

    if (equatableElement.shouldCreateExtension) {
      nodes.add(equatableElement);
    }
  }
}

bool _includeField(
  FieldElement2 element,
  Settings settings, {
  bool isSuper = false,
}) {
  if (element.isPrivate && isSuper) {
    return false;
  }

  if (element.isStatic) {
    return false;
  }

  if (element.name3 == 'props') {
    return false;
  }

  if (ignoreChecker.hasAnnotationOfExact(element)) {
    return false;
  }

  if (element.getter2 == null) {
    return false;
  }

  if (includeChecker.hasAnnotationOfExact(element)) {
    return true;
  }

  switch (element.getter2) {
    case final GetterElement getter?
        when ignoreChecker.hasAnnotationOfExact(getter):
      return false;
    case final GetterElement getter?
        when includeChecker.hasAnnotationOfExact(getter):
      return true;
  }

  if (element.isSynthetic) {
    if (settings.includeGetters) {
      return true;
    }

    return false;
  }

  return true;
}
