// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$audioServiceHash() => r'6fa7fac1152464f301a9478f3f3a1f4747ab28f4';

/// Audio service for managing all game sounds
///
/// Copied from [AudioService].
@ProviderFor(AudioService)
final audioServiceProvider = AsyncNotifierProvider<AudioService, bool>.internal(
  AudioService.new,
  name: r'audioServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$audioServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AudioService = AsyncNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
