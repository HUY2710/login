import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_iap/flutter_iap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:injectable/injectable.dart';

import '../../app/cubit/loading_cubit.dart';
import '../../src/config/di/di.dart';
import '../../src/config/navigation/app_router.dart';
import '../../src/data/local/shared_preferences_manager.dart';
import '../../src/shared/extension/context_extension.dart';
import 'product_id.dart';

@singleton
class MyPurchaseManager extends PurchasesManager {
  @override
  Set<String> productIds = <String>{
    productKeyWeekly,
    productKeyMonthly,
  };

  @override
  Future<void> buy(PurchasableProduct product) async {
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: product.productDetails);
    switch (product.id) {
      case productKeyWeekly:
      case productKeyMonthly:
        await iapConnection.buyNonConsumable(purchaseParam: purchaseParam);
        return;
      default:
        throw ArgumentError.value(
            product.productDetails, '${product.id} is not a known product');
    }
  }

  @override
  Future<void> checkLocalPurchase() async {
    if (await SharedPreferencesManager.getIsWeeklyPremium()) {
      await restorePurchases();
    } else if (await SharedPreferencesManager.getIsMonthlyPremium()) {
      await restorePurchases();
    }
  }

  @override
  Future<void> handlePurchaseCanceled(PurchaseDetails purchaseDetails) async {
    // EasyLoading.dismiss();
    hideLoading();
    switch (purchaseDetails.productID) {
      case productKeyWeekly:
        updateStatus(productKeyWeekly, ProductStatus.purchasable);
        SharedPreferencesManager.setIsWeeklyPremium(false);
        break;
      case productKeyMonthly:
        updateStatus(productKeyMonthly, ProductStatus.purchasable);
        SharedPreferencesManager.setIsMonthlyPremium(false);
        break;
      default:
    }
  }

  @override
  Future<void> handlePurchaseError(PurchaseDetails purchaseDetails) async {
    // EasyLoading.dismiss();
    hideLoading();
    await showDialog(
        context: getIt<AppRouter>().navigatorKey.currentContext!,
        builder: (BuildContext ctx) {
          String errorMessage = ctx.l10n.unexpectedError;
          if (purchaseDetails.error?.message ==
              'BillingResponse.itemAlreadyOwned') {
            errorMessage = ctx.l10n.alreadyOwnError;
          }
          return AlertDialog(
            content: Text(
              errorMessage,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  getIt<AppRouter>().pop();
                },
                child: Text(
                  ctx.l10n.confirm,
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          );
        });
    if (purchaseDetails.error?.message != 'BillingResponse.itemAlreadyOwned') {
      getIt<AppRouter>().pop();
    }
  }

  @override
  Future<void> handlePurchasePending(PurchaseDetails purchaseDetails) async {
    // EasyLoading.dismiss();
    // EasyLoading.show();
    hideLoading();
    showLoading();
  }

  @override
  Future<void> handlePurchaseRestored(PurchaseDetails purchaseDetails) async {
    // EasyLoading.dismiss();
    hideLoading();
    final purchaseDate = purchaseDetails.transactionDate != null
        ? DateTime.fromMillisecondsSinceEpoch(
            int.parse(purchaseDetails.transactionDate!))
        : null;
    switch (purchaseDetails.productID) {
      case productKeyWeekly:
        if (purchaseDate == null ||
            DateTime.now()
                .isBefore(purchaseDate.add(const Duration(days: 3)))) {
          updateStatus(productKeyWeekly, ProductStatus.purchased);
          hideAdOpenInstantly();
          SharedPreferencesManager.setIsWeeklyPremium(true);
        }

        break;
      case productKeyMonthly:
        if (purchaseDate == null ||
            DateTime.now()
                .isBefore(purchaseDate.add(const Duration(days: 31)))) {
          updateStatus(productKeyMonthly, ProductStatus.purchased);
          hideAdOpenInstantly();
          SharedPreferencesManager.setIsMonthlyPremium(true);
        }
        break;
      default:
    }
  }

  @override
  Future<void> handlePurchaseSuccess(PurchaseDetails purchaseDetails) async {
    // EasyLoading.dismiss();
    hideLoading();
    // getIt<FirebaseEventService>().logUserPayment(purchaseDetails.productID);
    switch (purchaseDetails.productID) {
      case productKeyWeekly:
        updateStatus(productKeyWeekly, ProductStatus.purchased);
        hideAdOpenInstantly();
        if (await SharedPreferencesManager.getIsWeeklyPremium() != true) {
          SharedPreferencesManager.setIsWeeklyPremium(true);
        }

        break;
      case productKeyMonthly:
        updateStatus(productKeyMonthly, ProductStatus.purchased);
        hideAdOpenInstantly();
        if (await SharedPreferencesManager.getIsMonthlyPremium() != true) {
          SharedPreferencesManager.setIsMonthlyPremium(true);
        }
        break;
    }
  }

  @override
  Future<void> restorePurchases() async {
    // EasyLoading.show();
    showLoading();
    SharedPreferencesManager.setIsWeeklyPremium(false);
    SharedPreferencesManager.setIsMonthlyPremium(false);
    try {
      await iapConnection.restorePurchases();
    } catch (e) {}
    // EasyLoading.dismiss();
    hideLoading();
  }

  void hideAdOpenInstantly() {
    EasyAds.instance.appLifecycleReactor?.setShouldShow(false);
  }
}

extension CheckPremium on PurchaseState {
  bool isPremium() {
    return products.any((PurchasableProduct product) =>
        product.status == ProductStatus.purchased);
  }
}
