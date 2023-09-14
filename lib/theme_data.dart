import 'package:flutter/material.dart';
import 'color_scheme.dart';

final cardTheme = CardTheme(
  elevation: 0,
  color: lightColorScheme.surface,
  shape: RoundedRectangleBorder(
    side: BorderSide(
      color: lightColorScheme.onSurfaceVariant,
    ),
    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
  ),
);