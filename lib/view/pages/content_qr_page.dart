import 'dart:convert';

import 'package:bill_app/model/core/bill.dart';
import 'package:bill_app/model/core/collected_bill.dart';
import 'package:bill_app/model/core/visited_store.dart';
import 'package:bill_app/model/services/app_url.dart';
import 'package:bill_app/themes/light_color.dart';
import 'package:bill_app/view/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class QRContent extends StatefulWidget {
  final String qrContent;
  final int customerId;

  QRContent({required this.qrContent, required this.customerId});

  @override
  _QRContentState createState() => _QRContentState();
}

class _QRContentState extends State<QRContent> {
  late Future<Bill> futureBill;
  List<String> qrValue = [];
  bool isAppValue = false;
  int? visitedStoreId = 0;
  String bill = "null";

  @override
  void initState() {
    super.initState();
    print("${widget.customerId} ======================================");
    _checkQrContent();
    futureBill = getBill(int.parse(qrValue[3]));
    getBill(int.parse(qrValue[3])).then((value) => {
          createVisitedStore(int.parse(qrValue[1]), widget.customerId)
              .then((value) => {createCollectedBill(visitedStoreId, bill)})
        });
  }

  @override
  Widget build(BuildContext context) {
    NumberFormat numberFormat = NumberFormat.currency(locale: 'vi');
    // BillProvider billProvider = Provider.of<BillProvider>(context);

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

    // Widget _notBillWidget(qrContent) {
    //   return Center(
    //     child: TitleText(
    //       text: qrContent,
    //     ),
    //   );
    // }

    return Scaffold(
        appBar: AppBar(
          title: TitleText(
            text: 'QR Content',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        //passing in the ListView.builder
        body: FutureBuilder<Bill>(
          future: futureBill,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _billWidget(snapshot.data);
            } else if (snapshot.hasError) {
              return Center(
                child: Text("${snapshot.error}"),
              );
            }

            // By default, show a loading spinner.
            return Center(
              child: CircularProgressIndicator(
                color: LightColor.black,
              ),
            );
          },
        )
        // bottomNavigationBar: _buildBottomBar(),
        );
  }

  void _checkQrContent() {
    RegExp regex = RegExp(r"\d+", caseSensitive: false, multiLine: false);
    RegExp regexOfApp = RegExp(r"(\w+ STORE.BLANK\d+HAT\d+)",
        caseSensitive: false, multiLine: false);
    if (regexOfApp.hasMatch(widget.qrContent)) {
      print("========================hasMatch");
      List<List> matchesPositions = [];
      for (var match in regex.allMatches(widget.qrContent)) {
        matchesPositions.add([match.start, match.end]);
      }
      qrValue = getValue(matchesPositions, widget.qrContent);
      isAppValue = true;
    }
  }

  List<String> getValue(List<List> matchesPositions, String qrContent) {
    List<String> slices = [];
    int lastPos = 1;
    String plain = qrContent;
    for (var match in matchesPositions) {
      slices.add(plain.substring(lastPos, match[0]));
      slices.add(plain.substring(match[0], match[1]));
      lastPos = match[1];
    }
    return slices;
  }

  Future<Bill> getBill(int billId) async {
    final http.Response response = await http.get(
      Uri.parse("${AppUrl.billApp}/$billId"),
    );

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      bill = response.body.toString();
      return Bill.fromJson(responseData);
    } else {
      throw Exception('Failed to get bill');
    }
  }

  Future createVisitedStore(int? storeId, int? customerId) async {
    final Map<String, dynamic> visitedStoreData = {
      'store_id': storeId,
      'customer_id': customerId
    };
    http.Response response = await http.post(
      Uri.parse(AppUrl.visitedStore),
      body: json.encode(visitedStoreData),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      VisitedStore visitedStore = VisitedStore.fromJson(responseData);
      visitedStoreId = visitedStore.visitedStoreId;
    } else {
      throw Exception('Failed to get create visited Store');
    }
  }

  Future createCollectedBill(int? visitedStoreId, String? billJson) async {
    print(billJson);
    print("============================$visitedStoreId");
    final Map<String, dynamic> billData = {
      'bill_json': billJson,
      'visited_store_id': visitedStoreId
    };

    http.Response response = await http.post(
      Uri.parse(AppUrl.collectedBill),
      body: json.encode(billData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      return CollectedBill.fromJson(responseData);
    } else {
      throw Exception('Failed to get create collected Bill');
    }
  }
}
 // void _getBill(qrValue) async {
  //   final Future<Map<String, dynamic>> getBillMessage =
  //       Provider.of<BillProvider>(context).getBill(int.parse(qrValue[3]));

  //   print("---------------" + qrValue[3]);
  //   getBillMessage.then((response) async {
  //     if (response['status']) {
  //       bill = response['getBill'];
  //       // print("has get bill =============== " + bill.storeName);
  //     } else {
  //       Flushbar(
  //         title: "Failed to get Bill, maybe your connection is off",
  //         message: response['message'].toString(),
  //         duration: Duration(seconds: 3),
  //       ).show(context);
  //     }
  //   });
  // }



    // void _createBill(int? visitedStoreId, String jsonBill) {
    //   final Future<Map<String, dynamic>> createBillMessage =
    //       billProvider.createBill(visitedStoreId, jsonBill);

    //   createBillMessage.then((response) async {
    //     if (response['status']) {
    //       Navigator.pop(context);
    //     } else {
    //       Flushbar(
    //         title: "Failed Create Bill",
    //         message: response['message'].toString(),
    //         duration: Duration(seconds: 3),
    //       ).show(context);
    //     }
    //   });
    // }

    // void _saveBill(bill, customer) {
    //   final Future<Map<String, dynamic>> getVisitedStoreMessage =
    //       billProvider.findOneVisitedStore(bill.storeId);

    //   getVisitedStoreMessage.then((response) async {
    //     if (response['status']) {
    //       VisitedStore visitedStore = response['findOneVisitedStore'];
    //       print(
    //           'visitedId: ${visitedStore.visitedStoreId} is store: ${bill.storeId} bill content is: ${widget.qrContent}');
    //       _createBill(visitedStore.visitedStoreId, widget.qrContent);
    //     } else {
    //       // create a new Visited Store
    //       final Future<Map<String, dynamic>> createVisitedStoreMessage =
    //           billProvider.createVisitedStore(
    //               bill.storeId, customer.customerId);

    //       createVisitedStoreMessage.then((response) async {
    //         if (response['status']) {
    //           _saveBill(bill, customer);
    //         } else {
    //           Flushbar(
    //             title: "Failed Create Visited Store",
    //             message: response['message']['message'].toString(),
    //             duration: Duration(seconds: 3),
    //           ).show(context);
    //         }
    //       });
    //     }
    //   });
    // }

    // Widget _buildBottomBar() {
    //   return Row(children: [
    //     Expanded(
    //       child: Container(
    //         height: 60.0,
    //         child: Consumer<CustomerProvider>(
    //           builder: (context, value, child) => RaisedButton(
    //             shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(0.0),
    //                 side: BorderSide(color: Color.fromRGBO(0, 0, 0, 1))),
    //             onPressed: () {
    //               _saveBill(bill, value.customer);
    //             },
    //             padding: EdgeInsets.all(10.0),
    //             color: Color.fromRGBO(0, 0, 0, 1),
    //             textColor: Colors.black,
    //             child: TitleText(
    //               text: "Save",
    //               fontSize: 16,
    //               color: LightColor.background,
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //     Expanded(
    //       child: Container(
    //         height: 60.0,
    //         child: RaisedButton(
    //           shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(0.0),
    //               side: BorderSide(color: Color.fromRGBO(0, 0, 0, 1))),
    //           onPressed: () {
    //             Navigator.pop(context);
    //           },
    //           padding: EdgeInsets.all(10.0),
    //           color: Colors.white,
    //           // textColor: Color.fromRGBO(255, 255, 255, 1),
    //           child: TitleText(
    //             text: "Cancel",
    //             fontSize: 16,
    //           ),
    //         ),
    //       ),
    //     ),
    //   ]);
    // }
