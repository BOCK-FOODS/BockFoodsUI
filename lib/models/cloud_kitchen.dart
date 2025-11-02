class CloudKitchen {
  String id;
  String name;
  String cityId;
  String cityName;
  String area;
  String address;
  String contact;
  bool isActive;
  int totalMenuItems;

  CloudKitchen({
    required this.id,
    required this.name,
    required this.cityId,
    required this.cityName,
    required this.area,
    required this.address,
    required this.contact,
    this.isActive = true,
    this.totalMenuItems = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cityId': cityId,
      'cityName': cityName,
      'area': area,
      'address': address,
      'contact': contact,
      'isActive': isActive,
      'totalMenuItems': totalMenuItems,
    };
  }

  factory CloudKitchen.fromJson(Map<String, dynamic> json) {
    return CloudKitchen(
      id: json['id'],
      name: json['name'],
      cityId: json['cityId'],
      cityName: json['cityName'],
      area: json['area'],
      address: json['address'],
      contact: json['contact'],
      isActive: json['isActive'] ?? true,
      totalMenuItems: json['totalMenuItems'] ?? 0,
    );
  }
}