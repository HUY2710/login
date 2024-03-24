part of '../onboarding_screen.dart';

class OnboardingCarousel extends StatelessWidget {
  const OnboardingCarousel({
    super.key,
    required PageController pageController,
  }) : _pageController = pageController;

  final PageController _pageController;

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      onPageChanged: (int page) {
        context.read<ValueCubit<int>>().update(page);
      },
      children: <Widget>[
        ContentPageWidget(
          image: Assets.images.onboarding.onboarding1,
          title: context.l10n.onboarding_title_1,
        ),
        ContentPageWidget(
          image: Assets.images.onboarding.onboarding2,
          title: context.l10n.onboarding_title_2,
        ),
        ContentPageWidget(
          image: Assets.images.onboarding.onboarding3,
          title: context.l10n.onboarding_title_3,
        ),
        ContentPageWidget(
          image: Assets.images.onboarding.onboarding4,
          title: context.l10n.onboarding_title_4,
        ),
        ContentPageWidget(
          image: Assets.images.onboarding.onboarding5,
          title: context.l10n.onboarding_title_3,
          isRichText: true,
        ),
      ],
    );
  }
}
