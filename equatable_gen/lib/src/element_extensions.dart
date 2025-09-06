import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:equatable_gen/src/checkers/checkers.dart';
import 'package:equatable_gen/src/enums/equatable_type.dart';

/// The extension for [ClassElement2] to check if the annotated
/// elements' inheritances are [Equatable].
extension ClassElementX on ClassElement2 {
  bool get usesEquatable =>
      equatableChecker.isSuperOf(this) ||
      usesEquatableViaMixin ||
      equatableIsSuper;

  bool get equatableIsSuper => equatableChecker.isSuperOf(this);

  bool get superHasProps {
    final ignore = {
      'Object',
      'Equatable',
      'EquatableMixin',
    };

    for (final InterfaceType superType in allSupertypes) {
      final element = superType.element3;
      if (ignore.contains(element.name3)) {
        continue;
      }

      if (element is! ClassElement2) {
        continue;
      }

      if (element.usesEquatable) {
        return true;
      }

      // final propsField = element.getGetter('props');

      // if (propsField != null) {
      //   return true;
      // }

      // // check the source if the getter is not found
      // final source = element.source.contents.data;
      // if (source.contains('List<Object?> get props ')) {
      //   return true;
      // }
    }

    return false;
  }
}

extension ElementX on Element2 {
  bool get usesEquatableViaMixin {
    final Element2 element = this;

    if (element is! ClassElement2) {
      return false;
    }

    final mixins = {...element.mixins};

    var theSuper = element.supertype;
    do {
      if (theSuper == null) {
        break;
      }

      mixins.addAll(theSuper.mixins);
      theSuper = theSuper.superclass;
    } while (theSuper != null);

    if (mixins.isEmpty) {
      return false;
    }

    return mixins.any(
      (InterfaceType type) => equatableMixinChecker.isExactly(type.element3),
    );
  }

  bool get hasDirectEquatableMixin {
    final Element2 element = this;

    if (element is! ClassElement2) {
      return false;
    }

    if (element.mixins.isEmpty) {
      return false;
    }

    return element.mixins.any(
      (InterfaceType type) => equatableMixinChecker.isExactly(type.element3),
    );
  }

  EquatableType get equatableType {
    if (this is! ClassElement2) {
      return EquatableType.none;
    }

    if (equatableChecker.isSuperOf(this)) {
      return EquatableType.class_;
    } else if (hasDirectEquatableMixin) {
      return EquatableType.mixin;
    } else {
      return EquatableType.none;
    }
  }
}
