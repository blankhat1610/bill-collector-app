// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillDetail _$BillDetailFromJson(Map<String, dynamic> json) {
  return BillDetail(
    id: json['id'] as int?,
    name: json['name'] as String?,
    price: json['price'] as String?,
    amount: json['amount'] as int?,
    total: json['total'] as String?,
  );
}

Map<String, dynamic> _$BillDetailToJson(BillDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'amount': instance.amount,
      'total': instance.total,
    };
