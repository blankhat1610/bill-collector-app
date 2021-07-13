import 'dart:convert';

import 'package:bill_app/model/core/bill.dart';
import 'package:bill_app/model/core/collected_bill.dart';
import 'package:bill_app/model/core/visited_store.dart';
import 'package:bill_app/model/services/app_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BillProvider with ChangeNotifier {
  // Future<Map<String, dynamic>> getBill(int? billId) async {
  //   var result;

  //   http.Response response = await http.get(
  //     Uri.parse("${AppUrl.billApp}/$billId"),
  //   );

  //   if (response.statusCode == 200 && response.body.isNotEmpty) {
  //     final Map<String, dynamic> responseData = json.decode(response.body);
  //     Bill bill = Bill.fromJson(responseData);
  //     notifyListeners();
  //     result = {'status': true, 'message': 'Successful', 'getBill': bill};
  //   } else {
  //     notifyListeners();
  //     result = {
  //       'status': false,
  //       'message': response.body.isNotEmpty
  //           ? json.decode(response.body)['error']
  //           : "Body is empty",
  //     };
  //   }
  //   return result;
  // }

  // Future<Map<String, dynamic>> findOneVisitedStore(int? storeId) async {
  //   var result;

  //   http.Response response = await http.get(
  //     Uri.parse("${AppUrl.visitedStore}/$storeId"),
  //   );

  //   if (response.statusCode == 200 && response.body.isNotEmpty) {
  //     final Map<String, dynamic> responseData = json.decode(response.body);
  //     VisitedStore visitedStore = VisitedStore.fromJson(responseData);
  //     notifyListeners();
  //     result = {
  //       'status': true,
  //       'message': 'Successful',
  //       'findOneVisitedStore': visitedStore
  //     };
  //   } else {
  //     notifyListeners();
  //     result = {
  //       'status': false,
  //       'message': response.body.isNotEmpty
  //           ? json.decode(response.body)['error']
  //           : "Body is empty",
  //     };
  //   }
  //   return result;
  // }

  // Future<Map<String, dynamic>> createVisitedStore(
  //     int? storeId, int? customerId) async {
  //   var result;

  //   final Map<String, dynamic> visitedStoreData = {
  //     'store_id': storeId,
  //     'customer_id': customerId
  //   };

  //   http.Response response = await http.post(
  //     Uri.parse(AppUrl.visitedStore),
  //     body: json.encode(visitedStoreData),
  //     headers: {'Content-Type': 'application/json'},
  //   );

  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> responseData = json.decode(response.body);

  //     // var customerData = responseData['data'];

  //     VisitedStore visitedStore = VisitedStore.fromJson(responseData);
  //     notifyListeners();
  //     result = {
  //       'status': true,
  //       'message': 'Successful',
  //       'visitedStore': visitedStore
  //     };
  //   } else {
  //     notifyListeners();
  //     result = {
  //       'status': false,
  //       'message': response.body.isNotEmpty
  //           ? json.decode(response.body)['error']
  //           : "Body is empty"
  //     };
  //   }
  //   return result;
  // }

  // Future<Map<String, dynamic>> createCollectedBill(
  //     int? visitedStoreId, String? billJson) async {
  //   var result;

  //   final Map<String, dynamic> billData = {
  //     'bill_json': billJson,
  //     'visited_store_id': visitedStoreId
  //   };

  //   http.Response response = await http.post(
  //     Uri.parse(AppUrl.collectedBill),
  //     body: json.encode(billData),
  //     headers: {'Content-Type': 'application/json'},
  //   );

  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> responseData = json.decode(response.body);

  //     // var customerData = responseData['data'];

  //     CollectedBill collectedBill = CollectedBill.fromJson(responseData);
  //     notifyListeners();
  //     result = {
  //       'status': true,
  //       'message': 'Successful',
  //       'collectedBill': collectedBill
  //     };
  //   } else {
  //     notifyListeners();
  //     result = {
  //       'status': false,
  //       'message': response.body.isNotEmpty
  //           ? json.decode(response.body)['error']
  //           : "Body is empty"
  //     };
  //   }
  //   return result;
  // }

  static Future<List<CollectedBill>> fetchBill(int? customerId) async {
    http.Response response = await http.get(
      Uri.parse(AppUrl.collectedBill + "/all/$customerId"),
    );

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      List jsonResponse = json.decode(response.body);
      // await Future.delayed(Duration(seconds: 5));
      return jsonResponse
          .map((collectedBill) => new CollectedBill.fromJson(collectedBill))
          .toList();
    } else {
      throw Exception('Fail to load all bill from server');
    }
  }
}
