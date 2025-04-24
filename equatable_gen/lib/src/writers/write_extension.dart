import 'package:change_case/change_case.dart';
import 'package:code_builder/code_builder.dart';
import 'package:equatable_gen/src/models/equatable_element.dart';

Extension writeExtension(EquatableElement element) {
  if (!element.isAutoInclude && !element.hasPropsField) {
    print('\n[EXT] class "${element.name}" does not have props getter\n');
  }

  final sanitizedName =
      element.name.replaceAll(RegExp('^_+'), '').toPascalCase();

  return Extension(
    (b) => b
      ..name = '_\$${sanitizedName}EquatableAnnotations'
      ..on = refer(element.name)
      ..methods.add(
        Method(
          (b) => b
            ..returns = refer('List<Object?>')
            ..type = MethodType.getter
            ..name = '_\$props'
            ..body = literalList([
              ...element.props.map(
                (f) => refer(f.name),
              ),
            ]).code,
        ),
      ),
  );
}
