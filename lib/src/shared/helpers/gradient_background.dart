import 'dart:math';

import 'package:flutter/material.dart';

const gradientBackground = LinearGradient(
  colors: [Color(0xFFB67DFF), Color(0xFF7B3EFF)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  stops: [0.0, 1.0],
  transform: GradientRotation(274 * (pi / 180)),
);
