import 'package:flutter/material.dart';
import '../../../../data/local/shared_preferences_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/di/di.dart';
import '../../../../data/models/store_group/store_group.dart';
import '../../../../data/models/store_member/store_member.dart';
import '../../../../data/remote/firestore_client.dart';
import '../../../../global/global.dart';
import '../../../../services/firebase_message_service.dart';
import '../../../map/cubit/select_group_cubit.dart';

part 'code_validation_cubit.freezed.dart';
part 'code_validation_state.dart';

@injectable
class CodeValidationCubit extends Cubit<CodeValidationState> {
  CodeValidationCubit() : super(const CodeValidationState.initial());

  final FirestoreClient client = FirestoreClient.instance;

  Future<void> submit(String code, BuildContext context) async {
    emit(const CodeValidationState.loading());

    try {
      //kiểm tra xem có tồn tại group đó hay không
      final StoreGroup? existGroup = await client.isExistGroup(code);
      //có thể là không tồn tại group hoặc nhập sai passCode
      if (existGroup == null) {
        emit(
          const CodeValidationState.inValid(
              'Code không hợp lệ hoặc không tồn tại group'),
        );
      } else {
        //kiểm tra xem trong members của group đó đã tồn tại mình hay chưa

        final isMemberGroup =
            await client.isExistMemberGroup(existGroup.idGroup!);

        if (isMemberGroup) {
          emit(const CodeValidationState.inValid(
              'Bạn đã là thành viên của nhóm rồi'));
        } else {
          //trường hợp chưa phải là thành viên thì tiến hành add vào group.

          // lưu thời gian người dùng xem tin nhắn
          await SharedPreferencesManager.saveTimeSeenChat(existGroup.idGroup!);

          await SharedPreferencesManager.saveIsCreateInfoFistTime(false);
          final StoreMember newMember =
              StoreMember(isAdmin: false, idUser: Global.instance.user?.code);
          final resultAdd =
              await client.addMemberToGroup(existGroup.idGroup!, newMember);
          if (resultAdd) {
            final listMember =
                await client.getListMemberOfGroup(existGroup.idGroup!);

            getIt<SelectGroupCubit>()
                .update(existGroup.copyWith(storeMembers: listMember));

            //đăng kí nhận lắng nghe thông báo
            getIt<FirebaseMessageService>()
                .subscribeTopics([existGroup.idGroup!]);
            emit(CodeValidationState.valid(existGroup));
          }
        }
      }
    } catch (e) {
      emit(
        const CodeValidationState.inValid('Không nhận diện được lỗi'),
      );
    }
  }
}
