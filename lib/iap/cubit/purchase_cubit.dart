import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

import '../../iap/consumable_store.dart';
import '../model/store_data.dart';
import '../screen/purchase_page.dart';
import 'purchase_state.dart';

class PurchaseCubit extends Cubit<PurchaseState> {
  PurchaseCubit(this.inAppPurchase) : super(PurchaseLoading());
  final InAppPurchase inAppPurchase;
  final StoreData _storeData = StoreData();

  Future<void> init() async {
    emit(PurchaseLoading());
    final bool isAvailable = await inAppPurchase.isAvailable();
    if (!isAvailable) {
      _storeData.products = <ProductDetails>[];
      _storeData.purchases = <PurchaseDetails>[];
      _storeData.notFoundIds = <String>[];
      _storeData.consumables = <String>[];
      emit(PurchaseSuccess<StoreData>(_storeData));
      return;
    }

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    final ProductDetailsResponse productDetailResponse =
        await inAppPurchase.queryProductDetails(kProductIds.toSet());
    if (productDetailResponse.error != null) {
      _storeData.queryProductError = productDetailResponse.error!.message;
      _storeData.products = productDetailResponse.productDetails;
      _storeData.purchases = <PurchaseDetails>[];
      _storeData.notFoundIds = productDetailResponse.notFoundIDs;
      _storeData.consumables = <String>[];
      emit(PurchaseSuccess<StoreData>(_storeData));
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      _storeData.queryProductError = null;
      _storeData.products = productDetailResponse.productDetails;
      _storeData.purchases = <PurchaseDetails>[];
      _storeData.notFoundIds = productDetailResponse.notFoundIDs;
      _storeData.consumables = <String>[];
      emit(PurchaseSuccess<StoreData>(_storeData));
      return;
    }

    final List<String> consumables = await ConsumableStore.load();
    _storeData.products = productDetailResponse.productDetails;
    _storeData.notFoundIds = productDetailResponse.notFoundIDs;
    _storeData.consumables = consumables;
    emit(PurchaseSuccess<StoreData>(_storeData));
  }

  Future<void> listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        emit(PurchasePending());
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          emit(PurchaseError(purchaseDetails.error!.message));
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          final bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            unawaited(deliverProduct(purchaseDetails));
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (Platform.isAndroid) {
          if (!kAutoConsume && purchaseDetails.productID == kConsumableId) {
            final InAppPurchaseAndroidPlatformAddition androidAddition =
                inAppPurchase.getPlatformAddition<
                    InAppPurchaseAndroidPlatformAddition>();
            await androidAddition.consumePurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.
    if (purchaseDetails.productID == kConsumableId) {
      await ConsumableStore.save(purchaseDetails.purchaseID!);
      final List<String> consumables = await ConsumableStore.load();
      _storeData.consumables = consumables;
      emit(PurchaseSuccess<StoreData>(_storeData));
    } else {
      _storeData.purchases?.add(purchaseDetails);
      emit(PurchaseSuccess<StoreData>(_storeData));
    }
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }
}

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}