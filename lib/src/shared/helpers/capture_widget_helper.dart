import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CaptureWidgetHelp {
  CaptureWidgetHelp._();

  static Future<Uint8List?> widgetToBytes(GlobalKey repaintKey) async {
    final ui.Image image = await widgetToImage(repaintKey);
    final Uint8List? bytes = await imageToBytes(image);
    return bytes;
  }

  static Future<ui.Image> widgetToImage(GlobalKey repaintKey) async {
    final RenderRepaintBoundary? boundary =
        repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

    try {
      final ui.Image img = await boundary!.toImage();
      return img;
    } catch (e) {
      await Future.delayed(const Duration(seconds: 1));
      return widgetToImage(repaintKey);
    }
  }

  static Future<Uint8List?> imageToBytes(ui.Image image) async {
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);

    final Uint8List? pngBytes = byteData?.buffer.asUint8List();

    return pngBytes;
  }
}
