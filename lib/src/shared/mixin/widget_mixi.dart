import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

mixin WidgetMixin {
  Future<Uint8List?> widgetToBytes({
    required GlobalKey repaintKey,
    double pixelRatio = 3,
  }) async {
    final ui.Image image =
        await widgetToImage(repaintKey: repaintKey, pixelRatio: pixelRatio);
    final Uint8List? bytes = await imageToBytes(image);
    return bytes;
  }

  Future<ui.Image> widgetToImage({
    required GlobalKey repaintKey,
    double pixelRatio = 3,
  }) async {
    final RenderRepaintBoundary? boundary =
        repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    try {
      final ui.Image img = await boundary!.toImage(pixelRatio: pixelRatio);
      return img;
    } catch (e) {
      await Future.delayed(const Duration(seconds: 1));
      return widgetToImage(repaintKey: repaintKey, pixelRatio: pixelRatio);
    }
  }

  Future<Uint8List?> imageToBytes(ui.Image image) async {
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List? pngBytes = byteData?.buffer.asUint8List();
    return pngBytes;
  }
}
