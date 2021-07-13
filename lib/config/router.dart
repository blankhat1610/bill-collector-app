import 'package:bill_app/global/constants.dart';
import 'package:bill_app/main.dart';
import 'package:bill_app/model/core/bill.dart';
import 'package:bill_app/view/pages/bill_detail_page.dart';
import 'package:bill_app/view/pages/content_qr_page.dart';
import 'package:bill_app/view/pages/home_page.dart';
import 'package:bill_app/view/pages/login_page.dart';
import 'package:bill_app/view/pages/main_page.dart';
import 'package:bill_app/view/pages/profile_page.dart';
import 'package:bill_app/view/pages/receipt_page.dart';
import 'package:bill_app/view/pages/register_page.dart';
import 'package:bill_app/view/pages/store_page.dart';
import 'package:flutter/material.dart';

class CustomRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case mainRoute:
        return MaterialPageRoute(builder: (_) => MyApp());
      case mainPageRoute:
        return MaterialPageRoute(builder: (_) => MainPage());
      case loginRoute:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case registerRoute:
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case homeRoute:
        return MaterialPageRoute(builder: (_) => HomePage());
      case storeRoute:
        return MaterialPageRoute(builder: (_) => StorePage());
      case receiptRoute:
        return MaterialPageRoute(builder: (_) => ReceiptPage());
      case profileRoute:
        return MaterialPageRoute(builder: (_) => ProfilePage());
      case billDetailRoute:
        return MaterialPageRoute(
            builder: (_) => BillDetail(
                  bill: args as Bill,
                ));
      case qrRoute:
        var arg = args as List;
        return MaterialPageRoute(
            builder: (_) => QRContent(
                  qrContent: arg[0] as String,
                  customerId: arg[1] as int,
                ));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
