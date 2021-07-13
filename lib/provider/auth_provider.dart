import 'dart:async';

import 'package:bill_app/main.dart';
import 'package:bill_app/model/core/customer.dart';
import 'package:bill_app/model/helper/customer_preferences.dart';
import 'package:bill_app/model/services/app_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut
}

class AuthProvider with ChangeNotifier {
  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;
  Status get registeredInStatus => _registeredInStatus;

  Future<Map<String, dynamic>> login(
      String? phoneNumber, String? password) async {
    var result;

    final Map<String, dynamic> loginData = {
      'phone_number': phoneNumber,
      'password': password
    };

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    http.Response response = await http.post(
      Uri.parse(AppUrl.login),
      body: json.encode(loginData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      // var customerData = responseData['data'];

      Customer authCustomer = Customer.fromJsonLogin(responseData);

      getIt.get<CustomerPreferences>().saveCustomer(authCustomer);

      _loggedInStatus = Status.LoggedIn;
      notifyListeners();

      result = {
        'status': true,
        'message': 'Successful',
        'customer': authCustomer
      };
    } else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> register(
    String? name,
    String? phoneNumber,
    String? avatar,
    String? address,
    String? password,
  ) async {
    final Map<String, dynamic> registrationData = {
      'name': name,
      'phone_number': phoneNumber,
      'avatar': avatar,
      'address': address,
      'password': password,
    };

    _registeredInStatus = Status.Registering;
    notifyListeners();

    return await (http
        .post(Uri.parse(AppUrl.register),
            body: json.encode(registrationData),
            headers: {'Content-Type': 'application/json'})
        .then(onValue)
        .catchError(onError) as FutureOr<Map<String, dynamic>>);
  }

  static Future<FutureOr> onValue(http.Response response) async {
    var result;
    final Map<String, dynamic> responseData = json.decode(response.body);
    print("--------------------------------" + response.body);
    if (response.statusCode == 200) {
      print("----------------------------status 200");
      // var customerData = responseData['data'];

      // print("-----------------------Customer data: " + customerData);

      Customer authCustomer = Customer.fromJsonRegister(responseData);

      getIt.get<CustomerPreferences>().saveCustomer(authCustomer);
      result = {
        'status': true,
        'message': 'Successfully registered',
        'data': authCustomer
      };
    } else {
      result = {
        'status': false,
        'message': 'Registration failed',
        'data': responseData
      };
    }

    print("----------------Registration Result: " + result);

    return result;
  }

  static onError(error) {
    print("the error is $error");
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }
}
