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
          title: 'context.l10n.yourLocation',
          description: 'context.l10n.subYourLocation',
        ),
        ContentPageWidget(
          image: Assets.images.onboarding.onboarding2,
          title: 'context.l10n.locationOfFriends',
          description: 'context.l10n.subLocationFriends',
        ),
        ContentPageWidget(
          image: Assets.images.onboarding.onboarding3,
          title: 'context.l10n.seeTheirLocationHistory',
          description: 'context.l10n.subSeeLocationHistory',
        ),
      ],
    );
  }
}
