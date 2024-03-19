import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../config/di/di.dart';
import '../../../shared/utils/toast_utils.dart';
import '../../sign_in/widgets/base_auth_widget.dart';
import '../../sign_in/widgets/text_title_widget.dart';
import '../cubit/sign_up_cubit.dart';
import '../widgets/pin_code_widget.dart';

@RoutePage()
class ConfirmPinCodeScreen extends StatefulWidget {
  const ConfirmPinCodeScreen({
    super.key,
    this.isSignUp = true,
    this.pinCode,
    this.userName,
  });

  final String? pinCode;
  final String? userName;
  final bool? isSignUp;

  @override
  State<ConfirmPinCodeScreen> createState() => _CreatePinCodeScreenState();
}

class _CreatePinCodeScreenState extends State<ConfirmPinCodeScreen> {
  TextEditingController controllerConfirmCode = TextEditingController();
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
          saveCodeSccess: () {
            context.router.replaceAll([]);
          },
          error: (message) {
            ToastUtils.error(message);
          },
          orElse: () {},
        );
      },
      child: BaseAuthWidget(
        padding: EdgeInsets.symmetric(horizontal: 34.w),
        child: Column(
          children: [
            SizedBox(
              height: 99.h,
            ),
            const TextTitleWidget(
                title: 'context.l10n.confirm_your_pin_account'),
            SizedBox(
              height: 53.h,
            ),
            PinCodeWidget(
              autoFocus: true,
              onSubmitted: (value) {
                if (widget.pinCode != controllerConfirmCode.text) {
                  ToastUtils.error('context.l10n.pin_not_in_correct');
                } else {
                  signUpCubit.saveCodeAndUserName(
                    controllerConfirmCode.text,
                    widget.userName ?? '',
                    isSignUp: widget.isSignUp,
                  );
                }
              },
              controller: controllerConfirmCode,
              onCompleted: (value) {
                if (widget.pinCode != controllerConfirmCode.text) {
                  ToastUtils.error('context.l10n.pin_not_in_correct');
                } else {
                  signUpCubit.saveCodeAndUserName(
                    controllerConfirmCode.text,
                    widget.userName ?? '',
                    isSignUp: widget.isSignUp,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
