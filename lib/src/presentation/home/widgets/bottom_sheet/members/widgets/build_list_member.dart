import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../config/di/di.dart';
import '../../../../../../data/models/store_member/store_member.dart';
import '../../../../../../data/remote/firestore_client.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../global/global.dart';
import '../../../../../../shared/cubit/value_cubit.dart';
import '../../../../../map/cubit/select_group_cubit.dart';
import '../../../dialog/action_dialog.dart';
import 'item_member.dart';

class BuildListMember extends StatelessWidget {
  const BuildListMember({
    super.key,
    required this.listStoreMember,
    required this.isEditCubit,
  });
  final List<StoreMember> listStoreMember;
  final ValueCubit<bool> isEditCubit;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listStoreMember.length,
      itemBuilder: (context, index) {
        final StoreMember member = listStoreMember[index];
        if (member.idUser == Global.instance.user?.code &&
            listStoreMember.length == 1) {
          return const Text('Only you');
        }
        return Row(
          children: [
            BlocBuilder<ValueCubit<bool>, bool?>(
              bloc: isEditCubit,
              builder: (context, state) {
                return Visibility(
                  visible: state != null && state,
                  child: GestureDetector(
                    onTap: () {
                      try {
                        showDialog(
                          context: context,
                          builder: (context) => ActionDialog(
                            title: 'Remove Member',
                            subTitle:
                                'Are you sure to the remove this member from your group?',
                            confirmTap: () async {
                              //xóa user ra khỏi nhóm,
                              context.popRoute();
                              EasyLoading.show();
                              await FirestoreClient.instance.leaveGroup(
                                  getIt<SelectGroupCubit>().state!.idGroup!,
                                  member.idUser ?? '');
                              getIt<SelectGroupCubit>()
                                  .removeMember(member.idUser ?? '');
                              //xóa user ra khỏi group local data
                              EasyLoading.dismiss();
                            },
                            confirmText: 'Delete',
                          ),
                        );
                        return;
                      } catch (error) {}
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 12.w),
                      child: InkWell(
                          child: Assets.icons.icDelete.svg(width: 20.r)),
                    ),
                  ),
                );
              },
            ),
            Expanded(
              child: ItemMember(
                isAdmin: listStoreMember[index].isAdmin,
                idUser: listStoreMember[index].idUser ?? '',
              ),
            ),
          ],
        );
      },
    );
  }
}
