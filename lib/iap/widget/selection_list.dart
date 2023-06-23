import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../cubit/product_selection_cubit.dart';
import 'selection_item.dart';

class SelectionList extends StatefulWidget {
  const SelectionList({super.key, required this.products});

  final List<ProductDetails> products;

  @override
  State<SelectionList> createState() => _SelectionListState();
}

class _SelectionListState extends State<SelectionList> {
  late ProductSelectionCubit cubit = ProductSelectionCubit(0);
  late List<ProductDetails> _products;

  @override
  void initState() {
    _products = widget.products;
    if (widget.products.isEmpty) {
      _products = [
        ProductDetails(
            id: '1',
            title: 'Weekly',
            description: 'description',
            price: '3.99',
            rawPrice: 3.99,
            currencyCode: 'currencyCode'),
        ProductDetails(
            id: '2',
            title: 'Monthly',
            description: 'description',
            price: '9.99',
            rawPrice: 9.99,
            currencyCode: 'currencyCode'),
        ProductDetails(
            id: '3',
            title: 'LifeTime',
            description: 'description',
            price: '29.99',
            rawPrice: 29.99,
            currencyCode: 'currencyCode'),
      ];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductSelectionCubit, int>(
      bloc: cubit,
      builder: (BuildContext context, int state) {
        return ListView.separated(
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) => SelectionItem(
                  onTap: () => cubit.select(index),
                  data: _products[index],
                  isSelected: state == index,
                  isRecommend: index == 0,
                ),
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(
                  height: 20,
                ),
            itemCount: _products.length);
      },
    );
  }
}
