import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../data/models/store_group/store_group.dart';
import '../../../../data/remote/firestore_client.dart';
import '../../../../global/global.dart';
import '../../../../shared/extension/int_extension.dart';

class BottomSheetCreateGroup extends StatefulWidget {
  const BottomSheetCreateGroup({
    super.key,
  });

  @override
  State<BottomSheetCreateGroup> createState() => _BottomSheetCreateGroupState();
}

class _BottomSheetCreateGroupState extends State<BottomSheetCreateGroup> {
  TextEditingController groupNameController = TextEditingController(text: '');
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.3,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20).r,
        ),
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          top: 8.h,
        ),
        child: Column(
          children: [
            Container(
              height: 4.h,
              width: 40.w,
              decoration: BoxDecoration(
                color: const Color(0xffE2E2E2),
                borderRadius: BorderRadius.all(
                  Radius.circular(2.5.r),
                ),
              ),
            ),
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
                  onPressed: () async {
                    try {
                      //apply cubit after
                      if (groupNameController.text.isNotEmpty &&
                          Global.instance.user != null) {
                        //create group;
                        final newGroup = StoreGroup(
                          code: 6.randomString(),
                          groupName: groupNameController.text,
                          iconGroup: '',
                          members: {Global.instance.user!.code: true},
                        );

                        await FirestoreClient.instance.createGroup(newGroup);
                        if (context.mounted) {
                          context.popRoute();
                        }
                      }
                    } catch (e) {
                      debugPrint('error:$e');
                    }
                  },
                  child: const Text('Done'),
                )
              ],
            ),
            TextFormField(
              controller: groupNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.r),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
