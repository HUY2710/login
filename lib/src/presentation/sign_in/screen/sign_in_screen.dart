import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/di/di.dart';
import '../cubit/sign_in_cubit.dart';
import 'input_email.dart';

@RoutePage()
class SignInScreen extends StatefulWidget {
  const SignInScreen({
    super.key,
    this.isAnotherAccount = false,
  });
  final bool isAnotherAccount;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    final SignInCubit signInCubit = getIt<SignInCubit>();
    return BlocProvider(
      create: (context) => SignInCubit(),
      child: BlocBuilder<SignInCubit, SignInState>(
        bloc: signInCubit..initial(),
        builder: (context, state) {
          switch (state.signInStepEnum) {
            case SignInStepEnum.inputEmail:
              return InputEmail(
                email: state.email,
                password: state.password,
              );

            case SignInStepEnum.verifyCode:
              // return VerifyCodeScreen(
              //   isAnotherAccount: widget.isAnotherAccount,
              // );
              return Container(
                color: Colors.white,
              );
          }
        },
      ),
    );
  }
}
