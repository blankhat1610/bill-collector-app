class VisitedStore {
  int? visitedStoreId;
  int? storeId;
  int? customerId;

  VisitedStore({this.visitedStoreId, this.storeId, this.customerId});

  factory VisitedStore.fromJson(Map<String, dynamic> responseData) {
    return VisitedStore(
      visitedStoreId: responseData['id'],
      storeId: responseData['store_id'],
      customerId: responseData['customer_id'],
    );
  }
}