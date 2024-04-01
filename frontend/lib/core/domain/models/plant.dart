import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'plant.freezed.dart';

part 'plant.g.dart';

@freezed
class Plant with _$Plant {
  const Plant._();
  const factory Plant({
    required String name,
    required String type,
    required String description,
    required bool isLiked,
    required String imageUrl
  }) = _Plant;

  factory Plant.fromJson(Map<String, Object?> json)
  => _$PlantFromJson(json);
}