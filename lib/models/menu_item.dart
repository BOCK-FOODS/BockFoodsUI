class MenuItem {
  String id;
  String name;
  String description;
  double price;
  String category;
  String cloudKitchenId;
  String cloudKitchenName;
  String imageUrl;
  bool isAvailable;
  bool isVeg;
  String type; // 'food' or 'grocery'

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.cloudKitchenId,
    required this.cloudKitchenName,
    this.imageUrl = '',
    this.isAvailable = true,
    this.isVeg = true,
    this.type = 'food',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'cloudKitchenId': cloudKitchenId,
      'cloudKitchenName': cloudKitchenName,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
      'isVeg': isVeg,
      'type': type,
    };
  }

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      category: json['category'],
      cloudKitchenId: json['cloudKitchenId'],
      cloudKitchenName: json['cloudKitchenName'],
      imageUrl: json['imageUrl'] ?? '',
      isAvailable: json['isAvailable'] ?? true,
      isVeg: json['isVeg'] ?? true,
      type: json['type'] ?? 'food',
    );
  }
}