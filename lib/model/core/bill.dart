import 'package:json_annotation/json_annotation.dart';

import 'bill_detail.dart';

part 'bill.g.dart';

@JsonSerializable()
class Bill {
  int? storeId;
  String? storeName;
  List<BillDetail>? billDetail;
  String? total;

  Bill({this.storeId, this.storeName, this.billDetail, this.total});

  factory Bill.fromJson(Map<String, dynamic> json) => _$BillFromJson(json);
  Map<String, dynamic> toJson() => _$BillToJson(this);
}
