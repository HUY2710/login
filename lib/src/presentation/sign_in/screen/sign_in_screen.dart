import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/cubit/loading_cubit.dart';
import '../../../config/di/di.dart';
import '../../../config/navigation/app_router.dart';
import '../../../data/local/shared_preferences_manager.dart';
import '../../../data/models/store_sos/store_sos.dart';
import '../../../data/models/store_user/store_user.dart';
import '../../../data/remote/collection_store.dart';
import '../../../data/remote/firestore_client.dart';
import '../../../data/remote/sos_manager.dart';
import '../../../gen/gens.dart';
import '../../../global/global.dart';
import '../../../shared/enum/preference_keys.dart';
import '../../../shared/extension/context_extension.dart';
import '../../../shared/helpers/time_helper.dart';
import '../../../shared/mixin/permission_mixin.dart';
import '../../../shared/utils/toast_utils.dart';
import '../../sos/cubit/sos_cubit.dart';
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

  Future<void> getExitsUser(String uid) async {
    final result =
        await CollectionStore.users.where('uid', isEqualTo: uid).limit(1).get();

    if (result.docs.isNotEmpty) {
      // Lấy document đầu tiên từ QuerySnapshot
      final QueryDocumentSnapshot<Map<String, dynamic>> document =
          result.docs.first;

      StoreUser storeUser = StoreUser.fromJson(document.data());

      storeUser =
          storeUser.copyWith(uid: FirebaseAuth.instance.currentUser?.uid);
      //status sos
      final StoreSOS? sos = await SosManager.getSOS(storeUser.code);
      //nếu user chưa có sos
      if (sos == null) {
        getIt<SosCubit>().update(false);
      }
      //nếu user có sos và xem nó có bật và limit hết hạn
      if (sos != null && sos.sos) {
        //nếu time hết hạn
        if (sos.sosTimeLimit != null &&
            TimerHelper.checkTimeDifferenceCurrent(
                sos.sosTimeLimit ?? DateTime.now(),
                argMinute: 10)) {
          getIt<SosCubit>().update(false);
        } else {
          getIt<SosCubit>().update(true);
        }
      } else {
        getIt<SosCubit>().update(false);
      }

      Global.instance.user = storeUser.copyWith(sosStore: sos);

      await SharedPreferencesManager.setString(
              PreferenceKeys.userCode.name, Global.instance.user!.code)
          .then((value) async {
        final bool statusLocation = await checkAllPermission();
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
      });
      return;
    }

    //nếu chưa có tài khoản
    await FirestoreClient.instance
        .updateUser({'uid': FirebaseAuth.instance.currentUser?.uid});
    Global.instance.user = Global.instance.user
        ?.copyWith(uid: FirebaseAuth.instance.currentUser?.uid);
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

  Future<void> navigateToNextScreen() async {
    final authUser = FirebaseAuth.instance.currentUser;
    if (mounted) {
      if (Global.instance.user != null && authUser != null) {
        await getExitsUser(authUser.uid);
        return;
      }
    }
  }

  void signInAnonymous() {
    getIt<SosCubit>().update(false);
    SharedPreferencesManager.saveIsLogin(true);
    AutoRouter.of(context).replaceAll([const CreateUsernameRoute()]);
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
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
          hideLoading();
        } else if (state.signInStatus == SignInStatus.success) {
          navigateToNextScreen().then((value) => hideLoading());
        } else if (state.signInStatus == SignInStatus.loading) {
          showLoading();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              Assets.images.loginBg.path,
            ),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 30.h),
              child: Image.asset(Assets.icons.login.groupLogin.path),
            ),
            30.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ItemSignIn(
                    onTap: () async {
                      signInCubit.signInWithFacebook();
                    },
                  ),
                  ItemSignIn(
                    onTap: () async {
                      signInCubit.signInWithGoogle();
                    },
                    logo: Assets.icons.login.icGoogle.path,
                    title: context.l10n.continueWithGoogle,
                  ),
                  if (Platform.isIOS)
                    ItemSignIn(
                      onTap: () async {
                        signInCubit.siginWithApple();
                      },
                      logo: Assets.icons.login.icApple.path,
                      title: context.l10n.continueWithApple,
                    )
                ],
              ),
            ),
            const Expanded(child: SizedBox()),
            GestureDetector(
              onTap: signInAnonymous,
              child: Text(
                context.l10n.joinWithAnonymous,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white),
              ),
            ),
            20.verticalSpace
          ],
        ),
      ),
    );
  }
}
