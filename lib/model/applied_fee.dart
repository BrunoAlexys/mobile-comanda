class AppliedFee {
  final int id;
  final String name;
  final double percentage;

  AppliedFee({required this.id, required this.name, required this.percentage});

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'percentage': percentage};
  }

  factory AppliedFee.fromJson(Map<String, dynamic> json) {
    return AppliedFee(
      id: json['id'],
      name: json['name'],
      percentage: (json['percentage'] as num).toDouble(),
    );
  }
}
