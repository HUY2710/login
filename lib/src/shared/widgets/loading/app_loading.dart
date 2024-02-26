// BallScaleMultiple.
import 'package:flutter/material.dart';

import 'indicator_controller.dart';
import 'indicator_painter.dart';

class BallScaleMultiple extends StatefulWidget {
  const BallScaleMultiple({Key? key}) : super(key: key);

  @override
  State<BallScaleMultiple> createState() => _BallScaleMultipleState();
}

class _BallScaleMultipleState extends State<BallScaleMultiple>
    with TickerProviderStateMixin, IndicatorController {
  static const _durationInMills = 1000;

  static const _delayInMills = [0, 200, 400];

  final List<AnimationController> _animationControllers = [];
  final List<Animation<double>> _scaleAnimations = [];
  final List<Animation<double>> _opacityAnimations = [];

  @override
  List<AnimationController> get animationControllers => _animationControllers;

  @override
  void initState() {
    for (int i = 0; i < 3; i++) {
      _animationControllers.add(AnimationController(
        value: _delayInMills[i] / _durationInMills,
        vsync: this,
        duration: const Duration(milliseconds: _durationInMills),
      ));

      _scaleAnimations.add(Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _animationControllers[i], curve: Curves.linear)));
      _opacityAnimations.add(TweenSequence([
        // TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 5),
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 95),
      ]).animate(CurvedAnimation(
          parent: _animationControllers[i], curve: Curves.linear)));
      _animationControllers[i].repeat();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = List.filled(3, Container());
    for (int i = 0; i < 3; i++) {
      widgets[i] = ScaleTransition(
        scale: _scaleAnimations[i],
        child: FadeTransition(
          opacity: _opacityAnimations[i],
          child: IndicatorShapeWidget(
            shape: Shape.circle,
            index: i,
          ),
        ),
      );
    }
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: widgets,
    );
  }
}
