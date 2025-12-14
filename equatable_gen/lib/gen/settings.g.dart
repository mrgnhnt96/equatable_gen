// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) => Settings.defaults(
  includeGetters: json['include_getters'] as bool? ?? false,
  autoInclude: json['auto_include'] as bool? ?? false,
  exclude:
      (json['exclude'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
  include:
      (json['include'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      [],
);

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
  'auto_include': instance.autoInclude,
  'exclude': instance.exclude,
  'include': instance.include,
  'include_getters': instance.includeGetters,
};
