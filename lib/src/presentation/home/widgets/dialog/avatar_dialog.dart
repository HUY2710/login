import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../data/local/avatar/avatar_repository.dart';
import '../../../../data/models/avatar/avatar_model.dart';
import '../../../../shared/cubit/value_cubit.dart';

class AvatarDialog extends StatelessWidget {
  const AvatarDialog({
    super.key,
    required this.title,
    required this.confirmText,
    this.cancelText,
    required this.confirmTap,
    this.cancel,
    this.isAvatarGroup = true,
    required this.avatarCubit,
  });
  final String title;
  final String confirmText;
  final String? cancelText;
  final VoidCallback confirmTap;
  final VoidCallback? cancel;
  final bool isAvatarGroup;
  final ValueCubit<String> avatarCubit;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('GridView Inside AlertDialog'),
      content: SizedBox(
        width: double.maxFinite,
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10.h,
            mainAxisSpacing: 10.w,
          ),
          itemCount: groupAvatarList.length,
          itemBuilder: (context, index) {
            return _buildAvatarItem(groupAvatarList[index], avatarCubit);
          },
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }

  BlocBuilder _buildAvatarItem(
      AvatarModel avatarModel, ValueCubit<String> avatarGroupCubit) {
    return BlocBuilder<ValueCubit<String>, String>(
      bloc: avatarGroupCubit,
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            avatarGroupCubit.update(avatarModel.avatarPath);
          },
          child: Container(
            foregroundDecoration: BoxDecoration(
              border: avatarModel.avatarPath == state
                  ? Border.all(
                      color: const Color(0xFF7B3EFF),
                      width: 2.w,
                    )
                  : null,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Image.asset(
                avatarModel.avatarPath,
              ),
            ),
          ),
        );
      },
    );
  }
}
