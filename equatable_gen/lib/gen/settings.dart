import 'package:equatable_gen/gen/settings_interface.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, constructor: 'defaults')
class Settings implements SettingsInterface {
  const Settings({
    required this.includeGetters,
    required this.autoInclude,
    required this.exclude,
    required this.include,
  });

  const Settings.defaults({
    this.includeGetters = false,
    this.autoInclude = false,
    this.exclude = const [],
    this.include = const [],
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    final settings = _$SettingsFromJson(json);

    final patternValidationLocations = <String, List<String>>{};

    for (var e in settings.exclude) {
      patternValidationLocations.putIfAbsent(e, () => []).add('exclude');
    }
    for (var e in settings.include) {
      patternValidationLocations.putIfAbsent(e, () => []).add('include');
    }

    // make sure that the priorities patternValidationLocations are valid regex
    for (final MapEntry(key: pattern, value: locations)
        in patternValidationLocations.entries) {
      try {
        RegExp(pattern);
      } catch (error) {
        throw ArgumentError.value(
          pattern,
          'Found in ${locations.join(',')}',
          error,
        );
      }
    }
    return settings;
  }

  Map<String, dynamic> toJson() => _$SettingsToJson(this);

  @override
  @JsonKey(defaultValue: false)
  final bool autoInclude;

  @override
  @JsonKey(defaultValue: [])
  final List<String> exclude;

  @override
  @JsonKey(defaultValue: [])
  final List<String> include;

  @override
  @JsonKey(defaultValue: false)
  final bool includeGetters;
}
