import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../config/di/di.dart';
import '../../../../data/models/store_group/store_group.dart';
import '../../../../data/models/store_message/store_message.dart';
import '../../../../data/remote/firestore_client.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../gen/gens.dart';
import '../../../../global/global.dart';
import '../../../../shared/extension/int_extension.dart';
import '../../../../shared/helpers/valid_helper.dart';
import '../../../../shared/widgets/containers/shadow_container.dart';
import '../../../../shared/widgets/custom_circle_avatar.dart';
import '../../../../shared/widgets/my_drag.dart';
import '../../../map/cubit/select_group_cubit.dart';
import 'invite_code.dart';
import 'show_bottom_sheet_home.dart';

class CreateEditGroup extends StatefulWidget {
  const CreateEditGroup({
    super.key,
    this.detailGroup,
  });
  final StoreGroup? detailGroup;
  @override
  State<CreateEditGroup> createState() => _CreateEditGroupState();
}

class _CreateEditGroupState extends State<CreateEditGroup> {
  final TextEditingController groupNameController = TextEditingController();
  StoreGroup? tempGroup;
  Future<void> _tapDone() async {
    if (groupNameController.text.isNotEmpty &&
        ValidHelper.containsSpecialCharacters(groupNameController.text)) {
      Fluttertoast.showToast(msg: 'Vui lòng không chứa kí tự đặc biệt');
      return;
    }
    //nếu detailGroup !=null => edit group
    if (tempGroup != null) {
      updateGroup().then((value) => context.popRoute());
      return;
    }
    try {
      //apply cubit after
      if (groupNameController.text.isNotEmpty && Global.instance.user != null) {
        //create group;
        final validName =
            ValidHelper.removeExtraSpaces(groupNameController.text);
        final newGroup = StoreGroup(
          passCode: 6.randomUpperCaseString(),
          idGroup: 24.randomString(),
          groupName: validName,
          avatarGroup: Assets.images.avatars.avatar10.path,
        );

        await FirestoreClient.instance.createGroup(newGroup);
        if (context.mounted) {
          context.popRoute().then(
                (value) => showBottomSheetTypeOfHome(
                  context: context,
                  child: InviteCode(
                    code: newGroup.passCode,
                  ),
                ),
              );
        }
      }
    } catch (e) {
      debugPrint('error:$e');
    }
  }

  Future<void> updateGroup() async {
    try {
      final name = ValidHelper.removeExtraSpaces(groupNameController.text);
      EasyLoading.show();
      await FirestoreClient.instance.updateGroup(
        idGroup: tempGroup!.idGroup!,
        mapFields: {'groupName': name},
      );
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: 'Update Group Success!');

      //sau khi update thành công thì tiến hành cập nhật lại group ở local
      getIt<SelectGroupCubit>().update(
        getIt<SelectGroupCubit>().state?.copyWith(groupName: name),
      );
    } catch (error) {
      Fluttertoast.showToast(msg: '$error');
    }
  }

  @override
  void initState() {
    super.initState();
    groupNameController.text = widget.detailGroup?.groupName ?? '';
    if (widget.detailGroup != null) {
      tempGroup = widget.detailGroup;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20).r,
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MyDrag(),
          Row(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Align(
                      child: Text(
                        widget.detailGroup != null ? 'Edit' : 'Create Group',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20.sp,
                          color: const Color(0xff343434),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => context.popRoute(),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.sp,
                            color: const Color(0xff8E52FF),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: groupNameController.text.isNotEmpty
                            ? _tapDone
                            : () {},
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
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          20.verticalSpace,
          Stack(
            children: [
              if (widget.detailGroup != null)
                CustomCircleAvatar(
                  pathImageAssets: widget.detailGroup!.avatarGroup,
                )
              else
                ShadowContainer(
                  height: 84.r,
                  width: 84.r,
                  colorShadow: const Color(0xff42474C).withOpacity(0.15),
                  child: Center(
                    child: SvgPicture.asset(
                      Assets.icons.icPeople.path,
                      width: 56.r,
                      height: 56.r,
                      colorFilter: const ColorFilter.mode(
                        Color(0xffD5BBFF),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              Positioned(
                bottom: 0,
                right: 0,
                child: ShadowContainer(
                  padding: EdgeInsets.all(6.r),
                  width: 28.r,
                  height: 28.r,
                  child: SvgPicture.asset(
                    Assets.icons.icEdit.path,
                    colorFilter: const ColorFilter.mode(
                      Color(0xff7B3EFF),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              )
            ],
          ),
          20.verticalSpace,
          TextFormField(
            controller: groupNameController,
            onChanged: (value) {
              setState(() {
                groupNameController.text = value;
              });
            },
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
