import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:get_it/get_it.dart';
import 'package:my_video_log/service/remote_service.dart';

class PurchaseService {
  final _sl = GetIt.I;

  completePurchase(PurchaseDetails purchaseDetails) async {
    await InAppPurchase.instance.completePurchase(purchaseDetails);
  }

  verifyPurchase(PurchaseDetails purchaseDetails) {
    return true;
  }

  deliverProduct(PurchaseDetails purchaseDetails) {
    _sl.get<RemoteService>().upgradeUserPlan({
      'purchaseId': purchaseDetails.purchaseID ?? '',
      'productId': purchaseDetails.productID,
      'transactionDate': purchaseDetails.transactionDate ?? '',
      'pending': purchaseDetails.pendingCompletePurchase? 'true': 'false',
      'status': purchaseDetails.status.name,
      'source': purchaseDetails.verificationData.source,
      'serverVerificationData': purchaseDetails.verificationData.serverVerificationData,
      'localVerificationData': purchaseDetails.verificationData.localVerificationData
    });

  }

  handleInvalidPurchase(PurchaseDetails purchaseDetails) {

  }

  void restorePurchases() async {
    await InAppPurchase.instance.restorePurchases();
  }

  void purchaseProduct(ProductDetails productDetails) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
    if(_isConsumable(productDetails)) {
      InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam);
    } else {
      InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam);
    }
  }

  bool _isConsumable(ProductDetails productDetails) {
    return false;
  }

  Future<List<ProductDetails>> loadProducts() async {
    final available = await InAppPurchase.instance.isAvailable();
    if(available) {
      const Set<String> _kIds = <String>{'android.test.refunded'};
      final ProductDetailsResponse resp =
      await InAppPurchase.instance.queryProductDetails(_kIds);

      purchaseProduct(resp.productDetails[0]);

      return resp.productDetails;
    } else {
      return [];
    }
  }
}