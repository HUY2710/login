import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../config/di/di.dart';
import '../../../config/navigation/app_router.dart';
import '../../../data/local/shared_preferences_manager.dart';
import '../../../data/models/store_group/store_group.dart';
import '../../../data/remote/firestore_client.dart';
import '../../../gen/gens.dart';
import '../../../global/global.dart';
import '../../../shared/extension/context_extension.dart';
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
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    getMyGroups();
    super.dispose();
  }

  List<StoreGroup> listMyGroups = [];

  Future<void> getMyGroups() async {
    final result = await FirestoreClient.instance.getMyGroups();
    if (result != null) {
      listMyGroups = result;
      print('OMG ${listMyGroups.length}');
    }
  }

  Future<void> navigateToNextScreen() async {
    final user = Global.instance.user;

    await SharedPreferencesManager.saveIsStarted(false);
    // print('OMG ${groups.length}');

    if (mounted) {
      if (user != null) {
        if (user.userName == '') {
          context.replaceRoute(CreateUsernameRoute());
        } else if (user.userName != '' && listMyGroups.isNotEmpty) {
          context.replaceRoute(CreateGroupNameRoute());
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
      body: BlocProvider(
        create: (context) => SignInCubit(),
        child: BlocListener<SignInCubit, SignInState>(
          bloc: signInCubit..initial(),
          listener: (context, state) {
            if (state.signInStatus == SignInStatus.success) {
              navigateToNextScreen().then((value) async {
                final user = Global.instance.user;
                if (user?.uid == null) {
                  final authUser = FirebaseAuth.instance.currentUser!;
                  await FirestoreClient.instance
                      .updateUser({'uid': authUser.uid});
                }
              });
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
                      onTap: () {
                        context
                            .read<JoinAnonymousCubit>()
                            .setJoinAnonymousCubit(false);
                        signInCubit.signInWithFacebook();
                      },
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
            ),
            Positioned(
              bottom: 28.h,
              right: 0,
              left: 0,
              child: GestureDetector(
                onTap: () {
                  context
                      .read<JoinAnonymousCubit>()
                      .setJoinAnonymousCubit(true);
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
