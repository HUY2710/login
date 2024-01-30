part of '../onboarding_screen.dart';

class ActionRow extends StatefulWidget {
  const ActionRow({
    super.key,
    required PageController pageController,
    required this.onStartedTap,
  }) : _pageController = pageController;

  final PageController _pageController;
  final VoidCallback onStartedTap;

  @override
  State<ActionRow> createState() => _ActionRowState();
}

class _ActionRowState extends State<ActionRow> {
  @override
  Widget build(BuildContext context) {
    final int currentIndex = context.watch<ValueCubit<int>>().state;
    return Padding(
      padding: EdgeInsets.only(bottom: 40.h, top: 15.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: buildIndicator(
              context,
              3,
              currentIndex,
            ),
          ),
          28.verticalSpace,
          GestureDetector(
            onTap: () {
              if (currentIndex < 2) {
                _pressNextButton(currentIndex);
              } else {
                widget.onStartedTap();
              }
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFB67DFF),
                    Color(0xFF7B3EFF),
                  ],
                ),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Stack(
                children: [
                  Align(
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 16.w,
                    child: Assets.icons.icForward.svg(height: 24.h),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _pressNextButton(int currentIndex) {
    if (currentIndex < 2) {
      context.read<ValueCubit<int>>().update(currentIndex + 1);
      if (currentIndex < 3) {
        widget._pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    }
  }
}
