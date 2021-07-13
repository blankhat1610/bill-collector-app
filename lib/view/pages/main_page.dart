import 'package:bill_app/model/core/customer.dart';
import 'package:bill_app/provider/bill_provider.dart';
import 'package:bill_app/provider/function.dart';
import 'package:bill_app/themes/light_color.dart';
import 'package:bill_app/themes/theme.dart';
import 'package:bill_app/view/pages/home_page.dart';
import 'package:bill_app/view/pages/profile_page.dart';
import 'package:bill_app/view/pages/receipt_page.dart';
import 'package:bill_app/view/pages/store_page.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, this.customer}) : super(key: key);
  final Customer? customer;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  // Customer _customer;
  late List<Widget> _children;

  Widget _buildBottomNavigationBar() {
    return Consumer<GlobalFunction>(
      builder: (context, function, child) => CustomNavigationBar(
        iconSize: 28.0,
        selectedColor: LightColor.black,
        strokeColor: LightColor.darkgrey,
        unSelectedColor: LightColor.darkgrey,
        backgroundColor: AppTheme.lightTheme.backgroundColor,
        items: [
          CustomNavigationBarItem(
            icon: const Icon(Icons.home_rounded),
          ),
          // CustomNavigationBarItem(
          //   icon: const Icon(Icons.store_rounded),
          // ),
          // CustomNavigationBarItem(
          //   icon: const Icon(Icons.receipt_rounded),
          // ),
          CustomNavigationBarItem(
            icon: const Icon(Icons.account_circle_rounded),
          ),
        ],
        currentIndex: function.currentPage,
        onTap: (index) {
          function.changePage = index;
        },
      ),
    );
  }

  @override
  void initState() {
    print('============mainpage_customer=========${widget.customer!.token}');
    _children = [
      HomePage(customer: widget.customer),
      ProfilePage(customer: widget.customer),
      StorePage(customer: widget.customer),
      ReceiptPage(customer: widget.customer),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("========mainpage: ${widget.customer!.name}");
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GlobalFunction()),
      ],
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.backgroundColor,
        body: Consumer<GlobalFunction>(
          builder: (context, function, child) => IndexedStack(
            index: function.currentPage,
            children: _children,
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }
}
