import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import '../../../app/cubit/loading_cubit.dart';
import '../../../app/cubit/native_ad_status_cubit.dart';
import '../../../module/admob/app_ad_id_manager.dart';
import '../../../module/admob/enum/ad_remote_key.dart';
import '../../../module/admob/utils/inter_ad_util.dart';
import '../../../module/admob/widget/ads/small_native_ad.dart';
import '../../config/di/di.dart';
import '../../config/navigation/app_router.dart';
import '../../config/remote_config.dart';
import '../../data/local/avatar/avatar_repository.dart';
import '../../data/local/shared_preferences_manager.dart';
import '../../data/models/avatar/avatar_model.dart';
import '../../data/models/store_group/store_group.dart';
import '../../data/models/store_message/store_message.dart';
import '../../data/models/store_user/store_user.dart';
import '../../data/remote/collection_store.dart';
import '../../data/remote/firestore_client.dart';
import '../../gen/gens.dart';
import '../../global/global.dart';
import '../../shared/constants/app_constants.dart';
import '../../shared/cubit/value_cubit.dart';
import '../../shared/enum/gender_type.dart';
import '../../shared/enum/preference_keys.dart';
import '../../shared/extension/context_extension.dart';
import '../../shared/extension/int_extension.dart';
import '../../shared/helpers/valid_helper.dart';
import '../../shared/widgets/containers/shadow_container.dart';
import '../../shared/widgets/custom_appbar.dart';
import '../../shared/widgets/dialog/delete_dialog.dart';
import '../create/widgets/gender_switch.dart';
import '../map/cubit/my_marker_cubit.dart';
import '../map/cubit/select_group_cubit.dart';
import '../sign_in/cubit/authen_cubit.dart';

@RoutePage<bool>()
class EditInfoScreen extends StatefulWidget {
  const EditInfoScreen({super.key});

  @override
  State<EditInfoScreen> createState() => _EditInfoScreenState();
}

class _EditInfoScreenState extends State<EditInfoScreen> {
  ValueCubit<String> pathAvatarCubit =
      ValueCubit(Global.instance.user!.avatarUrl);
  TextEditingController userNameCtrl =
      TextEditingController(text: Global.instance.user?.userName ?? '');
  GenderType currentGender = GenderType.male;

  late StreamSubscription<bool> keyboardSubscription;

  @override
  void initState() {
    final keyboardVisibilityController = KeyboardVisibilityController();

    // Subscribe
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (visible) {
        context.read<NativeAdStatusCubit>().update(false);
      } else {
        context.read<NativeAdStatusCubit>().update(true);
      }
    });
    super.initState();
  }

  Future<StoreUser?> addNewUser({StoreUser? storeUser}) async {
    final String newCode = 24.randomString();

    int battery = 0;
    try {
      battery = await Battery().batteryLevel;
    } catch (e) {
      battery = 100;
    }
    storeUser = StoreUser(
      code: newCode,
      userName: '',
      batteryLevel: battery,
      avatarUrl: Assets.images.avatars.male.avatar1.path,
    );
    Global.instance.user = storeUser;
    await FirestoreClient.instance.createUser(storeUser).then((value) async {
      await SharedPreferencesManager.setString(
          PreferenceKeys.userCode.name, newCode);
    });

    return storeUser;
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }

  Future<void> showDialogAvatar() async {
    context.read<NativeAdStatusCubit>().update(false);
    await showDialog(
      context: context,
      builder: (context) {
        return Builder(builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            List<AvatarModel> currentList = currentGender == GenderType.male
                ? maleAvatarList
                : femaleAvatarList;
            return AlertDialog(
              title: GenderSwitch(
                onChanged: (value) {
                  setState(() {
                    currentGender = value;
                    currentList = currentGender == GenderType.male
                        ? maleAvatarList
                        : femaleAvatarList;
                  });
                },
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 24.w,
                    mainAxisSpacing: 24.h,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        pathAvatarCubit.update(currentList[index].avatarPath);
                      },
                      child: CircleAvatar(
                        backgroundImage: Image.asset(
                          currentList[index].avatarPath,
                          gaplessPlayback: true,
                        ).image,
                      ),
                    );
                  },
                  itemCount: currentList.length,
                ),
              ),
            );
          });
        });
      },
    );
    if (mounted) {
      context.read<NativeAdStatusCubit>().update(true);
    }
  }

  Future<void> updateInfo() async {
    if (userNameCtrl.text.isNotEmpty &&
        ValidHelper.containsSpecialCharacters(userNameCtrl.text)) {
      Fluttertoast.showToast(msg: 'Vui lòng không chứa kí tự đặc biệt');
      return;
    }
    //không có gì thay đổi thì không update
    if (userNameCtrl.text == Global.instance.user!.userName &&
        pathAvatarCubit.state == Global.instance.user!.avatarUrl) {
      context.popRoute(false);
    } else {
      try {
        // EasyLoading.show();
        showLoading();
        await FirestoreClient.instance.updateUser({
          'avatarUrl': pathAvatarCubit.state,
          'userName': ValidHelper.removeExtraSpaces(userNameCtrl.text.trim())
        });
        Global.instance.user = Global.instance.user?.copyWith(
            avatarUrl: pathAvatarCubit.state,
            userName: userNameCtrl.text.trim());
        getIt<MyMarkerCubit>().update(Global.instance.user);
        // EasyLoading.dismiss();
        hideLoading();
        final bool isShowInterAd = RemoteConfigManager.instance
            .isShowAd(AdRemoteKeys.inter_edit_profile);
        if (isShowInterAd) {
          await InterAdUtil.instance.showInterAd(
              id: getIt<AppAdIdManager>().adUnitId.interMessage,
              time: 0,
              adDismissed: () =>
                  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge));
        }
        if (context.mounted) {
          context.popRoute(true);
        }
      } catch (error) {
        hideLoading();
      }
    }
  }

  Widget buildAd() {
    final bool isShow =
        RemoteConfigManager.instance.isShowAd(AdRemoteKeys.native_edit);
    return BlocBuilder<NativeAdStatusCubit, bool>(
      builder: (context, state) {
        return Visibility(
          maintainState: true,
          visible: state && isShow,
          child: SmallNativeAd(
            unitId: getIt<AppAdIdManager>().adUnitId.nativeEdit,
          ),
        );
      },
    );
  }

  Widget _buildLogOutSetting() {
    return Global.instance.user?.uid == null
        ? const SizedBox.shrink()
        : Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 2),
                  blurRadius: 8.4,
                  color: const Color(0xff9C747D).withOpacity(0.17))
            ], borderRadius: BorderRadius.circular(AppConstants.widgetBorderRadius.r), color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(17),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return DeleteDialog(
                          titleDialog: context.l10n.logOut,
                          subTitleDialog: context.l10n.titleLogout,
                          titleButton1: context.l10n.yes,
                          titleButton2: context.l10n.no,
                          onTapButton1: () {
                            context.read<AuthCubit>().loggedOut();
                            GoogleSignIn().disconnect();
                            FirebaseAuth.instance.signOut().then((value) async {
                              getIt<SelectGroupCubit>().update(null);
                              StoreUser? storeUser;
                              addNewUser(storeUser: storeUser);
                              Global.instance.group ??= StoreGroup(
                                idGroup: 24.randomString(),
                                passCode:
                                    6.randomUpperCaseString().toUpperCase(),
                                groupName: '',
                                avatarGroup: '',
                                lastMessage: MessageModel(
                                  content: '',
                                  senderId: Global.instance.user!.code,
                                  sentAt: DateTime.now().toIso8601String(),
                                ),
                              );
                              await SharedPreferencesManager.setIsLogin(false);
                              context.popRoute();
                              context.router.replaceAll([const SignInRoute()]);
                            });
                          },
                        );
                      });
                },
                child: Row(
                  children: [
                    Assets.icons.login.icLogout.svg(height: 24.h),
                    12.horizontalSpace,
                    Expanded(
                      child: Text(
                        context.l10n.logOut,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Widget _buildDeleteAccountSetting() {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            offset: const Offset(0, 2),
            blurRadius: 8.4,
            color: const Color(0xff9C747D).withOpacity(0.17))
      ], borderRadius: BorderRadius.circular(AppConstants.widgetBorderRadius.r), color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (context) {
                  return DeleteDialog(
                    titleDialog: context.l10n.deleteAccount,
                    subTitleDialog: context.l10n.titleDelete,
                    titleButton1: context.l10n.delete,
                    titleButton2: context.l10n.cancel,
                    isTextRed: true,
                    onTapButton1: () {
                      Global.instance.group ??= StoreGroup(
                        idGroup: 24.randomString(),
                        passCode: 6.randomUpperCaseString().toUpperCase(),
                        groupName: '',
                        avatarGroup: '',
                        lastMessage: MessageModel(
                          content: '',
                          senderId: Global.instance.user!.code,
                          sentAt: DateTime.now().toIso8601String(),
                        ),
                      );
                      SharedPreferencesManager.setIsLogin(false);
                      getIt<SelectGroupCubit>().update(null);
                      if (Global.instance.user?.uid == null) {
                        context.read<AuthCubit>().loggedOut();
                        CollectionStore.users
                            .doc(Global.instance.user?.code)
                            .delete();
                        StoreUser? storeUser;
                        addNewUser(storeUser: storeUser).then((value) {
                          FirestoreClient.instance.updateUser({'uid': null});
                          context.popRoute();
                          context.router.replaceAll([const SignInRoute()]);
                        });
                      } else {
                        context.read<AuthCubit>().loggedOut();
                        if (FirebaseAuth.instance.currentUser?.providerData[0]
                                .providerId ==
                            'google.com') {
                          GoogleSignIn().disconnect();
                        }

                        CollectionStore.users
                            .doc(Global.instance.user?.code)
                            .delete();

                        StoreUser? storeUser;

                        addNewUser(storeUser: storeUser).then((value) {
                          context.popRoute();
                          context.router.replaceAll([const SignInRoute()]);
                        });
                      }
                    },
                  );
                });
          },
          child: Row(
            children: [
              Assets.icons.login.icDeleteAccount.svg(height: 24.h),
              12.horizontalSpace,
              Expanded(
                child: Text(
                  context.l10n.deleteMyAccount,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: context.l10n.editAccount,
        trailing: GestureDetector(
          onTap: updateInfo,
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            child: Text(
              context.l10n.done,
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff8E52FF)),
            ),
          ),
        ),
      ),
      bottomNavigationBar: ShadowContainer(
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
            child: buildAd()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              30.verticalSpace,
              Stack(
                children: [
                  BlocBuilder<ValueCubit<String>, String>(
                    bloc: pathAvatarCubit,
                    builder: (context, state) {
                      return Hero(
                        tag: 'editAvatar',
                        child: CircleAvatar(
                          radius: 75,
                          backgroundImage: AssetImage(state),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        showDialogAvatar();
                      },
                      child: ShadowContainer(
                        padding: EdgeInsets.all(8.r),
                        child: SvgPicture.asset(Assets.icons.icEdit.path),
                      ),
                    ),
                  )
                ],
              ),
              36.verticalSpace,
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppConstants.widgetBorderRadius.r),
                    color: Colors.white,
                    border: const GradientBoxBorder(
                        gradient: LinearGradient(
                            colors: [Color(0xff7B3EFF), Color(0xffB67DFF)]))),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    controller: userNameCtrl,
                    cursorColor: MyColors.primary,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      setState(() {
                        userNameCtrl.text = value;
                      });
                    },
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xffCCADFF)),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      filled: false,
                      isDense: true,
                    ),
                  ),
                ),
              ),
              24.verticalSpace,
              _buildLogOutSetting(),
              16.verticalSpace,
              _buildDeleteAccountSetting()
            ],
          ),
        ),
      ),
    );
  }
}
