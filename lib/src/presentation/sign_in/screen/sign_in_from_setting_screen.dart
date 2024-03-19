import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../config/di/di.dart';
import '../../../config/navigation/app_router.dart';
import '../../../data/local/shared_preferences_manager.dart';
import '../../../data/models/store_user/store_user.dart';
import '../../../data/remote/collection_store.dart';
import '../../../data/remote/firestore_client.dart';
import '../../../gen/gens.dart';
import '../../../global/global.dart';
import '../../../shared/enum/preference_keys.dart';
import '../../../shared/extension/context_extension.dart';
import '../../../shared/extension/int_extension.dart';
import '../../../shared/mixin/permission_mixin.dart';
import '../../../shared/utils/toast_utils.dart';
import '../../../shared/widgets/custom_appbar.dart';
import '../../map/cubit/select_group_cubit.dart';
import '../cubit/join_anonymous_cubit.dart';
import '../cubit/sign_in_cubit.dart';
import '../widgets/item_sign_in.dart';

@RoutePage()
class SignInFromSettingScreen extends StatefulWidget {
  const SignInFromSettingScreen({
    super.key,
  });

  @override
  State<SignInFromSettingScreen> createState() =>
      _SignInFromSettingScreenState();
}

class _SignInFromSettingScreenState extends State<SignInFromSettingScreen>
    with PermissionMixin {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();

    super.dispose();
  }

  Future<void> getExitsUser(String uid) async {
    final result =
        await CollectionStore.users.where('uid', isEqualTo: uid).limit(1).get();

    if (result.docs.isNotEmpty) {
      // Lấy document đầu tiên từ QuerySnapshot
      final QueryDocumentSnapshot<Map<String, dynamic>> document =
          result.docs.first;

      // Lấy dữ liệu từ Firestore và chuyển đổi thành đối tượng StoreGroup
      StoreUser storeUser = StoreUser.fromJson(document.data());
      // Lấy documentId

      storeUser =
          storeUser.copyWith(uid: FirebaseAuth.instance.currentUser?.uid);
      Global.instance.user = storeUser;

      await SharedPreferencesManager.setString(
              PreferenceKeys.userCode.name, Global.instance.user!.code)
          .then((value) async {
        if (Global.instance.user?.userName == null ||
            Global.instance.user?.userName == '') {
          context.router.replaceAll([const CreateUsernameRoute()]);
        } else {
          final bool statusLocation = await checkPermissionLocation().isGranted;
          if (!statusLocation && context.mounted) {
            context.router.replaceAll([PermissionRoute(fromMapScreen: false)]);
            return;
          } else if (context.mounted) {
            final showGuide = await SharedPreferencesManager.getGuide();
            if (showGuide && context.mounted) {
              context.router.replaceAll([const GuideRoute()]);
            } else if (context.mounted) {
              context.router.replaceAll([PremiumRoute(fromStart: true)]);
            }
          }
        }
      });
    } else {
      await FirestoreClient.instance.updateUser(
          {'uid': FirebaseAuth.instance.currentUser?.uid}).then((value) async {
        if (Global.instance.user?.userName == '') {
          // ignore: use_build_context_synchronously
          context.router.replaceAll([const CreateUsernameRoute()]);
        } else {
          final bool statusLocation = await checkPermissionLocation().isGranted;
          if (!statusLocation && context.mounted) {
            context.router.replaceAll([PermissionRoute(fromMapScreen: false)]);
            return;
          } else if (context.mounted) {
            final showGuide = await SharedPreferencesManager.getGuide();
            if (showGuide && context.mounted) {
              context.router.replaceAll([const GuideRoute()]);
            } else if (context.mounted) {
              context.router.replaceAll([PremiumRoute(fromStart: true)]);
            }
          }
        }
      });
    }
  }

  Future<void> getExistUserCode(String code) async {
    final result = await CollectionStore.users.doc(code).get();
    if (result.exists) {
      final StoreUser storeUser = StoreUser.fromJson(result.data()!);
      Global.instance.user = storeUser;
    }
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
        avatarUrl: Assets.images.avatars.male.avatar1.path);
    Global.instance.user = storeUser;
    await FirestoreClient.instance.createUser(storeUser).then((value) async {
      await SharedPreferencesManager.setString(
          PreferenceKeys.userCode.name, newCode);
    });

    return storeUser;
  }

  Future<void> navigateToNextScreen() async {
    final authUser = FirebaseAuth.instance.currentUser;
    await SharedPreferencesManager.saveIsStarted(false);
    if (mounted) {
      getIt<SelectGroupCubit>().update(null);
      if (context.read<JoinAnonymousCubit>().state) {
        if (Global.instance.user?.uid == null) {
          final String? userCode = await SharedPreferencesManager.getString(
              PreferenceKeys.userCode.name);
          await getExistUserCode(userCode!).then((value) async {
            if (Global.instance.user?.userName == null ||
                Global.instance.user?.userName == '') {
              context.router.replaceAll([const CreateUsernameRoute()]);
            } else {
              final bool statusLocation =
                  await checkPermissionLocation().isGranted;
              if (!statusLocation && context.mounted) {
                context.router
                    .replaceAll([PermissionRoute(fromMapScreen: false)]);
                return;
              } else if (context.mounted) {
                final showGuide = await SharedPreferencesManager.getGuide();
                if (showGuide && context.mounted) {
                  context.router.replaceAll([const GuideRoute()]);
                } else if (context.mounted) {
                  context.router.replaceAll([PremiumRoute(fromStart: true)]);
                }
              }
            }
          });
        } else {
          await FirebaseAuth.instance.signOut();
          StoreUser? storeUser;
          addNewUser(storeUser: storeUser).then((value) {
            context.router.replaceAll([const CreateUsernameRoute()]);
          });
        }
      } else {
        if (Global.instance.user != null && authUser != null) {
          getExitsUser(authUser.uid);
        } else {
          context.router.replaceAll([const CreateUsernameRoute()]);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CustomAppBar(title: '${context.l10n.signIn}/${context.l10n.signUp}'),
      body: BlocProvider(
        create: (context) => SignInCubit(),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    final SignInCubit signInCubit = getIt<SignInCubit>();
    return BlocListener<SignInCubit, SignInState>(
        bloc: signInCubit,
        listener: (context, state) {
          if (state.signInStatus == SignInStatus.error) {
            if (state.errorMessage.contains('INVALID LOGIN CREDENTIALS')) {
              ToastUtils.error(
                'invalid_login_credentials',
              );
            } else {
              ToastUtils.error(
                state.errorMessage,
              );
            }
          } else if (state.signInStatus == SignInStatus.success) {
            navigateToNextScreen();
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                28.verticalSpace,
                Text(
                  context.l10n.titleSignInSetting,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff343434)),
                ),
                18.verticalSpace,
                ItemSignIn(
                  onTap: () async {
                    context
                        .read<JoinAnonymousCubit>()
                        .setJoinAnonymousCubit(false);
                    await SharedPreferencesManager.saveIsLogin(false);
                    signInCubit.signInWithFacebook();
                  },
                  haveShadow: true,
                ),
                ItemSignIn(
                  onTap: () async {
                    context
                        .read<JoinAnonymousCubit>()
                        .setJoinAnonymousCubit(false);
                    await SharedPreferencesManager.saveIsLogin(false);
                    signInCubit.signInWithGoogle();
                  },
                  logo: Assets.icons.login.icGoogle.path,
                  title: context.l10n.continueWithGoogle,
                  haveShadow: true,
                ),
                if (Platform.isIOS)
                  ItemSignIn(
                    onTap: () async {
                      context
                          .read<JoinAnonymousCubit>()
                          .setJoinAnonymousCubit(false);
                      await SharedPreferencesManager.saveIsLogin(false);
                      signInCubit.siginWithApple();
                    },
                    logo: Assets.icons.login.icApple.path,
                    title: context.l10n.continueWithApple,
                  )
                else
                  const SizedBox.shrink(),
              ],
            ),
          ),
        ));
  }
}
