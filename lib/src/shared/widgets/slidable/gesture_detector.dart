import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'controller.dart';

// INTERNAL USE
// ignore_for_file: public_member_api_docs

class SlidableGestureDetector extends StatefulWidget {
  const SlidableGestureDetector({
    super.key,
    this.enabled = true,
    required this.controller,
    required this.direction,
    required this.child,
    this.dragStartBehavior = DragStartBehavior.start,
  });

  final SlidableController controller;
  final Widget child;
  final Axis direction;
  final bool enabled;

  final DragStartBehavior dragStartBehavior;

  @override
  _SlidableGestureDetectorState createState() =>
      _SlidableGestureDetectorState();
}

class _SlidableGestureDetectorState extends State<SlidableGestureDetector> {
  double dragExtent = 0;
  late Offset startPosition;
  late Offset lastPosition;

  bool get directionIsXAxis {
    return widget.direction == Axis.horizontal;
  }

  @override
  Widget build(BuildContext context) {
    final canDragHorizontally = directionIsXAxis && widget.enabled;
    return GestureDetector(
      onTap: onTapSlidable,
      onHorizontalDragStart: canDragHorizontally ? handleDragStart : null,
      onHorizontalDragUpdate: canDragHorizontally ? handleDragUpdate : null,
      onHorizontalDragEnd: canDragHorizontally ? handleDragEnd : null,
      behavior: HitTestBehavior.opaque,
      dragStartBehavior: widget.dragStartBehavior,
      child: widget.child,
    );
  }

  void onTapSlidable() {
    handleDragStart(DragStartDetails(globalPosition: Offset(292.w, 460.h)));
    handleDragUpdate(
      DragUpdateDetails(
        globalPosition: Offset(244.w, 473.h),
        primaryDelta: -50.w,
        delta: Offset(-50.w, 0),
      ),
    );
    handleDragEnd(
      DragEndDetails(
        primaryVelocity: -185.w,
        velocity: Velocity(
          pixelsPerSecond: Offset(-185.w, 0),
        ),
      ),
    );
  }

  double get overallDragAxisExtent {
    final Size? size = context.size;
    return directionIsXAxis ? size!.width : size!.height;
  }

  void handleDragStart(DragStartDetails details) {
    startPosition = details.localPosition;
    lastPosition = startPosition;
    dragExtent = dragExtent.sign *
        overallDragAxisExtent *
        widget.controller.ratio *
        widget.controller.direction.value;
    debugPrint('details:$details');
  }

  void handleDragUpdate(DragUpdateDetails details) {
    final delta = details.primaryDelta!;
    dragExtent += delta;
    lastPosition = details.localPosition;
    widget.controller.ratio = dragExtent / overallDragAxisExtent;
    debugPrint('handleDragUpdate:$details');
  }

  void handleDragEnd(DragEndDetails details) {
    final delta = lastPosition - startPosition;
    final primaryDelta = directionIsXAxis ? delta.dx : delta.dy;
    final gestureDirection =
        primaryDelta >= 0 ? GestureDirection.opening : GestureDirection.closing;

    widget.controller.dispatchEndGesture(
      details.primaryVelocity,
      gestureDirection,
    );
    debugPrint('handleDragEnd:$details');
  }
}
