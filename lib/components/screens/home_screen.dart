import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:my_video_log/components/dialog/alert_dialog.dart';
import 'package:my_video_log/components/tabs/calender_view_tab.dart';
import 'package:my_video_log/components/tabs/camera_home_screen.dart';
import 'package:my_video_log/components/tabs/settings_tab.dart';
import 'package:get_it/get_it.dart';
import 'package:my_video_log/service/purchase_service.dart';

final sl = GetIt.instance;

class HomeScreen extends StatefulWidget {
  static String id = "home_screen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {

  late StreamSubscription<dynamic> _subscription;

  final _sl = GetIt.I;

  late PurchaseService purchaseService;

  @override
  void initState() {
    purchaseService = _sl.get<PurchaseService>();
    final Stream purchaseUpdated =
        InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });

    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: DefaultTabController(

        length: 3,

        child: Scaffold(
          appBar: AppBar(
            title: const Text("My Vide Logs",),
            centerTitle: true,
            automaticallyImplyLeading: false,

          ),
          bottomNavigationBar: menu(context),
          body: const TabBarView(
            // physics: NeverScrollableScrollPhysics(),
            children: [
              CameraTab(),
              CalenderViewTab(),
              SettingsTab(),
            ],
          ),

        ),
      ),
    );
  }

  Widget menu(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: const TabBar(
        // labelColor: Colors.white,
        // unselectedLabelColor: Colors.white70,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.all(5.0),
        // indicatorColor: Colors.blue,
        tabs: [
          Tab(
            text: "New Video",
            icon: Icon(Icons.camera_alt),
          ),
          Tab(
            text: "My Videos",
            icon: Icon(Icons.calendar_month),
          ),
          Tab(
            text: "Settings",
            icon: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }

  void listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailList) async {
    for (var purchaseDetails in purchaseDetailList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        _showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          _handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          bool valid = await purchaseService.verifyPurchase(purchaseDetails);
          if (valid) {
            purchaseService.deliverProduct(purchaseDetails);
          } else {
            purchaseService.handleInvalidPurchase(purchaseDetails);
          }
        } else {
          _handleError(purchaseDetails.error);
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance
              .completePurchase(purchaseDetails);
        }
      }
    }
  }

  _showPendingUI() {
    showMyDialog(context, 'Your transaction is pending, please wait.');
  }

  _handleError(IAPError? error) {

    showMyDialog(context, 'Failed to process your payment, please try again.');
  }


}
