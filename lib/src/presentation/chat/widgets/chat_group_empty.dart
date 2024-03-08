part of '../chat_screen.dart';

class GroupChatEmpty extends StatelessWidget {
  const GroupChatEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.images.chatGroupEmpty.image(width: 163.w, height: 145.h),
          40.verticalSpace,
          Text(
            context.l10n.chatGroupEmptyTitle,
            style: TextStyle(
                color: MyColors.black34,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500),
          ),
          Text(
            context.l10n.chatGroupEmptySub,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: MyColors.black34,
              fontSize: 13.sp,
            ),
          ),
          24.verticalSpace,
          // CustomInkWell(
          //     child: Container(
          //       padding:
          //           const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          //       decoration: BoxDecoration(
          //         gradient: gradientBackground,
          //         borderRadius: BorderRadius.circular(15.sp),
          //       ),
          //       child: Text(
          //         context.l10n.addNewMember,
          //         style: TextStyle(
          //             color: Colors.white,
          //             fontSize: 14.sp,
          //             fontWeight: FontWeight.w500),
          //       ),
          //     ),
          //     onTap: () {})
        ],
      ),
    );
  }
}
