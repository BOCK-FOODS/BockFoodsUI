class Order {
  String id;
  String customerName;
  String cloudKitchenName;
  double totalAmount;
  String status;
  String orderDate;
  String deliveryAddress;

  Order({
    required this.id,
    required this.customerName,
    required this.cloudKitchenName,
    required this.totalAmount,
    required this.status,
    required this.orderDate,
    required this.deliveryAddress,
  });
}

class Customer {
  String id;
  String name;
  String email;
  String phone;
  String address;
  int totalOrders;
  bool isActive;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.totalOrders = 0,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'totalOrders': totalOrders,
      'isActive': isActive,
    };
  }
}

class DeliveryPartner {
  String id;
  String name;
  String phone;
  String vehicleNumber;
  String cityName;
  int totalDeliveries;
  double rating;
  bool isActive;

  DeliveryPartner({
    required this.id,
    required this.name,
    required this.phone,
    required this.vehicleNumber,
    required this.cityName,
    this.totalDeliveries = 0,
    this.rating = 4.5,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'vehicleNumber': vehicleNumber,
      'cityName': cityName,
      'totalDeliveries': totalDeliveries,
      'rating': rating,
      'isActive': isActive,
    };
  }
}