import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../app/cubit/loading_cubit.dart';
import '../../../app/cubit/native_ad_status_cubit.dart';
import '../../../module/admob/app_ad_id_manager.dart';
import '../../../module/admob/enum/ad_remote_key.dart';
import '../../../module/admob/utils/inter_ad_util.dart';
import '../../../module/admob/widget/ads/small_native_ad.dart';
import '../../config/di/di.dart';
import '../../config/remote_config.dart';
import '../../data/local/avatar/avatar_repository.dart';
import '../../data/models/avatar/avatar_model.dart';
import '../../data/remote/firestore_client.dart';
import '../../gen/gens.dart';
import '../../global/global.dart';
import '../../shared/cubit/value_cubit.dart';
import '../../shared/enum/gender_type.dart';
import '../../shared/extension/context_extension.dart';
import '../../shared/helpers/valid_helper.dart';
import '../../shared/widgets/containers/shadow_container.dart';
import '../../shared/widgets/custom_appbar.dart';
import '../create/widgets/gender_switch.dart';
import '../onboarding/widgets/app_button.dart';

@RoutePage<bool>()
class EditInfoScreen extends StatefulWidget {
  const EditInfoScreen({super.key});

  @override
  State<EditInfoScreen> createState() => _EditInfoScreenState();
}

class _EditInfoScreenState extends State<EditInfoScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  ValueCubit<String> pathAvatarCubit =
      ValueCubit(Global.instance.user!.avatarUrl);
  TextEditingController userNameCtrl = TextEditingController();

  @override
  void initState() {
    userNameCtrl = TextEditingController(text: user.displayName ?? '');
    super.initState();
  }

  GenderType currentGender = GenderType.male;
  void showDialogAvatar() {
    showDialog(
      context: context,
      builder: (context) {
        return Builder(builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            List<AvatarModel> currentList = currentGender == GenderType.male
                ? maleAvatarList
                : femaleAvatarList;
            return AlertDialog(
              title: GenderSwitch(
                onChanged: (value) {
                  setState(() {
                    currentGender = value;
                    currentList = currentGender == GenderType.male
                        ? maleAvatarList
                        : femaleAvatarList;
                  });
                },
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 24.w,
                    mainAxisSpacing: 24.h,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        pathAvatarCubit.update(currentList[index].avatarPath);
                      },
                      child: CircleAvatar(
                        backgroundImage: Image.asset(
                          currentList[index].avatarPath,
                          gaplessPlayback: true,
                        ).image,
                      ),
                    );
                  },
                  itemCount: currentList.length,
                ),
              ),
            );
          });
        });
      },
    );
  }

  Future<void> updateInfo() async {
    final user = FirebaseAuth.instance.currentUser!;
    if (userNameCtrl.text.isNotEmpty &&
        ValidHelper.containsSpecialCharacters(userNameCtrl.text)) {
      Fluttertoast.showToast(msg: 'Vui lòng không chứa kí tự đặc biệt');
      return;
    }
    //không có gì thay đổi thì không update
    if (userNameCtrl.text == Global.instance.user!.userName &&
        pathAvatarCubit.state == Global.instance.user!.avatarUrl) {
      context.popRoute(false);
    } else {
      try {
        // EasyLoading.show();
        showLoading();
        user.updateDisplayName(userNameCtrl.text.trim());

        await FirestoreClient.instance.updateUser({
          'avatarUrl': pathAvatarCubit.state,
          'userName': ValidHelper.removeExtraSpaces(userNameCtrl.text.trim())
        });
        Global.instance.user = Global.instance.user?.copyWith(
            avatarUrl: pathAvatarCubit.state,
            userName: userNameCtrl.text.trim());
        // EasyLoading.dismiss();
        hideLoading();
        final bool isShowInterAd = RemoteConfigManager.instance
            .isShowAd(AdRemoteKeys.inter_edit_profile);
        if (isShowInterAd) {
          await InterAdUtil.instance.showInterAd(
              id: getIt<AppAdIdManager>().adUnitId.interMessage,
              time: 0,
              adDismissed: () =>
                  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge));
        }
        if (context.mounted) {
          context.popRoute(true);
        }
      } catch (error) {
        // EasyLoading.dismiss();
        hideLoading();
        // Fluttertoast.showToast(msg: context.l10n.error);
      }
    }
  }

  Widget buildAd() {
    final bool isShow =
        RemoteConfigManager.instance.isShowAd(AdRemoteKeys.native_edit);
    return BlocBuilder<NativeAdStatusCubit, bool>(
      builder: (context, state) {
        return Visibility(
          maintainState: true,
          visible: state && isShow,
          child: SmallNativeAd(
            unitId: getIt<AppAdIdManager>().adUnitId.nativeEdit,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.editAccount),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: AppButton(
              title: context.l10n.save,
              onTap: updateInfo,
              isEnable: userNameCtrl.text.trim().isNotEmpty,
            ),
          ),
          5.h.verticalSpace,
          ShadowContainer(
            borderRadius: BorderRadius.all(Radius.circular(10.r)),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10.r)),
                child: buildAd()),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            30.verticalSpace,
            Stack(
              children: [
                BlocBuilder<ValueCubit<String>, String>(
                  bloc: pathAvatarCubit,
                  builder: (context, state) {
                    return Hero(
                      tag: 'editAvatar',
                      child: CircleAvatar(
                        radius: 75,
                        backgroundImage: AssetImage(state),
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      showDialogAvatar();
                    },
                    child: ShadowContainer(
                      padding: EdgeInsets.all(8.r),
                      child: SvgPicture.asset(Assets.icons.icEdit.path),
                    ),
                  ),
                )
              ],
            ),
            36.verticalSpace,
            ShadowContainer(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              borderRadius: BorderRadius.all(Radius.circular(20.r)),
              colorShadow: const Color(0xff9C747D).withOpacity(0.17),
              child: TextField(
                controller: userNameCtrl,
                cursorColor: MyColors.primary,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  setState(() {
                    userNameCtrl.text = value;
                  });
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: false,
                  isDense: true,
                ),
              ),
            ),
            // 6.verticalSpace,
            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
            // child: ShadowContainer(
            //   borderRadius: BorderRadius.all(Radius.circular(10.r)),
            //   child: ClipRRect(
            //       borderRadius: BorderRadius.all(Radius.circular(10.r)),
            //       child: buildAd()),
            // ),
            // )
          ],
        ),
      ),
    );
  }
}
