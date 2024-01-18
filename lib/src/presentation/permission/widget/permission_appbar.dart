part of '../permission_screen.dart';

class PermissionAppbar extends AppBar {
  PermissionAppbar(
    this.context, {
    super.key,
    this.onActionTapped,
  });

  final BuildContext context;
  final VoidCallback? onActionTapped;

  @override
  Widget? get title => Text(
        'context.l10n.permission',
        style: TextStyle(
          fontSize: 24.sp,
        ),
      );

  @override
  bool? get centerTitle => true;

  @override
  double? get toolbarHeight => 100.h;

  @override
  Size get preferredSize => Size.fromHeight(100.h);

  @override
  List<Widget>? get actions => [
        TextButton(
          onPressed: onActionTapped,
          child: const Text(
            'context.l10n.go',
          ),
        ),
      ];
}
