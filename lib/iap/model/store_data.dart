import 'package:in_app_purchase/in_app_purchase.dart';

class StoreData {
  StoreData(
      {this.notFoundIds,
      this.products,
      this.purchases,
      this.consumables,
      this.queryProductError});

  List<String>? notFoundIds;
  List<ProductDetails>? products;
  List<PurchaseDetails>? purchases;
  List<String>? consumables;
  String? queryProductError;
}
