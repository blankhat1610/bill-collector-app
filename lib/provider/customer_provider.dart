import 'package:bill_app/model/core/customer.dart';
import 'package:bill_app/model/helper/customer_preferences.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class CustomerProvider with ChangeNotifier {
  final customerPreferences = getIt.get<CustomerPreferences>();

  Customer? customer;

  getCustomer() async {
    customer = await customerPreferences.getCustomer();
    notifyListeners();
  }

  Future<void> setCustomer(Customer customer) async {
    await customerPreferences.saveCustomer(customer);
    await getCustomer();
    notifyListeners();
  }

  Future<void> removeCustomer() async {
    await customerPreferences.removeCustomer();
    // này là force hắn thành null à
    // variable trong ChangeNotifier thì phải cho thay đổi thì UI mới thay đổi
    // mẹ ơi, cả mớ thứ luôn, phải coi code lại hiểu cũng chết :v
    // :v thêm mấy dấu ? thôi ý mà
    // dau nớ để trả null à (check null ??)
    // nếu nó null thì nó lấy giá trị đằng sau ??
    // còn mấy dấu thang
    // force nó null luôn nhưng mà nó null sẽ bị crash app :v
    // chỉ dùng nó khi biết chắc chắn là nó ko null
    // cái .. là gì v, gọi hàm à
    // gọi hàm nhưng mà trả lại giá trị của biến gọi nó chứ ko phải là của hàm dc gọi
    customer = null;
    notifyListeners();
  }
}
