import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../data/models/store_group/store_group.dart';
import '../../../../../shared/cubit/value_cubit.dart';
import '../../../../../shared/widgets/my_drag.dart';
import '../show_bottom_sheet_home.dart';
import 'add_places_bottom_sheet.dart';
import 'widgets/item_place.dart';

class PlacesBottomSheet extends StatefulWidget {
  const PlacesBottomSheet({super.key});

  @override
  State<PlacesBottomSheet> createState() => _PlacesBottomSheetState();
}

class _PlacesBottomSheetState extends State<PlacesBottomSheet> {
  final ValueCubit<String> pathAvatarCubit = ValueCubit('');
  final TextEditingController groupNameController = TextEditingController();
  StoreGroup? tempGroup;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20).r,
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MyDrag(),
          TextButton(
              onPressed: () {
                showAppModalBottomSheet(
                  context: context,
                  builder: (context) => const AddPlaceBottomSheet(),
                );
              },
              child: const Text('Add Place')),
          Row(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Align(
                      child: Text(
                        'Places',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20.sp,
                          color: const Color(0xff343434),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => context.popRoute(),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.sp,
                            color: const Color(0xff8E52FF),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Done',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp,
                            color: groupNameController.text.isNotEmpty
                                ? const Color(0xff8E52FF)
                                : const Color(0xffABABAB),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Expanded(
              child: ListView.separated(
            itemCount: 10,
            itemBuilder: (context, index) {
              return const ItemPlace();
            },
            separatorBuilder: (context, index) => SizedBox(height: 28.h),
          ))
        ],
      ),
    );
  }
}
