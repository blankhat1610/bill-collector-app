import 'package:bill_app/model/core/customer.dart';
import 'package:bill_app/provider/customer_provider.dart';
import 'package:bill_app/view/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StorePage extends StatefulWidget {
  const StorePage({Key? key, this.customer}) : super(key: key);
  final Customer? customer;

  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {

  @override
  Widget build(BuildContext context) {
    // Provider.of<CustomerProvider>(context).setCustomer(widget.customer);
    // Customer customer = Provider.of<CustomerProvider>(context).customer;
    return Consumer<CustomerProvider>(
      // Chuyen cai getCustomer() vo Provider cung dc cho no tien ko can xai FutureBuilder
      // La chuyen cai CustomerPreferences().getCustomer() vo provider khi nay a
      // Yep
        builder: (context, value, child) {
          return Center(
            child: TitleText(
              text: 'username: ${value.customer?.name}',
            ),
          );
        },
      );
  }
}
