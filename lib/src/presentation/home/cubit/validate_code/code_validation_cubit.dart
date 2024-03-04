import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../config/di/di.dart';
import '../../../../data/local/shared_preferences_manager.dart';
import '../../../../data/models/store_group/store_group.dart';
import '../../../../data/models/store_member/store_member.dart';
import '../../../../data/models/store_notification_place/store_notification_place.dart';
import '../../../../data/models/store_place/store_place.dart';
import '../../../../data/remote/firestore_client.dart';
import '../../../../data/remote/notification_place_manager.dart';
import '../../../../data/remote/places_manager.dart';
import '../../../../data/remote/token_manager.dart';
import '../../../../global/global.dart';
import '../../../../services/firebase_message_service.dart';
import '../../../../shared/extension/context_extension.dart';
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
      final StoreGroup? existGroup =
          await client.isExistGroup(code.toUpperCase());
      if (existGroup?.idGroup == null) {
        return;
      }
      //có thể là không tồn tại group hoặc nhập sai passCode
      if (existGroup == null) {
        emit(
          CodeValidationState.inValid(context.l10n.codeIsValid),
        );
      } else {
        //kiểm tra xem trong members của group đó đã tồn tại mình hay chưa

        final isMemberGroup =
            await client.isExistMemberGroup(existGroup.idGroup!);

        if (isMemberGroup) {
          emit(CodeValidationState.inValid(context.l10n.youAreMember));
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
            Global.instance.group = existGroup;

            //đăng kí nhận lắng nghe thông báo
            TokenManager.updateGroupNotification(false, existGroup.idGroup!);

            //lấy toàn bộ place của group đó -> tạo từng notificationPlace của từng place
            final List<StorePlace> storePlaces =
                await PlacesManager.getListStorePlace(existGroup.idGroup!);

            //sau khi có thì tiến hành thêm  cái notificationPlace của user đế check trạng thái gửi thông báo của từng place user
            for (final place in storePlaces) {
              NotificationPlaceManager.createNotificationPlace(
                idGroup: existGroup.idGroup!,
                idPlace: place.idPlace!,
                idDocNotification: Global.instance.userCode,
                storeNotificationPlace: const StoreNotificationPlace(),
              );
            }

            try {
              FirebaseMessageService().sendJoinGroup(
                  existGroup.groupName,
                  '${Global.instance.user?.userName} ${context.l10n.joined} ${existGroup.groupName}',
                  context);
            } catch (error) {
              debugPrint('error:$error');
            }

            emit(CodeValidationState.valid(existGroup));
          }
        }
      }
    } catch (e) {
      emit(
        CodeValidationState.inValid(context.l10n.errorNotDetected),
      );
    }
  }
}
