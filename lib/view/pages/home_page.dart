import 'package:bill_app/global/constants.dart';
import 'package:bill_app/model/core/bill.dart';
import 'package:bill_app/model/core/collected_bill.dart';
import 'package:bill_app/model/core/customer.dart';
import 'package:bill_app/provider/bill_provider.dart';
import 'package:bill_app/themes/light_color.dart';
import 'package:bill_app/view/widgets/appbar.dart';
import 'package:bill_app/view/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:vibration/vibration.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.customer}) : super(key: key);
  final Customer? customer;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Bill? bill;
  var billJsonDecoded;
  Future<List<CollectedBill>>? _allBill;

  @override
  void initState() {
    super.initState();
    _allBill = BillProvider.fetchBill(widget.customer?.customerId);
  }

  Future<void> scanQR() async {
    try {
      FlutterBarcodeScanner.scanBarcode('#2A99CF', "Cancle", true, ScanMode.QR)
          .then((value) {
        print("----------------Value of scanQR------------------");
        print("value: " + value);
        if (value != '-1') {
          Vibration.vibrate();
          Navigator.pushNamed(context, qrRoute,
              arguments: [value, widget.customer?.customerId]);
        }
      });
    } catch (e) {
      print('-------------Error in scanQR method---------------');
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    ListTile _tile(int collectedBillId, int visitedStoreId, String createdAt,
            Bill? bill) =>
        ListTile(
          tileColor: LightColor.background,
          contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          leading: TitleText(
            text: "$collectedBillId",
          ),
          title: TitleText(
            text: "${bill?.storeName} Store",
          ),
          subtitle: TitleText(
            text: createdAt,
            fontWeight: FontWeight.normal,
          ),
          trailing: Icon(Icons.keyboard_arrow_right, size: 30.0),
          onTap: () {
            Navigator.pushNamed(context, billDetailRoute, arguments: bill);
          },
        );

    ListView _billListView(data) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          billJsonDecoded =
              json.decode(data[index].billJson) as Map<String, dynamic>;
          bill = Bill.fromJson(billJsonDecoded);
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 2,
            margin: new EdgeInsets.symmetric(horizontal: 6.0, vertical: 3),
            child: Container(
              // decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
              child: _tile(data[index].collectedBillId,
                  data[index].visitedStoreId, data[index].createdAt, bill),
            ),
          );
        },
      );
    }

    Widget _buildBody() {
      return FutureBuilder<List<CollectedBill>>(
        future: _allBill,
        builder: (context, AsyncSnapshot<List<CollectedBill>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: LightColor.black,
              ),
            );
          } else {
            if (snapshot.data?.length == 0)
              return RefreshIndicator(
                  child: Center(
                    child: FlatButton(
                      padding: EdgeInsets.only(left: 0.0),
                      child: TitleText(
                        text: "Not have any scanned bill yet",
                      ),
                      onPressed: () {
                        _pullRefresh();
                      },
                    ),
                  ),
                  onRefresh: _pullRefresh);
            List<CollectedBill>? data = snapshot.data;
            return RefreshIndicator(
                child: _billListView(data), onRefresh: _pullRefresh);
            //This should be the desire widget you want the user to see
          }
        },
      );
    }

    return Scaffold(
      appBar: BaseAppBar(
        backgroundColor: LightColor.background,
        appBar: AppBar(
          leading: null,
        ),
        title: TitleText(
          text: 'Bill Collector',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        widgets: <Widget>[
          IconButton(
            icon: (Icon(Icons.qr_code_rounded)),
            onPressed: () => scanQR(),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Future<void> _pullRefresh() async {
    List<CollectedBill> freshCollectedBill =
        await BillProvider.fetchBill(widget.customer?.customerId);
    setState(() {
      _allBill = Future.value(freshCollectedBill);
    });
  }
}
