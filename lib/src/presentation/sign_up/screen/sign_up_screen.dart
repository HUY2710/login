import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/di/di.dart';
import '../../../config/navigation/app_router.dart';
import '../../../shared/constants/app_text_style.dart';
import '../../../shared/extension/context_extension.dart';
import '../../../shared/utils/regexp_utils.dart';
import '../../../shared/utils/toast_utils.dart';
import '../../sign_in/widgets/base_auth_widget.dart';
import '../../sign_in/widgets/button_primary_widget.dart';
import '../../sign_in/widgets/text_fied_widget.dart';
import '../../sign_in/widgets/text_field_password_widget.dart';
import '../../sign_in/widgets/text_title_widget.dart';
import '../cubit/sign_up_cubit.dart';

@RoutePage()
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  late String? codePin;
  bool? isLoading;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void dispose() {
    controllerName.dispose();
    controllerEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    final SignUpCubit signUpCubit = getIt<SignUpCubit>();
    return BlocListener<SignUpCubit, SignUpState>(
      bloc: signUpCubit,
      listener: (context, state) {
        state.maybeWhen(
          signUpSccess: () async {
            context.pushRoute(
              CreatePinCodeRoute(userName: controllerName.text),
            );
          },
          error: (message) {
            ToastUtils.error(message);
          },
          orElse: () {
            return null;
          },
        );
      },
      child: BaseAuthWidget(
        resizeToAvoidBottomInset: true,
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              children: [
                SizedBox(
                  height: 90.h,
                ),
                const TextTitleWidget(
                  title: 'Resgister',
                ),
                SizedBox(
                  height: 28.h,
                ),
                SizedBox(
                  height: 60.h,
                ),
                TextFieldWidget(
                  controller: controllerName,
                  hinText: context.l10n.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter this field';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
                TextFieldWidget(
                  controller: controllerEmail,
                  hinText: 'Email',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter this field';
                    } else {
                      if (!RegExpUtils().emailValid(value.trim())) {
                        return 'Email is not incorrect format';
                      }
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
                TextFieldPasswordWidget(
                  controller: controllerPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter this field';
                    } else if (value.length < 6) {
                      return 'Password validate';
                    }
                    // else if (!RegExpUtils().passwordValid(value)) {
                    //   return 'Password should contain upper,lower,digit and special character';
                    // }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
                BlocBuilder<SignUpCubit, SignUpState>(
                  bloc: signUpCubit,
                  builder: (context, state) {
                    return ButtonPrimaryWidget(
                      title: 'Create',
                      isLoading: state.maybeWhen(
                        loading: () => true,
                        signUpSccess: () => false,
                        orElse: () => false,
                      ),
                      onTap: () async {
                        if (_key.currentState!.validate()) {
                          signUpCubit.createUser(
                            email: controllerEmail.text,
                            password: controllerPassword.text,
                          );
                        }
                      },
                    );
                  },
                ),
                SizedBox(
                  height: 28.h,
                ),
                GestureDetector(
                  onTap: () {
                    context.pushRoute(SignInRoute());
                  },
                  child: Text(
                    'Login',
                    style: AppTextStyle.s14w600,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
