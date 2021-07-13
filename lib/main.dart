import 'package:bill_app/config/router.dart';
import 'package:bill_app/model/helper/customer_preferences.dart';
import 'package:bill_app/provider/auth_provider.dart';
import 'package:bill_app/provider/bill_provider.dart';
import 'package:bill_app/provider/customer_provider.dart';
import 'package:bill_app/themes/theme.dart';
import 'package:bill_app/view/pages/home_page.dart';
import 'package:bill_app/view/pages/login_page.dart';
import 'package:bill_app/view/pages/main_page.dart';
import 'package:bill_app/view/pages/welcome.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

final getIt = GetIt.instance;

void main() async {
  // final SharedPreferences prefs = await SharedPreferences.getInstance();
  // getIt.registerSingletonAsync(() => SharedPreferences.getInstance());
  getIt.registerSingleton(CustomerPreferences());
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
            create: (_) => CustomerProvider()..getCustomer()),
        ChangeNotifierProvider(create: (_) => BillProvider()),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme.copyWith(
          textTheme: GoogleFonts.mulishTextTheme(
            Theme.of(context).textTheme,
          ),
          scaffoldBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        home: Consumer<CustomerProvider>(
          builder: (context, value, child) {
            if (value.customer?.token == null) {
              print("---------------token null");
              return LoginPage();
            } else if (value.customer?.token != null) {
              // SharedPreferences ko co token => null
              print('------------------ token # null ${value.customer?.token}');
              // CustomerPreferences().removeCustomer();
              return MainPage(customer: value.customer);
            }
            return Welcome(customer: value.customer?.token);
          },
        ),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: CustomRouter.generateRoute,
      ),
    );
  }
}
