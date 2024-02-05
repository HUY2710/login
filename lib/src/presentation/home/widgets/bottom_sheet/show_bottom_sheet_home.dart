import 'package:flutter/material.dart';

import '../../../../shared/constants/app_constants.dart';

Future<void> showBottomSheetTypeOfHome({
  required BuildContext context,
  required Widget child,
  bool? isScrollControlled,
}) async {
  await showAppModalBottomSheet(
    context: context,
    isScrollControlled: isScrollControlled ?? false,
    barrierColor: Colors.white.withOpacity(0.1),
    builder: (context) {
      return child;
    },
  );
}

Future<void> showAppModalBottomSheet({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
  String? barrierLabel,
  double? elevation,
  ShapeBorder? shape,
  Clip? clipBehavior,
  BoxConstraints? constraints,
  Color? barrierColor,
  bool isScrollControlled = false,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
  bool? showDragHandle,
  bool useSafeArea = false,
  RouteSettings? routeSettings,
  AnimationController? transitionAnimationController,
  Offset? anchorPoint,
  }) async {
  await showModalBottomSheet(context: context,
      builder: builder,
    backgroundColor: backgroundColor,
    barrierLabel: barrierLabel,
    elevation: elevation,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.containerBorder)),
    ),
    clipBehavior: clipBehavior,
    constraints: constraints,
    barrierColor: barrierColor,
    isScrollControlled: isScrollControlled,
    useRootNavigator: useRootNavigator,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    showDragHandle: showDragHandle,
    useSafeArea: useSafeArea,
    routeSettings: routeSettings,
    transitionAnimationController: transitionAnimationController,
    anchorPoint: anchorPoint
  );
}
