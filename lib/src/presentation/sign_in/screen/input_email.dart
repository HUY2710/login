import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../config/di/di.dart';
import '../../../config/navigation/app_router.dart';
import '../../../data/local/shared_preferences_manager.dart';
import '../../../shared/mixin/permission_mixin.dart';
import '../../../shared/utils/toast_utils.dart';
import '../cubit/sign_in_cubit.dart';
import '../widgets/base_auth_widget.dart';
import '../widgets/button_primary_widget.dart';
import '../widgets/text_fied_widget.dart';
import '../widgets/text_field_password_widget.dart';
import '../widgets/text_title_widget.dart';

class InputEmail extends StatefulWidget {
  const InputEmail({
    super.key,
    required this.email,
    required this.password,
  });
  final String email;
  final String password;

  @override
  State<InputEmail> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<InputEmail> with PermissionMixin {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controllerEmail = TextEditingController(text: widget.email);
    controllerPassword = TextEditingController(text: widget.password);
    super.initState();
  }

  Future<void> navigateToNextScreen() async {
    await SharedPreferencesManager.saveIsStarted(false);

    final isCreateInfoFirstTime =
        await SharedPreferencesManager.getIsCreateInfoFistTime();
    if (mounted) {
      if (isCreateInfoFirstTime) {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
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
      child: Form(
        key: _key,
        child: BaseAuthWidget(
          resizeToAvoidBottomInset: true,
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
          ),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 110.h,
                  ),
                  const TextTitleWidget(
                    title: 'Login',
                  ),
                  SizedBox(
                    height: 35.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: TextFieldWidget(
                      controller: controllerEmail,
                      hinText: 'email',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter this field';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: TextFieldPasswordWidget(
                      controller: controllerPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter this field';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  BlocBuilder<SignInCubit, SignInState>(
                    bloc: signInCubit,
                    builder: (context, state) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: ButtonPrimaryWidget(
                          isLoading: state.signInStatus == SignInStatus.loading,
                          onTap: () {
                            if (_key.currentState!.validate()) {
                              signInCubit.signInWithEmailAndPassword(
                                email: controllerEmail.text,
                                password: controllerPassword.text,
                              );
                            }
                          },
                          title: 'Login',
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      context.pushRoute(const SignUpRoute());
                    },
                    child: const Text(
                      "Don't have account? Sign up",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
