import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../app/cubit/loading_cubit.dart';
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
import '../cubit/join_anonymous_cubit.dart';
import '../cubit/sign_in_cubit.dart';
import '../widgets/item_sign_in.dart';

@RoutePage()
class SignInScreen extends StatefulWidget {
  const SignInScreen({
    super.key,
  });

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with PermissionMixin {
  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getExistUserCode(String code) async {
    final result = await CollectionStore.users.doc(code).get();
    if (result.exists) {
      final StoreUser storeUser = StoreUser.fromJson(result.data()!);
      Global.instance.user = storeUser;
    }
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
          context.replaceRoute(const CreateUsernameRoute());
        } else {
          final bool statusLocation = await checkPermissionLocation().isGranted;
          if (!statusLocation && context.mounted) {
            context.replaceRoute(PermissionRoute(fromMapScreen: false));
            return;
          } else if (context.mounted) {
            final showGuide = await SharedPreferencesManager.getGuide();
            if (showGuide && context.mounted) {
              context.replaceRoute(const GuideRoute());
            } else if (context.mounted) {
              context.replaceRoute(PremiumRoute(fromStart: true));
            }
          }
        }
      });
      return;
    }

    await FirestoreClient.instance
        .updateUser({'uid': FirebaseAuth.instance.currentUser?.uid});

    if (Global.instance.user?.userName == '' && context.mounted) {
      context.replaceRoute(const CreateUsernameRoute());
      return;
    }
    final bool statusPermission = await checkAllPermission();
    if (!statusPermission && context.mounted) {
      context.replaceRoute(PermissionRoute(fromMapScreen: false));
      return;
    }

    //check xem app này đã từng show guide chưa
    final showGuide = await SharedPreferencesManager.getGuide();
    if (showGuide && context.mounted) {
      context.replaceRoute(const GuideRoute());
      return;
    }
    //nếu pass tất cả màn trên thì đến màn premium
    if (context.mounted) {
      context.replaceRoute(PremiumRoute(fromStart: true));
      return;
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
      if (context.read<JoinAnonymousCubit>().state) {
        if (Global.instance.user?.uid == null) {
          final String? userCode = await SharedPreferencesManager.getString(
              PreferenceKeys.userCode.name);
          await getExistUserCode(userCode!).then((value) async {
            if (Global.instance.user?.userName == null ||
                Global.instance.user?.userName == '') {
              context.replaceRoute(const CreateUsernameRoute());
            } else {
              final bool statusLocation =
                  await checkPermissionLocation().isGranted;
              if (!statusLocation && context.mounted) {
                context.replaceRoute(PermissionRoute(fromMapScreen: false));
                return;
              } else if (context.mounted) {
                final showGuide = await SharedPreferencesManager.getGuide();
                if (showGuide && context.mounted) {
                  context.replaceRoute(const GuideRoute());
                } else if (context.mounted) {
                  context.replaceRoute(PremiumRoute(fromStart: true));
                }
              }
            }
          });
        } else {
          await FirebaseAuth.instance.signOut();
          StoreUser? storeUser;
          addNewUser(storeUser: storeUser).then((value) {
            context.replaceRoute(const CreateUsernameRoute());
          });
        }
      } else {
        if (Global.instance.user != null && authUser != null) {
          getExitsUser(authUser.uid);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => SignInCubit(),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    final SignInCubit signInCubit = getIt<SignInCubit>();
    return BlocListener<SignInCubit, SignInState>(
        bloc: signInCubit..initial(),
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
            hideLoading();
            navigateToNextScreen();
          } else if (state.signInStatus == SignInStatus.loading) {
            showLoading();
          }
        },
        child: Stack(
          children: [
            Image.asset(
              Assets.images.backgroundLogin.path,
              fit: BoxFit.fill,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            Positioned(
                top: 75.h,
                right: 0,
                left: 0,
                child: SvgPicture.asset(Assets.icons.login.icGroupApp.path)),
            Positioned(
              top: 267.h,
              right: 0,
              left: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    Text(
                      context.l10n.app_title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20.sp,
                          color: Colors.white),
                    ),
                    87.verticalSpace,
                    ItemSignIn(
                      onTap: () async {
                        context
                            .read<JoinAnonymousCubit>()
                            .setJoinAnonymousCubit(false);
                        await SharedPreferencesManager.saveIsLogin(false);
                        signInCubit.signInWithFacebook();
                      },
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
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 28.h,
              right: 0,
              left: 0,
              child: GestureDetector(
                onTap: () async {
                  context
                      .read<JoinAnonymousCubit>()
                      .setJoinAnonymousCubit(true);
                  await SharedPreferencesManager.saveIsLogin(true);
                  signInCubit.joinWithAnonymous();
                },
                child: Text(
                  context.l10n.joinWithAnonymous,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white),
                ),
              ),
            )
          ],
        ));
  }
}
