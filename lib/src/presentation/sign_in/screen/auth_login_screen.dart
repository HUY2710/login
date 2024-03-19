import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../config/navigation/app_router.dart';
import '../../../data/local/shared_preferences_manager.dart';
import '../../../data/models/store_group/store_group.dart';
import '../../../data/remote/firestore_client.dart';
import '../../../global/global.dart';
import '../../../shared/mixin/permission_mixin.dart';

import '../cubit/authen_cubit.dart';
import '../cubit/authen_state.dart';

@RoutePage()
class AuthLoginScreen extends StatefulWidget {
  const AuthLoginScreen({super.key});

  @override
  State<AuthLoginScreen> createState() => _AuthLoginScreenState();
}

class _AuthLoginScreenState extends State<AuthLoginScreen>
    with PermissionMixin {
  List<StoreGroup> listMyGroups = [];

  Future<void> getMyGroups() async {
    final result = await FirestoreClient.instance.getMyGroups();
    if (result != null) {
      listMyGroups = result;
    }
  }

  @override
  void dispose() {
    getMyGroups();
    super.dispose();
  }

  Future<void> navigateToNextScreen() async {
    SharedPreferencesManager.saveIsStarted(false);

    if (mounted) {
      if (Global.instance.user != null) {
        if (Global.instance.user?.userName == '') {
          context.replaceRoute(const CreateUsernameRoute());
        } else if (Global.instance.user?.userName != '' &&
            listMyGroups.isEmpty) {
          context.replaceRoute(const CreateGroupNameRoute());
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
        context.replaceRoute(const CreateUsernameRoute());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            navigateToNextScreen();
          } else if (state is Unauthenticated) {
            context.pushRoute(const SignInRoute());
          }
        },
        child: const SizedBox.shrink(),
      ),
    );
  }
}
