import 'package:flutter/material.dart';

import 'slidable/action_pane_motions.dart';
import 'slidable/actions.dart';
import 'slidable/slidable.dart';

class CustomSwipeWidget extends StatelessWidget {
  const CustomSwipeWidget({
    super.key,
    required this.child,
    this.firstRight,
    required this.actionRight2,
    this.actionRight1,
    this.enable = true,
  });
  final Widget child;
  final bool? firstRight;
  final bool enable;
  final VoidCallback? actionRight1;
  final VoidCallback actionRight2;

  @override
  Widget build(BuildContext context) {
    return MySlidable(
      key: UniqueKey(),
      closeOnScroll: false,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: firstRight != null && firstRight! ? 0.5 : 0.25,
        children: [
          if (firstRight != null && firstRight!)
            SlidableAction(
              spacing: 0,
              onPressed: (context) {
                if (actionRight1 != null) {
                  actionRight1!();
                }
              },
              backgroundColor: const Color(0xff7B3EFF),
              foregroundColor: Colors.white,
              icon: Icons.edit,
            ),
          SlidableAction(
            spacing: 0,
            onPressed: (context) {
              actionRight2();
            },
            backgroundColor: const Color(0xffFF3B30),
            foregroundColor: Colors.white,
            icon: Icons.delete_forever,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ],
      ),
      child: child,
    );
  }
}
