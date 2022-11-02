[![Pub Package](https://img.shields.io/pub/v/autoequal.svg)](https://pub.dev/packages/autoequal)

Provides [Dart Build System](https://pub.dev/packages/build) builder for generating `List<Object?> _$props` private extensions for classes annotated with [autoequal](https://pub.dev/packages/autoequal).

## Usage

#### In your `pubspec.yaml` file:
- Add to `dependencies` section `autoequal: ^0.5.1`
- Add to `dev_dependencies` section `autoequal_gen: ^0.5.1`
- Add to `dev_dependencies` section `build_runner: ^2.2.0`
- Set `environment` to at least Dart 2.17.0 version like so: `">=2.17.0 <3.0.0"`

Your `pubspec.yaml` should look like so:

```yaml
name: project_name
description: project description
version: 1.0.0

environment:
  sdk: ">=2.17.0 <3.0.0"

dependencies:
  #...
  autoequal: ^0.5.1
  
dev_dependencies:
  #...
  build_runner: ^2.2.0
  autoequal_gen: ^0.5.1
```

#### Annotate your class with `@autoequal` annotation:

```dart
import 'package:autoequal/autoequal.dart';
import 'package:equatable/equatable.dart';

part 'some_class.g.dart';

@autoequal
class SomeClass extends Equatable {
  SomeClass({this.id, this.random});

  final String id;

  @override
  List<Object?> get props => _$props; //_$props will be generated
}
```

Make sure that you set the part file as in the example above `part 'your_file_name.g.dart';`.

#### Launch code generation:

```
flutter pub run build_runner build
```

#### The extension will be generated:

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'some_class.dart';

// **************************************************************************
// AutoequalGenerator
// **************************************************************************

extension _$SomeClassAutoequal on SomeClass {
  List<Object> get _$props => [id];
}

```

---

# Additional features

## Build.yaml options

By default, the builder will ignore all getter methods in `props`, but you can change this behavior by adding the following to your `build.yaml` file:

```yaml
targets:
  $default:
    builders:

      autoequal_gen:
        enabled: true
        options:
          include_getters: true # default is false
```

---

## Autoequal mixin

The `@autoequal` is smart enough to handle the `EquatableMixin` mixin automatically.

Instead of extending `Equatable`, you can add it as a mixin, along with the generated autoequal mixin

```dart
@autoequal
class SomeClass with EquatableMixin, _$SomeClassAutoequalMixin {
  final String id;

  SomeClass({this.id});
}
```

If you'd like to not write the `List<Object?> get props` getter, you can use the `@autoequalMixin` annotation while extending `Equatable`:

```dart
@autoequalMixin
class SomeClass extends Equatable with _$SomeClassAutoequalMixin {
  final String id;

  SomeClass({this.id});
}
```

The two approaches will generate the same code.

```dart
mixin _$SomeClassAutoequalMixin on Equatable {
  @override
  List<Object?> get props => _$SomeClassAutoequal(this)._$props;
}
```

---


## Inheritance

If your class extends another class that uses Equatable, you can use the `@autoequal` annotation to generate the props without having to extend `Equatable` or use the mixin `EquatableMixin`.

```dart
@autoequal
class BaseClass extends Equatable {
  const BaseClass({this.id});

  final String id;

  @override
  List<Object?> get props => _$props;
}

@autoequal
class SubClass extends BaseClass {
  const SubClass({required this.name, required super.id});

  final String name;


  @override
  List<Object?> get props => [
    ...super.props, // make sure to include the super props!
    ..._$props,
  ];
}

// --- OR ---

@autoequalMixin
class SubClass extends BaseClass with _$SubClassAutoequalMixin {
  const SubClass({required this.name, required super.id});

  final String name;
}

// generated code
extension _$SubClassAutoequal on SubClass {
  List<Object?> get _$props => [name];
}

mixin _$SubClassAutoequalMixin on Equatable {
  @override
  List<Object?> get props => [
    ...super.props,
    ..._$SubClassAutoequal(this as SubClass)._$props,
  ];
}
```

---

## Field/Getter annotations

### Ignore

You can include fields or getter methods in `props` by annotating them with `@ignoreAutoequal`.

```dart
@ignoreAutoequal
final int random;
```

### Include

You can include fields or getter methods in `props` by annotating them with `@includeAutoequal`.

```dart
@includeAutoequal
String get id => _id;
```
