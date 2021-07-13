import 'package:bill_app/model/core/customer.dart';

class QRArguments {
  final String qrValue;
  final Customer? customer;

  QRArguments(this.qrValue, this.customer);
}