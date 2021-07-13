class Customer {
  int? customerId;
  String? name;
  String? phoneNumber;
  String? address;
  String? avatar;
  String? token;

  Customer({
    this.customerId,
    this.name,
    this.address,
    this.avatar,
    this.phoneNumber,
    this.token,
  });

  factory Customer.fromJsonLogin(Map<String, dynamic> responseData) {
    return Customer(
      customerId: responseData['id'],
      name: responseData['name'],
      avatar: responseData['avatar'],
      phoneNumber: responseData['phone_number'],
      address: responseData['address'],
      token: responseData['accessToken'],
    );
  }

  factory Customer.fromJsonRegister(Map<String, dynamic> responseData) {
    return Customer(
      customerId: responseData['id'],
      name: responseData['name'],
      avatar: responseData['avatar'],
      phoneNumber: responseData['phone_number'],
      address: responseData['address'],
    );
  }
}
