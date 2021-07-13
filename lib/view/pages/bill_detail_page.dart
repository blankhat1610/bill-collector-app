import 'package:bill_app/model/core/bill.dart';
import 'package:bill_app/view/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BillDetail extends StatefulWidget {
  final Bill? bill;
  BillDetail({required this.bill});

  @override
  _BillDetailState createState() => _BillDetailState();
}

class _BillDetailState extends State<BillDetail> {
  @override
  Widget build(BuildContext context) {
    NumberFormat numberFormat = NumberFormat.currency(locale: 'vi');
    Widget _billWidget(bill) {
      return SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TitleText(
                text: "${bill?.storeName} store",
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          SizedBox(height: 10),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: bill.billDetail.length,
            itemBuilder: (context, index) {
              return ListTile(
                dense: true,
                title: TitleText(
                  text: bill.billDetail[index].name,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                subtitle: TitleText(
                  text: bill.billDetail[index].price.toString(),
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                leading: TitleText(
                  text: bill.billDetail[index].amount.toString(),
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                trailing: TitleText(
                  text: numberFormat
                      .format(int.parse(bill.billDetail[index].total)),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          ),
          SizedBox(height: 10),
          ListTile(
            title: TitleText(
              text: 'Total',
            ),
            trailing: TitleText(
              text: numberFormat.format(int.parse(bill.total)),
            ),
          ),
        ]),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: TitleText(
          text: 'Bill Detail',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      //passing in the ListView.builder
      body: _billWidget(widget.bill),
      // bottomNavigationBar: _buildBottomBar(),
    );
  }
}
