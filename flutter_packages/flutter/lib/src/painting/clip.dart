// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'dart:ui' show Canvas, Clip, Path, Paint, Rect, RRect, VoidCallback;

/// Clip utilities used by [PaintingContext].
abstract class ClipContext {
  /// The canvas on which to paint.
  Canvas get canvas;

  void _clipAndPaint(void Function(bool doAntiAlias) canvasClipCall, Clip clipBehavior, Rect bounds, VoidCallback painter) {
    assert(canvasClipCall != null);
    canvas.save();
    switch (clipBehavior) {
      case Clip.none:
        break;
      case Clip.hardEdge:
        canvasClipCall(false);
        break;
      case Clip.antiAlias:
        canvasClipCall(true);
        break;
      case Clip.antiAliasWithSaveLayer:
        canvasClipCall(true);
        canvas.saveLayer(bounds, Paint());
        break;
    }
    painter();
    if (clipBehavior == Clip.antiAliasWithSaveLayer) {
      canvas.restore();
    }
    canvas.restore();
  }

  /// Clip [canvas] with [Path] according to [Clip] and then paint. [canvas] is
  /// restored to the pre-clip status afterwards.
  ///
  /// `bounds` is the saveLayer bounds used for [Clip.antiAliasWithSaveLayer].
  void clipPathAndPaint(Path path, Clip clipBehavior, Rect bounds, VoidCallback painter) {
    _clipAndPaint((bool doAntiAias) => canvas.clipPath(path, doAntiAlias: doAntiAias), clipBehavior, bounds, painter);
  }

  /// Clip [canvas] with [Path] according to `rrect` and then paint. [canvas] is
  /// restored to the pre-clip status afterwards.
  ///
  /// `bounds` is the saveLayer bounds used for [Clip.antiAliasWithSaveLayer].
  void clipRRectAndPaint(RRect rrect, Clip clipBehavior, Rect bounds, VoidCallback painter) {
    _clipAndPaint((bool doAntiAias) => canvas.clipRRect(rrect, doAntiAlias: doAntiAias), clipBehavior, bounds, painter);
  }

  /// Clip [canvas] with [Path] according to `rect` and then paint. [canvas] is
  /// restored to the pre-clip status afterwards.
  ///
  /// `bounds` is the saveLayer bounds used for [Clip.antiAliasWithSaveLayer].
  void clipRectAndPaint(Rect rect, Clip clipBehavior, Rect bounds, VoidCallback painter) {
    _clipAndPaint((bool doAntiAias) => canvas.clipRect(rect, doAntiAlias: doAntiAias), clipBehavior, bounds, painter);
  }
}
