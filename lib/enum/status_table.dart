enum StatusTable { available, occupied, reserved }

extension StatusTableExtension on StatusTable {
  String get description {
    switch (this) {
      case StatusTable.available:
        return 'Disponível';
      case StatusTable.occupied:
        return 'Ocupada';
      case StatusTable.reserved:
        return 'Reservada';
    }
  }

  static StatusTable fromName(String name) {
    return StatusTable.values.firstWhere(
      (e) => e.name.toLowerCase() == name.toLowerCase(),
      orElse: () => StatusTable.available,
    );
  }
}
