part of '../permission_screen.dart';

class PermissionBody extends StatefulWidget {
  const PermissionBody({super.key});

  @override
  State<PermissionBody> createState() => _PermissionContentState();
}

class _PermissionContentState extends State<PermissionBody>
    with WidgetsBindingObserver, PermissionMixin {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _checkPermission();
    super.initState();
  }

  Future<void> _checkPermission() async {
    await _checkStoragePermission();
  }

  Future<void> _checkStoragePermission() async {
    final PermissionStatus status = await checkStoragePermission();
    if (mounted) {
      context
          .read<StoragePermissionCubit>()
          .update(status.isGranted || status.isLimited);
    }
  }

  FutureOr<void> _onStorageSwitchChanged(bool value) async {
    if (value) {
      context.read<NativeAdStatusCubit>().update(false);
      final PermissionStatus status = await requestStoragePermission();
      if (mounted) {
        context
            .read<StoragePermissionCubit>()
            .update(status.isGranted || status.isLimited);
        context.read<NativeAdStatusCubit>().update(true);
      }
    }
  }

  Row _buildItem({
    required String title,
    required ValueCubit<bool> cubit,
    required FutureOr<void> Function(bool value) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        BlocBuilder<ValueCubit<bool>, bool>(
          bloc: cubit,
          builder: (context, state) => CustomSwitch(
            value: state,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20).w,
      child: Column(
        children: [
          SizedBox.square(dimension: 150.r, child: const Placeholder(),),
          Padding(
            padding: const EdgeInsets.all(25).r,
            child: const Text(
              'context.l10n.requirePermission',
              textAlign: TextAlign.center,
            ),
          ),
          _buildItem(
            title: 'context.l10n.mediaAccess',
            cubit: context.read<StoragePermissionCubit>(),
            onChanged: _onStorageSwitchChanged,
          ),
        ],
      ),
    );
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _checkPermission();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
