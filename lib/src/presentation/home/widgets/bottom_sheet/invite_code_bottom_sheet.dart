// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import '../../../../../gen/colors.gen.dart';
// import '../../../../../gen/gens.dart';
// import '../../../../../shared/extension/context_extension.dart';
// import '../../../../../shared/helpers/gradient_background.dart';
// import '../../../../../shared/widgets/custom_inkwell.dart';
// import '../../../../../shared/widgets/gradient_text.dart';
// import '../../../../../shared/widgets/my_drag.dart';

// class InviteGroupWidget extends StatelessWidget {
//   const InviteGroupWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         const MyDrag(),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const SizedBox(width: 80),
//             Text(
//               context.l10n.inviteCode,
//               style: TextStyle(
//                 fontSize: 16.sp,
//                 fontWeight: FontWeight.w500,
//                 color: MyColors.black34,
//               ),
//             ),
//             TextButton(
//               onPressed: () {},
//               child: GradientText(
//                 context.l10n.done,
//                 style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
//               ),
//             ),
//           ],
//         ),
//         50.h.verticalSpace,
//         SizedBox(
//           width: 249.w,
//           child: Text(
//             context.l10n.inviteCodeContent,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//                 color: MyColors.black34,
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.w500),
//           ),
//         ),
//         16.h.verticalSpace,
//         Container(
//           width: double.infinity,
//           margin: const EdgeInsets.symmetric(horizontal: 16),
//           padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(15.r),
//               border: Border.all(color: const Color(0xffEAEAEA))),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const SizedBox(width: 40),
//               GradientText(
//                 'NIY - WHQ',
//                 style: TextStyle(fontSize: 34.sp, fontWeight: FontWeight.w600),
//               ),
//               CustomInkWell(
//                 child: Assets.icons.icCopy.svg(width: 24.r),
//                 onTap: () {},
//               )
//             ],
//           ),
//         ),
//         8.verticalSpace,
//         Text(
//           context.l10n.inviteCodeSub,
//           style: TextStyle(
//               color: MyColors.black34,
//               fontSize: 14.sp,
//               fontWeight: FontWeight.w500),
//         ),
//         32.verticalSpace,
//         Container(
//           width: 260.w,
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(15.r),
//               gradient: gradienBackground),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Assets.icons.icShareLocation
//                   .svg(width: 24.r, color: Colors.white),
//               8.horizontalSpace,
//               Text(
//                 context.l10n.shareCode,
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w600),
//               )
//             ],
//           ),
//         ),
//         50.verticalSpace,
//       ],
//     );
//   }
// }
