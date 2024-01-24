import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    super.key,
    this.gradient,
    this.style,
  });

  final String text;
  final TextStyle? style;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) {
        final temp = gradient ??
            const LinearGradient(colors: [
              Color(0xffB67DFF),
              Color(0xff7B3EFF),
            ]);
        return temp.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        );
      },
      child: Text(text, style: style),
    );
  }
}

class GradientSvg extends StatelessWidget {
  const GradientSvg(
    this.svg, {
    super.key,
    this.gradient,
    this.style,
  });

  final SvgPicture svg;
  final TextStyle? style;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) {
        final temp = gradient ??
            const LinearGradient(colors: [
              Color(0xffB67DFF),
              Color(0xff7B3EFF),
            ]);
        return temp.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        );
      },
      child: svg,
    );
  }
}
