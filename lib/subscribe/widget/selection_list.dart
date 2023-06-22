import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/subscribe_cubit.dart';
import '../model/choice.dart';
import 'selection_item.dart';

class SelectionList extends StatefulWidget {
  const SelectionList({super.key});

  @override
  State<SelectionList> createState() => _SelectionListState();
}

class _SelectionListState extends State<SelectionList> {
  late SubscribeCubit cubit = SubscribeCubit(2);

  List<Choice> choiceList = <Choice>[
    Choice('Weekly', 3.99),
    Choice('Monthly', 9.99),
    Choice('LifeTime', 29.99),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscribeCubit, int>(
      bloc: cubit,
      builder: (BuildContext context, int state) {
        return ListView.separated(
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) => SelectionItem(
                  onTap: () => cubit.select(index),
                  data: choiceList[index],
                  isSelected: state == index,
                  isRecommend: index == 2,
                ),
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(
                  height: 20,
                ),
            itemCount: choiceList.length);
      },
    );
  }
}
