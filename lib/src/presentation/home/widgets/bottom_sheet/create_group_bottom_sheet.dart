import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../data/models/store_group/store_group.dart';
import '../../../../data/remote/firestore_client.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../global/global.dart';
import '../../../../shared/extension/int_extension.dart';
import 'invite_code_bottom_sheet.dart';
import 'show_bottom_sheet_home.dart';

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
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                    color: const Color(0xff8E52FF),
                  ),
                ),
              ),
              Text(
                'Create Group',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20.sp,
                  color: const Color(0xff343434),
                ),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    //apply cubit after
                    if (groupNameController.text.isNotEmpty &&
                        Global.instance.user != null) {
                      //create group;
                      final newGroup = StoreGroup(
                        code: 6.randomUpperCaseString(),
                        idGroup: 24.randomString(),
                        groupName: groupNameController.text,
                        iconGroup: '',
                        avatarGroup: Assets.images.avatars.avatar10.path,
                        members: {Global.instance.user!.code: true},
                      );

                      await FirestoreClient.instance.createGroup(newGroup);
                      if (context.mounted) {
                        context.popRoute().then(
                              (value) => showBottomSheetTypeOfHome(
                                context: context,
                                child: InviteGroupWidget(
                                  code: newGroup.code,
                                ),
                              ),
                            );
                      }
                    }
                  } catch (e) {
                    debugPrint('error:$e');
                  }
                },
                child: Text(
                  'Done',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                    color: groupNameController.text.isNotEmpty
                        ? const Color(0xff8E52FF)
                        : const Color(0xffABABAB),
                  ),
                ),
              )
            ],
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 84.r,
                height: 84.r,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff42474C),
                      ),
                    ]),
              ),
            ],
          ),
          28.verticalSpace,
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
      ),
    );
  }
}
