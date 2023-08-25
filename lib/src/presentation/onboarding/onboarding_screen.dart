import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/navigation/app_router.dart';
import '../../gen/assets.gen.dart';
import 'widgets/indicator.dart';
import 'widgets/page_widget.dart';

@RoutePage()
class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int currentIndex = 0;
  late bool visibleAd;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
      ),
      // bottomNavigationBar: _buildAd(),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 3,
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  currentIndex = page;
                });
              },
              children: <Widget>[
                ContentPageWidget(
                  image: Assets.images.onboarding.onboarding1,
                  title: '',
                  description: '',
                ),
                ContentPageWidget(
                  image: Assets.images.onboarding.onboarding2,
                  title: '',
                  description: '',
                ),
                ContentPageWidget(
                  image: Assets.images.onboarding.onboarding3,
                  title: '',
                  description: '',
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: buildIndicator(context, 3, currentIndex),
                  ),
                  TextButton(
                    onPressed: currentIndex < 2 ? _pressNextButton : _done,
                    child: Text(
                      currentIndex > 1 ? 'Started' : 'Next',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _pressNextButton() {
    setState(() {
      if (currentIndex < 2) {
        currentIndex++;
        if (currentIndex < 3) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        }
      }
    });
  }

  Future<void> _done() async {
    if (mounted) {
      context.replaceRoute(const MyHomeRoute());
    }
  }
}
