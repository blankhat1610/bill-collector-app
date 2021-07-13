// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bill _$BillFromJson(Map<String, dynamic> json) {
  return Bill(
    storeId: json['storeId'] as int?,
    storeName: json['storeName'] as String?,
    billDetail: (json['billDetail'] as List<dynamic>?)
        ?.map((e) => BillDetail.fromJson(e as Map<String, dynamic>))
        .toList(),
    total: json['total'] as String?,
  );
}

Map<String, dynamic> _$BillToJson(Bill instance) => <String, dynamic>{
      'storeId': instance.storeId,
      'storeName': instance.storeName,
      'billDetail': instance.billDetail,
      'total': instance.total,
    };
