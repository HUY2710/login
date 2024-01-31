import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// Entrance of the loading.
class AppLoading extends StatelessWidget {
  const AppLoading({
    super.key,
    this.colors,
    this.backgroundColor,
    this.strokeWidth,
    this.pathBackgroundColor,
    this.pause = false,
    this.size,
  });

  /// The color you draw on the shape.
  final List<Color>? colors;
  final Color? backgroundColor;

  /// The stroke width of line.
  final double? strokeWidth;

  /// Applicable to which has cut edge of the shape
  final Color? pathBackgroundColor;

  /// Animation status, true will pause the animation, default is false
  final bool pause;

  /// The size of ball
  final double? size;

  @override
  Widget build(BuildContext context) {
    final List<Color> safeColors = colors == null || colors!.isEmpty
        ? [
            const Color(0xFFB67DFF),
            const Color(0xFF7B3EFF),
          ]
        : colors!;
    return SizedBox(
      height: size ?? 100,
      width: size ?? 100,
      child: DecorateContext(
        decorateData: DecorateData(
          colors: safeColors,
          strokeWidth: strokeWidth,
          pathBackgroundColor: pathBackgroundColor,
          pause: pause,
        ),
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            color: backgroundColor,
            child: const BallScaleMultiple(),
          ),
        ),
      ),
    );
  }

  /// return the animation indicator.
}

const double _kDefaultStrokeWidth = 2;

/// Information about a piece of animation (e.g., color).
@immutable
class DecorateData {
  const DecorateData({
    required this.colors,
    this.backgroundColor,
    double? strokeWidth,
    this.pathBackgroundColor,
    required this.pause,
  })  : _strokeWidth = strokeWidth,
        assert(colors.length > 0);
  final Color? backgroundColor;

  /// It will promise at least one value in the collection.
  final List<Color> colors;
  final double? _strokeWidth;

  /// Applicable to which has cut edge of the shape
  final Color? pathBackgroundColor;

  /// Animation status, true will pause the animation
  final bool pause;

  double get strokeWidth => _strokeWidth ?? _kDefaultStrokeWidth;

  Function get _deepEq => const DeepCollectionEquality().equals;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DecorateData &&
          runtimeType == other.runtimeType &&
          backgroundColor == other.backgroundColor &&
          _deepEq(colors, other.colors) &&
          _strokeWidth == other._strokeWidth &&
          pathBackgroundColor == other.pathBackgroundColor &&
          pause == other.pause;

  @override
  int get hashCode =>
      backgroundColor.hashCode ^
      colors.hashCode ^
      _strokeWidth.hashCode ^
      pathBackgroundColor.hashCode ^
      pause.hashCode;

  @override
  String toString() {
    return 'DecorateData{backgroundColor: $backgroundColor, colors: $colors, strokeWidth: $_strokeWidth, pathBackgroundColor: $pathBackgroundColor, pause: $pause}';
  }
}

/// Establishes a subtree in which decorate queries resolve to the given data.
class DecorateContext extends InheritedWidget {
  const DecorateContext({
    super.key,
    required this.decorateData,
    required super.child,
  });
  final DecorateData decorateData;

  @override
  bool updateShouldNotify(DecorateContext oldWidget) =>
      oldWidget.decorateData != decorateData;

  static DecorateContext? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }
}

const double _kMinIndicatorSize = 36.0;

/// Wrapper class for basic shape.
class IndicatorShapeWidget extends StatelessWidget {
  const IndicatorShapeWidget({
    super.key,
    this.data,
    this.index = 0,
  });
  final double? data;

  /// The index of shape in the widget.
  final int index;

  @override
  Widget build(BuildContext context) {
    final DecorateData decorateData = DecorateContext.of(context)!.decorateData;
    final color = decorateData.colors[index % decorateData.colors.length];

    return Container(
      constraints: const BoxConstraints(
        minWidth: _kMinIndicatorSize,
        minHeight: _kMinIndicatorSize,
      ),
      child: CustomPaint(
        painter: _ShapePainter(
          color,
          data,
          decorateData.strokeWidth,
          pathColor: decorateData.pathBackgroundColor,
        ),
      ),
    );
  }
}

class _ShapePainter extends CustomPainter {
  _ShapePainter(
    this.color,
    this.data,
    this.strokeWidth, {
    this.pathColor,
  })  : _paint = Paint()..isAntiAlias = true,
        super();
  final Color color;
  final Paint _paint;
  final double? data;
  final double strokeWidth;
  final Color? pathColor;

  @override
  void paint(Canvas canvas, Size size) {
    _paint
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.shortestSide / 2,
      _paint,
    );
  }

  @override
  bool shouldRepaint(_ShapePainter oldDelegate) =>
      color != oldDelegate.color ||
      data != oldDelegate.data ||
      strokeWidth != oldDelegate.strokeWidth ||
      pathColor != oldDelegate.pathColor;
}

/// BallScaleMultiple.
class BallScaleMultiple extends StatefulWidget {
  const BallScaleMultiple({super.key});

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
    super.initState();
    for (int i = 0; i < 3; i++) {
      _animationControllers.add(AnimationController(
        value: _delayInMills[i] / _durationInMills,
        vsync: this,
        duration: const Duration(milliseconds: _durationInMills),
      ));

      _scaleAnimations.add(Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _animationControllers[i], curve: Curves.linear)));
      _opacityAnimations.add(TweenSequence([
        TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 5),
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 95),
      ]).animate(CurvedAnimation(
          parent: _animationControllers[i], curve: Curves.linear)));

      _animationControllers[i].repeat();
    }
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

mixin IndicatorController<T extends StatefulWidget> on State<T> {
  bool isPaused = false;

  List<AnimationController> get animationControllers;

  @override
  void activate() {
    super.activate();
    _initAnimState();
  }

  void _initAnimState() {
    final DecorateData decorateData = DecorateContext.of(context)!.decorateData;
    isPaused = decorateData.pause;
  }

  @override
  void didChangeDependencies() {
    final DecorateData decorateData = DecorateContext.of(context)!.decorateData;
    if (decorateData.pause != isPaused) {
      isPaused = decorateData.pause;
      if (decorateData.pause) {
        for (final element in animationControllers) {
          element.stop(canceled: false);
        }
      } else {
        for (final element in animationControllers) {
          element.repeat();
        }
      }
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    for (final element in animationControllers) {
      element.dispose();
    }
    super.dispose();
  }
}
