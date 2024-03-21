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
import '../../../data/models/store_user/store_user.dart';
import '../../../data/remote/collection_store.dart';
import '../../../data/remote/firestore_client.dart';
import '../../../gen/gens.dart';
import '../../../global/global.dart';
import '../../../shared/enum/preference_keys.dart';
import '../../../shared/extension/context_extension.dart';
import '../../../shared/mixin/permission_mixin.dart';
import '../../../shared/utils/toast_utils.dart';
import '../../../shared/widgets/custom_appbar.dart';
import '../../map/cubit/select_group_cubit.dart';
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
    try {
      final result = await CollectionStore.users
          .where('uid', isEqualTo: uid)
          .limit(1)
          .get();
      if (result.docs.isNotEmpty) {
        final QueryDocumentSnapshot<Map<String, dynamic>> document =
            result.docs.first;
        final StoreUser storeUser = StoreUser.fromJson(document.data());
        Global.instance.user = storeUser;
        await SharedPreferencesManager.setString(
                PreferenceKeys.userCode.name, Global.instance.user!.code)
            .then((value) async {
          context.router.replaceAll([PremiumRoute(fromStart: true)]);
        });
        return;
      }

      await FirestoreClient.instance.updateUser(
          {'uid': FirebaseAuth.instance.currentUser?.uid}).then((value) async {
        Global.instance.user = Global.instance.user
            ?.copyWith(uid: FirebaseAuth.instance.currentUser?.uid);
        context.router.replaceAll([PremiumRoute(fromStart: true)]);
        return;
      });
    } catch (error) {}
  }

  Future<void> getExistUserCode(String code) async {
    final result = await CollectionStore.users.doc(code).get();
    if (result.exists) {
      final StoreUser storeUser = StoreUser.fromJson(result.data()!);
      Global.instance.user = storeUser;
    }
  }

  Future<void> navigateToNextScreen() async {
    final authUser = FirebaseAuth.instance.currentUser;
    if (mounted) {
      getIt<SelectGroupCubit>().update(null);
      if (Global.instance.user != null && authUser != null) {
        getExitsUser(authUser.uid);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CustomAppBar(title: '${context.l10n.signIn}/${context.l10n.signUp}'),
      body: buildBody(),
    );
  }

  Widget buildBody() {
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
            navigateToNextScreen().then((value) => hideLoading());
          }
          if (state.signInStatus == SignInStatus.loading) {
            showLoading();
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
                    await SharedPreferencesManager.saveIsLogin(false);
                    signInCubit.signInWithFacebook();
                  },
                  haveShadow: true,
                ),
                ItemSignIn(
                  onTap: () async {
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
                      await SharedPreferencesManager.saveIsLogin(false);
                      signInCubit.siginWithApple();
                    },
                    logo: Assets.icons.login.icApple.path,
                    title: context.l10n.continueWithApple,
                    haveShadow: true,
                  )
                else
                  const SizedBox.shrink(),
              ],
            ),
          ),
        ));
  }
}
