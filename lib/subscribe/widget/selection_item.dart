import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SelectionItem extends StatelessWidget {
  const SelectionItem(
      {super.key,
      required this.data,
      this.isSelected = false,
      this.isRecommend = false,
      required this.onTap});

  final ProductDetails data;
  final bool isSelected;
  final bool isRecommend;
  final Function() onTap;

  final double _borderRadius = 5;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          if (isRecommend) const RecommendChip() else const SizedBox(),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xfff5f5f5),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(_borderRadius),
                  bottomRight: Radius.circular(_borderRadius),
                  topLeft: Radius.circular(_borderRadius),
                  topRight: isRecommend
                      ? Radius.zero
                      : Radius.circular(_borderRadius)),
              border: isSelected
                  ? Border.all(color: Colors.indigoAccent)
                  : Border.all(color: Colors.white),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(data.title),
                  Text(
                    '\$ ${data.price}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.indigoAccent),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecommendChip extends StatelessWidget {
  const RecommendChip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        decoration: const BoxDecoration(
            color: Colors.indigoAccent,
            borderRadius: BorderRadius.vertical(top: Radius.circular(5))),
        child: const Text(
          'Recommended',
          style: TextStyle(fontSize: 10, color: Colors.white),
        ),
      ),
    );
  }
}
