import 'package:json_annotation/json_annotation.dart';

part 'bill_detail.g.dart';

@JsonSerializable()
class BillDetail {
  int? id;
  String? name;
  String? price;
  int? amount;
  String? total;

  BillDetail({this.id, this.name, this.price, this.amount, this.total});

  factory BillDetail.fromJson(Map<String, dynamic> json) =>
      _$BillDetailFromJson(json);
  Map<String, dynamic> toJson() => _$BillDetailToJson(this);
}
