class Drone {
  String id;
  String name;
  String droneType; // 'Quadcopter' or 'Hexacopter'
  String cloudKitchenId;
  String cloudKitchenName;
  String status; // 'Active', 'Inactive', 'In Maintenance'
  double maxCarryCapacity; // in kg
  double flightRange; // in km
  int totalDeliveries;
  bool isActive;

  Drone({
    required this.id,
    required this.name,
    required this.droneType,
    required this.cloudKitchenId,
    required this.cloudKitchenName,
    this.status = 'Active',
    this.maxCarryCapacity = 2.5,
    this.flightRange = 5.0,
    this.totalDeliveries = 0,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'droneType': droneType,
      'cloudKitchenId': cloudKitchenId,
      'cloudKitchenName': cloudKitchenName,
      'status': status,
      'maxCarryCapacity': maxCarryCapacity,
      'flightRange': flightRange,
      'totalDeliveries': totalDeliveries,
      'isActive': isActive,
    };
  }

  static Drone fromJson(Map<String, dynamic> json) {
    return Drone(
      id: json['id'],
      name: json['name'],
      droneType: json['droneType'],
      cloudKitchenId: json['cloudKitchenId'],
      cloudKitchenName: json['cloudKitchenName'],
      status: json['status'] ?? 'Active',
      maxCarryCapacity: json['maxCarryCapacity'] ?? 2.5,
      flightRange: json['flightRange'] ?? 5.0,
      totalDeliveries: json['totalDeliveries'] ?? 0,
      isActive: json['isActive'] ?? true,
    );
  }
}
