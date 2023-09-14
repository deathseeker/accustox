import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

const mikadoyellow = Color(0xFFFFC40C);
const redalert = Color(0xFFD0342C);


CustomColors lightCustomColors = const CustomColors(
  sourceMikadoyellow: Color(0xFFFFC40C),
  mikadoyellow: Color(0xFF775A00),
  onMikadoyellow: Color(0xFFFFFFFF),
  mikadoyellowContainer: Color(0xFFFFDF9A),
  onMikadoyellowContainer: Color(0xFF251A00),
  sourceRedalert: Color(0xFFD0342C),
  redalert: Color(0xFFB7211D),
  onRedalert: Color(0xFFFFFFFF),
  redalertContainer: Color(0xFFFFDAD5),
  onRedalertContainer: Color(0xFF410001),
);

CustomColors darkCustomColors = const CustomColors(
  sourceMikadoyellow: Color(0xFFFFC40C),
  mikadoyellow: Color(0xFFF8BE00),
  onMikadoyellow: Color(0xFF3F2E00),
  mikadoyellowContainer: Color(0xFF5A4300),
  onMikadoyellowContainer: Color(0xFFFFDF9A),
  sourceRedalert: Color(0xFFD0342C),
  redalert: Color(0xFFFFB4AA),
  onRedalert: Color(0xFF690004),
  redalertContainer: Color(0xFF930008),
  onRedalertContainer: Color(0xFFFFDAD5),
);



/// Defines a set of custom colors, each comprised of 4 complementary tones.
///
/// See also:
///   * <https://m3.material.io/styles/color/the-color-system/custom-colors>
@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.sourceMikadoyellow,
    required this.mikadoyellow,
    required this.onMikadoyellow,
    required this.mikadoyellowContainer,
    required this.onMikadoyellowContainer,
    required this.sourceRedalert,
    required this.redalert,
    required this.onRedalert,
    required this.redalertContainer,
    required this.onRedalertContainer,
  });

  final Color? sourceMikadoyellow;
  final Color? mikadoyellow;
  final Color? onMikadoyellow;
  final Color? mikadoyellowContainer;
  final Color? onMikadoyellowContainer;
  final Color? sourceRedalert;
  final Color? redalert;
  final Color? onRedalert;
  final Color? redalertContainer;
  final Color? onRedalertContainer;

  @override
  CustomColors copyWith({
    Color? sourceMikadoyellow,
    Color? mikadoyellow,
    Color? onMikadoyellow,
    Color? mikadoyellowContainer,
    Color? onMikadoyellowContainer,
    Color? sourceRedalert,
    Color? redalert,
    Color? onRedalert,
    Color? redalertContainer,
    Color? onRedalertContainer,
  }) {
    return CustomColors(
      sourceMikadoyellow: sourceMikadoyellow ?? this.sourceMikadoyellow,
      mikadoyellow: mikadoyellow ?? this.mikadoyellow,
      onMikadoyellow: onMikadoyellow ?? this.onMikadoyellow,
      mikadoyellowContainer: mikadoyellowContainer ?? this.mikadoyellowContainer,
      onMikadoyellowContainer: onMikadoyellowContainer ?? this.onMikadoyellowContainer,
      sourceRedalert: sourceRedalert ?? this.sourceRedalert,
      redalert: redalert ?? this.redalert,
      onRedalert: onRedalert ?? this.onRedalert,
      redalertContainer: redalertContainer ?? this.redalertContainer,
      onRedalertContainer: onRedalertContainer ?? this.onRedalertContainer,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      sourceMikadoyellow: Color.lerp(sourceMikadoyellow, other.sourceMikadoyellow, t),
      mikadoyellow: Color.lerp(mikadoyellow, other.mikadoyellow, t),
      onMikadoyellow: Color.lerp(onMikadoyellow, other.onMikadoyellow, t),
      mikadoyellowContainer: Color.lerp(mikadoyellowContainer, other.mikadoyellowContainer, t),
      onMikadoyellowContainer: Color.lerp(onMikadoyellowContainer, other.onMikadoyellowContainer, t),
      sourceRedalert: Color.lerp(sourceRedalert, other.sourceRedalert, t),
      redalert: Color.lerp(redalert, other.redalert, t),
      onRedalert: Color.lerp(onRedalert, other.onRedalert, t),
      redalertContainer: Color.lerp(redalertContainer, other.redalertContainer, t),
      onRedalertContainer: Color.lerp(onRedalertContainer, other.onRedalertContainer, t),
    );
  }

  /// Returns an instance of [CustomColors] in which the following custom
  /// colors are harmonized with [dynamic]'s [ColorScheme.primary].
  ///   * [CustomColors.sourceMikadoyellow]
  ///   * [CustomColors.mikadoyellow]
  ///   * [CustomColors.onMikadoyellow]
  ///   * [CustomColors.mikadoyellowContainer]
  ///   * [CustomColors.onMikadoyellowContainer]
  ///   * [CustomColors.sourceRedalert]
  ///   * [CustomColors.redalert]
  ///   * [CustomColors.onRedalert]
  ///   * [CustomColors.redalertContainer]
  ///   * [CustomColors.onRedalertContainer]
  ///
  /// See also:
  ///   * <https://m3.material.io/styles/color/the-color-system/custom-colors#harmonization>
  CustomColors harmonized(ColorScheme dynamic) {
    return copyWith(
      sourceMikadoyellow: sourceMikadoyellow!.harmonizeWith(dynamic.primary),
      mikadoyellow: mikadoyellow!.harmonizeWith(dynamic.primary),
      onMikadoyellow: onMikadoyellow!.harmonizeWith(dynamic.primary),
      mikadoyellowContainer: mikadoyellowContainer!.harmonizeWith(dynamic.primary),
      onMikadoyellowContainer: onMikadoyellowContainer!.harmonizeWith(dynamic.primary),
      sourceRedalert: sourceRedalert!.harmonizeWith(dynamic.primary),
      redalert: redalert!.harmonizeWith(dynamic.primary),
      onRedalert: onRedalert!.harmonizeWith(dynamic.primary),
      redalertContainer: redalertContainer!.harmonizeWith(dynamic.primary),
      onRedalertContainer: onRedalertContainer!.harmonizeWith(dynamic.primary),
    );
  }
}