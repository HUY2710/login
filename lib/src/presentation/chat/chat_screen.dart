import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../shared/extension/context_extension.dart';
import '../../shared/widgets/custom_inkwell.dart';

@RoutePage()
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomInkWell(
            child: SvgPicture.asset(
              'assets/icons/icon_back.svg',
              width: 28.r,
            ),
            onTap: () => context.popRoute()),
        centerTitle: true,
        title: Text(
          'Messages',
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
