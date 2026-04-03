class AppointmentRequestOption {
  final int id;
  final String name;
  final double? price;
  final double? selectedCenterPrice;
  final int? centerId;

  const AppointmentRequestOption({
    required this.id,
    required this.name,
    this.price,
    this.selectedCenterPrice,
    this.centerId,
  });

  double? get displayPrice => selectedCenterPrice ?? price;

  factory AppointmentRequestOption.fromJson(Map<String, dynamic> json) {
    return AppointmentRequestOption(
      id: _asInt(json['id']),
      name: json['name']?.toString().trim() ?? '',
      price: _asNullableDouble(json['price']),
      selectedCenterPrice: _asNullableDouble(json['selected_center_price']),
      centerId: _asNullableInt(json['center_id']),
    );
  }
}

int _asInt(dynamic value) {
  if (value is int) {
    return value;
  }

  return int.tryParse(value?.toString() ?? '') ?? 0;
}

int? _asNullableInt(dynamic value) {
  if (value == null) {
    return null;
  }

  if (value is int) {
    return value;
  }

  return int.tryParse(value.toString());
}

double? _asNullableDouble(dynamic value) {
  if (value == null) {
    return null;
  }

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value.toString());
}
