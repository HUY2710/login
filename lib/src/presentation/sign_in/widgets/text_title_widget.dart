import 'package:flutter/material.dart';

import '../../../shared/constants/app_text_style.dart';


class TextTitleWidget extends StatelessWidget {
  const TextTitleWidget({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyle.s24w700,
    );
  }
}
