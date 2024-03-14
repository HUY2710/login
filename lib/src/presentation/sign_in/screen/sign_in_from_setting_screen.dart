import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../config/di/di.dart';
import '../../../config/navigation/app_router.dart';
import '../../../data/local/shared_preferences_manager.dart';
import '../../../gen/gens.dart';
import '../../../global/global.dart';
import '../../../shared/extension/context_extension.dart';
import '../../../shared/mixin/permission_mixin.dart';
import '../../../shared/utils/toast_utils.dart';
import '../../../shared/widgets/custom_appbar.dart';
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

  Future<void> navigateToNextScreen() async {
    final user = Global.instance.user;
    await SharedPreferencesManager.saveIsStarted(false);

    if (mounted) {
      if (user != null) {
        if (user.userName == '') {
          context.replaceRoute(CreateUsernameRoute());
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
              // context.replaceRoute(HomeRoute());
              context.replaceRoute(PremiumRoute(fromStart: true));
            }
          }
        }
      } else {
        context.replaceRoute(CreateUsernameRoute());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final SignInCubit signInCubit = getIt<SignInCubit>();
    return Scaffold(
      appBar:
          CustomAppBar(title: '${context.l10n.signIn}/${context.l10n.signUp}'),
      body: BlocProvider(
        create: (context) => SignInCubit(),
        child: BlocListener<SignInCubit, SignInState>(
          bloc: signInCubit..initial(),
          listener: (context, state) {
            if (state.signInStatus == SignInStatus.success) {
              navigateToNextScreen();
            }
          },
          child: _buildBody(),
        ),
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
                  onTap: () {
                    context
                        .read<JoinAnonymousCubit>()
                        .setJoinAnonymousCubit(false);
                    signInCubit.signInWithFacebook();
                  },
                  haveShadow: true,
                ),
                ItemSignIn(
                  onTap: () {
                    context
                        .read<JoinAnonymousCubit>()
                        .setJoinAnonymousCubit(false);
                    signInCubit.signInWithGoogle();
                  },
                  logo: Assets.icons.login.icGoogle.path,
                  title: context.l10n.continueWithGoogle,
                  haveShadow: true,
                ),
                if (Platform.isIOS)
                  ItemSignIn(
                    onTap: () {
                      context
                          .read<JoinAnonymousCubit>()
                          .setJoinAnonymousCubit(false);
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
