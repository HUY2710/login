import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/store_message/store_message.dart';
import '../../../data/remote/collection_store.dart';
import '../../../gen/gens.dart';
import '../../../global/global.dart';
import '../../../shared/helpers/logger_utils.dart';
import '../../../shared/widgets/custom_inkwell.dart';
import 'chat_service.dart';

@RoutePage()
class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final List<MessageModel> result = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 30.w,
        leading: CustomInkWell(
            child: Assets.icons.iconBack.svg(width: 28.r),
            onTap: () => context.popRoute()),
        centerTitle: true,
        title: Text(
          'Messages',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: StreamBuilder(
            stream: ChatService.instance
                .streamMessageGroup('3pj9HcOMuVG5q0bDWgeOlzSt'),
            builder: (context, snapshot) {
              logger.d('ádasdasdasd');
              if (snapshot.hasData) {
                return ListView(
                  children: snapshot.data!.docs.map((e) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          constraints: BoxConstraints(maxWidth: 1.sw * 0.7),
                          margin: EdgeInsets.symmetric(vertical: 2.h),
                          padding: EdgeInsets.symmetric(
                              vertical: 8.h, horizontal: 12.w),
                          decoration: BoxDecoration(
                              // borderRadius: BorderRadius.circular(15.r),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15.r),
                                  topRight: Radius.circular(15.r),
                                  bottomLeft: Radius.circular(15.r)),
                              color: const Color(0xffB98EFF)),
                          child: Text(
                            e.data().content,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.sp,
                                letterSpacing: -0.4),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                );
              }
              return SizedBox();
            }),
      ),
      floatingActionButton: IconButton(
          onPressed: () async {
            CollectionStore.chat
                .doc('3pj9HcOMuVG5q0bDWgeOlzSt')
                .collection(CollectionStoreConstant.messages)
                .add(MessageModel(
                        content:
                            'Hello 0aksjdhaksdh kahsdkjashdka aksd aksjdhakjsdh kjahsd kajsd jahsdka sdj ajshdkaj jhsakdjh 97',
                        senderId: Global.instance.user!.code,
                        sentAt: DateTime.now().toString())
                    .toJson());
          },
          icon: Icon(Icons.aspect_ratio)),
    );
  }
}
