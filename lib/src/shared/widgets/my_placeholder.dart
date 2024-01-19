import 'package:flutter/material.dart';

class MyPlaceholder extends Container {
  MyPlaceholder({
    super.key,
    super.width,
    super.height,
  });

  @override
  Decoration? get decoration => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      );
}
