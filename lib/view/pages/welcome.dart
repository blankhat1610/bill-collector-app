import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  final String? customer;

  Welcome({Key? key, required this.customer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Provider.of<CustomerProvider>(context).setCustomer(customer);
    print("-------------Welcome page --------" + customer.toString());
    return Scaffold(
      body: Container(
        child: Center(
          child: Text("WELCOME PAGE"),
        ),
      ),
    );
  }
}
