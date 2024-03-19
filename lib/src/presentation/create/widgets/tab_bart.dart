import 'package:flutter/material.dart';

import '../../../shared/widgets/custom_tab_bar.dart';
import '../cubit/code_type_cubit.dart';

class BuildTabBar extends StatefulWidget {
  const BuildTabBar({super.key, required this.codeTypeCubit});

  final CodeTypeCubit codeTypeCubit;

  @override
  State<BuildTabBar> createState() => _BuildTabBarState();
}

class _BuildTabBarState extends State<BuildTabBar>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTabBar(
      cubit: widget.codeTypeCubit,
    );
  }
}
