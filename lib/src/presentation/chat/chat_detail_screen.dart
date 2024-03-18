import 'dart:io';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iap/flutter_iap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../app/cubit/language_cubit.dart';
import '../../../app/cubit/loading_cubit.dart';
import '../../../module/iap/my_purchase_manager.dart';
import '../../config/di/di.dart';
import '../../config/navigation/app_router.dart';
import '../../data/local/shared_preferences_manager.dart';
import '../../data/models/store_message/store_message.dart';
import '../../data/models/store_user/store_user.dart';
import '../../data/remote/cloud_storage_client.dart';
import '../../data/remote/member_manager.dart';
import '../../gen/gens.dart';
import '../../global/global.dart';
import '../../services/location_service.dart';
import '../../shared/constants/app_constants.dart';
import '../../shared/extension/context_extension.dart';
import '../../shared/widgets/containers/shadow_container.dart';
import '../../shared/widgets/custom_inkwell.dart';
import '../../shared/widgets/loading/loading_indicator.dart';
import 'cubits/group_cubit.dart';
import 'cubits/send_location_cubit.dart';
import 'services/chat_service.dart';
import 'utils/util.dart';

part './widgets/chat_detail/chat_mess_empty.dart';
part 'widgets/chat_detail/chat_type_text.dart';
part 'widgets/chat_detail/message_guess.dart';
part 'widgets/chat_detail/message_user.dart';

@RoutePage()
class ChatDetailScreen extends StatefulWidget implements AutoRouteWrapper {
  const ChatDetailScreen({
    super.key,
    required this.idGroup,
    required this.groupName,
  });
  final String idGroup;
  final String groupName;

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (context) => SendLocationCubit(),
      )
    ], child: this);
  }
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  List<StoreUser> listUser = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final memberOfGroup =
          await MemberManager.getListMemberOfGroup(widget.idGroup);
      final listIdUser = memberOfGroup!.map((e) => e.idUser ?? '').toList();
      listUser = await ChatService.instance.getUserFromListId(listIdUser);

      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChatTextWidget(
      idGroup: widget.idGroup,
      listUser: listUser,
      groupName: widget.groupName,
    );
  }
}
