import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../data/models/store_location/store_location.dart';
import '../../../../../../data/models/store_user/store_user.dart';
import '../../../../../../data/remote/firestore_client.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../../../gen/colors.gen.dart';
import '../../../../../../global/global.dart';
import '../../../../../../shared/extension/context_extension.dart';
import '../../places/history_place.dart';
import '../../show_bottom_sheet_home.dart';

class ItemMember extends StatelessWidget {
  const ItemMember({super.key, required this.isAdmin, required this.idUser});

  final bool isAdmin;
  final String idUser;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        showAppModalBottomSheet(
          context: context,
          builder: (context) => HistoryPlace(idUser: idUser),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 12),
        child: FutureBuilder<StoreUser?>(
            future: FirestoreClient.instance.getUser(idUser),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                final StoreUser user = snapshot.data!;
                return Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.r),
                      child: Image.asset(
                        user.avatarUrl,
                        width: 40.r,
                        height: 40.r,
                      ),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                user.userName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              8.w.horizontalSpace,
                              if (isAdmin ||
                                  idUser == Global.instance.user?.code)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 2),
                                  decoration: BoxDecoration(
                                      color: const Color(0xffEADDFF),
                                      borderRadius:
                                          BorderRadius.circular(10.r)),
                                  child: Text(
                                    idUser == Global.instance.user?.code
                                        ? 'you'
                                        : context.l10n.admin,
                                    style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                            ],
                          ),
                          7.h.verticalSpace,
                          Row(
                            children: [
                              Assets.icons.icShareLocation.svg(width: 16.r),
                              4.w.horizontalSpace,
                              Expanded(
                                child: StreamBuilder<
                                        DocumentSnapshot<Map<String, dynamic>>>(
                                    stream: FirestoreClient.instance
                                        .listenLocationUser(idUser),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData &&
                                          snapshot.data != null) {
                                        final StoreLocation location =
                                            StoreLocation.fromJson(
                                                snapshot.data!.data()!);
                                        return Text(
                                          location.address,
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              color: const Color(0xff6C6C6C),
                                              overflow: TextOverflow.ellipsis),
                                        );
                                      }
                                      return const SizedBox();
                                    }),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Transform.rotate(
                        angle: pi,
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 20.r,
                          color: MyColors.primary,
                        ),
                      ),
                    )
                  ],
                );
              }
              return const SizedBox();
            }),
      ),
    );
  }
}
