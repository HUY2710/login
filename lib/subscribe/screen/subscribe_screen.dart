import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../cubit/purchase_cubit.dart';
import '../cubit/purchase_state.dart';
import '../model/store_data.dart';
import '../widget/selection_list.dart';

final bool kAutoConsume = Platform.isIOS || true;

const String kConsumableId = 'com.base.consumable';
const String kWeeklyId = 'com.base.weekly';
const String kMonthyId = 'com.base.monthy';
const List<String> kProductIds = <String>[
  kConsumableId,
  kWeeklyId,
  kMonthyId,
];

class SubscribeScreen extends StatefulWidget {
  const SubscribeScreen({super.key});

  @override
  State<SubscribeScreen> createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  late final PurchaseCubit purchaseCubit = PurchaseCubit(_inAppPurchase);

  @override
  void initState() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      purchaseCubit.listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (Object error) {
      // handle error here.
    });
    purchaseCubit.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back)),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 200,
              color: Colors.blue,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Document Files Manager',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            _buildPurchaseCard(),
            const Text(
              'Cancel anytime',
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Terms of service',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const Text(
                    'Privacy policy',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  InkWell(
                    onTap: () => _inAppPurchase.restorePurchases(),
                    child: const Text(
                      'Restore Purchase',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Expanded _buildPurchaseCard() {
    return Expanded(
      child: BlocBuilder<PurchaseCubit, PurchaseState>(
        bloc: purchaseCubit,
        builder: (BuildContext context, PurchaseState state) {
          if (state is PurchaseLoading) {
            return _buildLoading();
          }

          final StoreData? storeData =
              (state as PurchaseSuccess<StoreData>).data;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SelectionList(
                  products: storeData?.products ?? [],
                ),
                const SizedBox(
                  height: 20,
                ),
                FilledButton(
                    onPressed: () {}, child: const Text('SUBSCRIBE NOW'))
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoading() {
    return const Column(children: [CircularProgressIndicator()]);
  }
}
