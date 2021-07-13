import 'package:bill_app/model/core/customer.dart';
import 'package:bill_app/view/widgets/appbar.dart';
import 'package:bill_app/view/widgets/title_text.dart';
import 'package:flutter/material.dart';

class ReceiptPage extends StatefulWidget {
  const ReceiptPage({Key? key, this.customer}) : super(key: key);
  final Customer? customer;

  @override
  _ReceiptPageState createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        appBar: AppBar(),
        title: TitleText(
          text: 'Search bill',
        ),
        widgets: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
      ),
      body: new Center(
        child: new Text(
          "Don't look at me! Press the search button!",
        ),
      ),
    );
  }
}
