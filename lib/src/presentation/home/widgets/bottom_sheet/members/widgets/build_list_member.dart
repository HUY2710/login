import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../app/cubit/loading_cubit.dart';
import '../../../../../../config/di/di.dart';
import '../../../../../../data/models/store_member/store_member.dart';
import '../../../../../../data/models/store_user/store_user.dart';
import '../../../../../../data/remote/firestore_client.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../global/global.dart';
import '../../../../../../shared/cubit/value_cubit.dart';
import '../../../../../../shared/extension/context_extension.dart';
import '../../../../../map/cubit/select_group_cubit.dart';
import '../../../dialog/action_dialog.dart';
import 'item_member.dart';

class BuildListMember extends StatelessWidget {
  const BuildListMember({
    super.key,
    required this.isEditCubit,
    required this.listMembers,
  });
  final List<StoreUser> listMembers;
  final ValueCubit<bool> isEditCubit;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listMembers.length,
      itemBuilder: (context, index) {
        final StoreUser member = listMembers[index];
        debugPrint('code member:${member.code}');
        final admin = getIt<SelectGroupCubit>().state?.storeMembers?.firstWhere(
              (member) => member.isAdmin,
              orElse: () => const StoreMember(isAdmin: false),
            );
        debugPrint('code admn:${admin?.idUser}');

        debugPrint(' admin:${admin?.idUser == member.code}');
        return Row(
          children: [
            BlocBuilder<ValueCubit<bool>, bool?>(
              bloc: isEditCubit,
              builder: (context, state) {
                return Visibility(
                  visible: state != null &&
                      state &&
                      member.code != Global.instance.user?.code,
                  child: GestureDetector(
                    onTap: () {
                      try {
                        showDialog(
                          context: context,
                          builder: (context) => ActionDialog(
                            title: context.l10n.removeMember,
                            subTitle: context.l10n.removeGroupContent,
                            confirmTap: () async {
                              //xóa user ra khỏi nhóm,
                              context.popRoute();
                              // EasyLoading.show();
                              showLoading();
                              await FirestoreClient.instance.leaveGroup(
                                  getIt<SelectGroupCubit>().state!.idGroup!,
                                  member.code);
                              getIt<SelectGroupCubit>()
                                  .removeMember(member.code);
                              //xóa user ra khỏi group local data
                              // EasyLoading.dismiss();
                              hideLoading();
                            },
                            confirmText: context.l10n.delete,
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
                isAdmin: admin?.idUser == member.code,
                user: member,
              ),
            ),
          ],
        );
      },
    );
  }
}
