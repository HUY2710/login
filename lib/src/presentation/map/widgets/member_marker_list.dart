import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/store_user/store_user.dart';
import '../cubit/tracking_members/tracking_member_cubit.dart';
import '../models/member_maker_data.dart';
import 'member_marker.dart';

class MemberMarkerList extends StatefulWidget {
  const MemberMarkerList({
    super.key,
    required this.trackingMemberCubit,
  });

  final TrackingMemberCubit trackingMemberCubit;

  @override
  State<MemberMarkerList> createState() => _MemberMarkerListState();
}

class _MemberMarkerListState extends State<MemberMarkerList> {
  final StreamController<MemberMarkerData> _streamController =
      StreamController();

  @override
  void initState() {
    // widget.trackingMemberCubit.generateUserMarker(_streamController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrackingMemberCubit, TrackingMemberState>(
      bloc: widget.trackingMemberCubit,
      builder: (BuildContext context, TrackingMemberState state) {
        return state.maybeWhen(
          orElse: () => const SizedBox(),
          success: (List<StoreUser> users) {
            return Stack(
              children: users.map((StoreUser member) {
                return BuildMarker(
                  keyCap: GlobalKey(),
                  key: UniqueKey(),
                  streamController: _streamController,
                  member: member,
                  index: users.indexOf(member),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }
}
