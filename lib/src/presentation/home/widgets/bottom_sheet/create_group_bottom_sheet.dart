import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomSheetCreateGroup extends StatefulWidget {
  const BottomSheetCreateGroup({
    super.key,
  });

  @override
  State<BottomSheetCreateGroup> createState() => _BottomSheetCreateGroupState();
}

class _BottomSheetCreateGroupState extends State<BottomSheetCreateGroup> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.3,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20).r,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    context.popRoute();
                  },
                  child: const Text('Cancel'),
                ),
                const Text('Create Group'),
                TextButton(
                  onPressed: () {
                    context.popRoute();
                  },
                  child: const Text('done'),
                )
              ],
            )
          ],
        ));
  }
}
