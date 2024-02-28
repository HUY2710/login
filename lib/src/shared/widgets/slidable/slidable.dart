import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import 'action_pane_configuration.dart';
import 'auto_close_behavior.dart';
import 'controller.dart';
import 'dismissal.dart';
import 'gesture_detector.dart';
import 'notifications_old.dart';
import 'scrolling_behavior.dart';

part 'action_pane.dart';

class MySlidable extends StatefulWidget {
  const MySlidable({
    super.key,
    this.groupTag,
    this.enabled = true,
    this.closeOnScroll = true,
    this.startActionPane,
    this.endActionPane,
    this.direction = Axis.horizontal,
    this.dragStartBehavior = DragStartBehavior.down,
    this.useTextDirection = true,
    required this.child,
  });

  final bool enabled;
  final bool closeOnScroll;

  final Object? groupTag;

  final ActionPane? startActionPane;

  final ActionPane? endActionPane;

  final Axis direction;

  final bool useTextDirection;

  final DragStartBehavior dragStartBehavior;

  final Widget child;

  @override
  _SlidableState createState() => _SlidableState();

  static SlidableController? of(BuildContext context) {
    final scope = context
        .getElementForInheritedWidgetOfExactType<_SlidableControllerScope>()
        ?.widget as _SlidableControllerScope?;
    return scope?.controller;
  }
}

class _SlidableState extends State<MySlidable>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final SlidableController controller;
  late Animation<Offset> moveAnimation;
  late bool keepPanesOrder;

  @override
  bool get wantKeepAlive => !widget.closeOnScroll;

  @override
  void initState() {
    super.initState();
    controller = SlidableController(this)
      ..actionPaneType.addListener(handleActionPanelTypeChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    updateIsLeftToRight();
    updateController();
    updateMoveAnimation();
  }

  @override
  void didUpdateWidget(covariant MySlidable oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateIsLeftToRight();
    updateController();
  }

  @override
  void dispose() {
    controller.actionPaneType.removeListener(handleActionPanelTypeChanged);
    controller.dispose();
    super.dispose();
  }

  void updateController() {
    controller
      ..enableStartActionPane = startActionPane != null
      ..startActionPaneExtentRatio = startActionPane?.extentRatio ?? 0;

    controller
      ..enableEndActionPane = endActionPane != null
      ..endActionPaneExtentRatio = endActionPane?.extentRatio ?? 0;
  }

  void updateIsLeftToRight() {
    final textDirection = Directionality.of(context);
    controller.isLeftToRight = widget.direction == Axis.vertical ||
        !widget.useTextDirection ||
        textDirection == TextDirection.ltr;
  }

  void handleActionPanelTypeChanged() {
    setState(() {
      updateMoveAnimation();
    });
  }

  void handleDismissing() {
    if (controller.resizeRequest.value != null) {
      setState(() {});
    }
  }

  void updateMoveAnimation() {
    final double end = controller.direction.value.toDouble();
    moveAnimation = controller.animation.drive(
      Tween<Offset>(
        begin: Offset.zero,
        end: widget.direction == Axis.horizontal
            ? Offset(end, 0)
            : Offset(0, end),
      ),
    );
  }

  Widget? get actionPane {
    switch (controller.actionPaneType.value) {
      case ActionPaneType.start:
        return startActionPane;
      case ActionPaneType.end:
        return endActionPane;
      default:
        return null;
    }
  }

  ActionPane? get startActionPane => widget.startActionPane;
  ActionPane? get endActionPane => widget.endActionPane;

  Alignment get actionPaneAlignment {
    final sign = controller.direction.value.toDouble();
    if (widget.direction == Axis.horizontal) {
      return Alignment(-sign, 0);
    } else {
      return Alignment(0, -sign);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget content = SlideTransition(
      position: moveAnimation,
      child: SlidableAutoCloseBehaviorInteractor(
        groupTag: widget.groupTag,
        controller: controller,
        child: widget.child,
      ),
    );

    content = Stack(
      children: <Widget>[
        if (actionPane != null)
          Positioned.fill(
            child: ClipRect(
              clipper: _SlidableClipper(
                axis: widget.direction,
                controller: controller,
              ),
              child: actionPane,
            ),
          ),
        content,
      ],
    );

    return SlidableGestureDetector(
      enabled: widget.enabled,
      controller: controller,
      direction: widget.direction,
      dragStartBehavior: widget.dragStartBehavior,
      child: SlidableNotificationSender(
        tag: widget.groupTag,
        controller: controller,
        child: SlidableScrollingBehavior(
          controller: controller,
          closeOnScroll: widget.closeOnScroll,
          child: SlidableDismissal(
            axis: flipAxis(widget.direction),
            controller: controller,
            child: ActionPaneConfiguration(
              alignment: actionPaneAlignment,
              direction: widget.direction,
              isStartActionPane:
                  controller.actionPaneType.value == ActionPaneType.start,
              child: _SlidableControllerScope(
                controller: controller,
                child: content,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SlidableControllerScope extends InheritedWidget {
  const _SlidableControllerScope({
    required this.controller,
    required super.child,
  });

  final SlidableController? controller;

  @override
  bool updateShouldNotify(_SlidableControllerScope old) {
    return controller != old.controller;
  }
}

class _SlidableClipper extends CustomClipper<Rect> {
  _SlidableClipper({
    required this.axis,
    required this.controller,
  }) : super(reclip: controller.animation);

  final Axis axis;
  final SlidableController controller;

  @override
  Rect getClip(Size size) {
    switch (axis) {
      case Axis.horizontal:
        final double offset = controller.ratio * size.width;
        if (offset < 0) {
          return Rect.fromLTRB(size.width + offset, 0, size.width, size.height);
        }
        return Rect.fromLTRB(0, 0, offset, size.height);
      case Axis.vertical:
        final double offset = controller.ratio * size.height;
        if (offset < 0) {
          return Rect.fromLTRB(
            0,
            size.height + offset,
            size.width,
            size.height,
          );
        }
        return Rect.fromLTRB(0, 0, size.width, offset);
    }
  }

  @override
  Rect getApproximateClipRect(Size size) => getClip(size);

  @override
  bool shouldReclip(_SlidableClipper oldClipper) {
    return oldClipper.axis != axis;
  }
}
