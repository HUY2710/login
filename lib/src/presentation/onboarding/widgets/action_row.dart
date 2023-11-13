part of '../onboarding_screen.dart';

class ActionRow extends StatefulWidget {
  const ActionRow({
    super.key,
    required PageController pageController,
  }) : _pageController = pageController;

  final PageController _pageController;

  @override
  State<ActionRow> createState() => _ActionRowState();
}

class _ActionRowState extends State<ActionRow> with AdsMixin {
  @override
  Widget build(BuildContext context) {
    final int currentIndex = context.watch<ValueCubit<int>>().state;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: buildIndicator(
            context,
            3,
            currentIndex,
          ),
        ),
        TextButton(
          onPressed: () {
            if (currentIndex < 2) {
              _pressNextButton(currentIndex);
            } else {
              _done();
            }
          },
          child: Text(
            currentIndex > 1 ? 'Started' : 'Next',
            style: TextStyle(
              color: context.colorScheme.primary,
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
            ),
          ),
        ),
      ],
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

  Future<void> _done() async {
    await SharedPreferencesManager.saveIsStarted(false);
    if (mounted) {
      context.replaceRoute(const PermissionRoute());
    }
  }
}
