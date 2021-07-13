import 'dart:async';

import 'package:bill_app/model/core/customer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerPreferences {
  // ignore: missing_return
  Future<Customer> saveCustomer(Customer customer) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt("customerId", customer.customerId ?? -1);
    await prefs.setString("name", customer.name ?? "");
    await prefs.setString("phoneNumber", customer.phoneNumber ?? "");
    await prefs.setString("avatar", customer.avatar ?? "");
    await prefs.setString("address", customer.address ?? "");
    await prefs.setString("token", customer.token ?? "");

    return customer;
  }

  Future<Customer?> getCustomer() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int? customerId = prefs.getInt("customerId");
    String? name = prefs.getString("name");
    String? phoneNumber = prefs.getString("phoneNumber");
    String? avatar = prefs.getString("avatar");
    String? address = prefs.getString("address");
    String? token = prefs.getString("token");
    // nen code vs dart null safety
    // hong ranh lam

    if (customerId == null) return null;
    return Customer(
      customerId: customerId,
      name: name,
      phoneNumber: phoneNumber,
      avatar: avatar,
      address: address,
      token: token,
    );
  }

  Future<void> removeCustomer() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove("customerId");
    await prefs.remove("name");
    await prefs.remove("phoneNumber");
    await prefs.remove("avatar");
    await prefs.remove("address");
    await prefs.remove("token");
  }

  Future<String?> getToken(args) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    return token;
  }
}
