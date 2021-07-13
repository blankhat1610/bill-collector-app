class CollectedBill {
  int? collectedBillId;
  int? visitedStoreId;
  String? billJson;
  String? createdAt;
  String? updatedAt;

  CollectedBill({this.collectedBillId, this.visitedStoreId, this.billJson, this.createdAt, this.updatedAt});
  factory CollectedBill.fromJson(Map<String, dynamic> responseData) {
    return CollectedBill(
      collectedBillId: responseData['id'],
      visitedStoreId: responseData['visited_store_id'],
      billJson: responseData['bill_json'],
      createdAt: responseData['created_at'],
      updatedAt: responseData['updated_at'],
    );
  }
}