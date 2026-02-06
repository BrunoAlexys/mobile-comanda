import 'package:mobile_comanda/enum/status_table.dart';

class Tables {
  final int id;
  final int numberTable;
  final int chairsAvailable;
  final StatusTable status;

  Tables({
    required this.id,
    required this.numberTable,
    required this.chairsAvailable,
    required this.status,
  });

  factory Tables.fromJson(Map<String, dynamic> json) {
    return Tables(
      id: json['id'],
      numberTable: json['numberTable'],
      chairsAvailable: json['chairsAvailable'],
      status: StatusTableExtension.fromName(json['status']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numberTable': numberTable,
      'chairsAvailable': chairsAvailable,
      'statusTable': status.toString().split('.').last,
    };
  }
}
