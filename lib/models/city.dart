class City {
  String id;
  String name;
  String state;
  bool isActive;
  int totalCloudKitchens;

  City({
    required this.id,
    required this.name,
    required this.state,
    this.isActive = true,
    this.totalCloudKitchens = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'state': state,
      'isActive': isActive,
      'totalCloudKitchens': totalCloudKitchens,
    };
  }

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      state: json['state'],
      isActive: json['isActive'] ?? true,
      totalCloudKitchens: json['totalCloudKitchens'] ?? 0,
    );
  }
}